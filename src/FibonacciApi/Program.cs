using System.Reflection;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton<IFibonacciRepository, FibonacciRepository>();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();


app.UseHttpsRedirection();


app.MapGet("/fibonacci/{n}", async ([FromServices]IFibonacciRepository repository, int n) => 
{
    var fibonacciNumber = await repository.GetSequenceAsync(n); 

    if (fibonacciNumber == null)
    {
        var fibonacciNumbers = new List<int> { 0, 1 };
        while (fibonacciNumbers.Count < n)
        {
            var previous = fibonacciNumbers[fibonacciNumbers.Count - 1];
            var current = fibonacciNumbers[fibonacciNumbers.Count - 2];
            fibonacciNumbers.Add(previous + current);
        }        
        await repository.UpdateSequenceAsync(n, fibonacciNumbers);
        return fibonacciNumbers;
    }

    return JsonSerializer.Deserialize<IEnumerable<int>>(fibonacciNumber.Sequence);
})
.WithName("GetFibonacciNumbers")
.WithOpenApi(generatedOperation =>
{
    var parameter = generatedOperation.Parameters[0];
    parameter.Description = "The sequence number to generate";
    return generatedOperation;
});

app.MapDelete("/fibonacci/{n}", async ([FromServices] IFibonacciRepository repository, int n) =>
{
    // Validate if the sequence exists in the storage
    var fibonacciNumber = await repository.GetSequenceAsync(n); 

    if (fibonacciNumber != null)
    {
        await repository.DeleteSequenceAsync(n);
        return Results.NoContent();
    }

    return Results.NoContent();
})
.WithName("DeleteSavedSequence")
.WithOpenApi(generatedOperation =>
{
    var parameter = generatedOperation.Parameters[0];
    parameter.Description = "The sequence number delete from the store";
    return generatedOperation;
});

app.Run();