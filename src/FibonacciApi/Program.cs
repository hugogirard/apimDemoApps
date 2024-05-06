using System.Reflection;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton<IFibonacciRepository, FibonacciRepository>();

var app = builder.Build();

string cnxString = app.Configuration["COSMOS_CONNECTION_STRING"];

app.UseSwagger();
app.UseSwaggerUI();


app.UseHttpsRedirection();

app.MapGet("/fibonacci/{n}", async ([FromServices] IFibonacciRepository repository, int n) =>
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

        fibonacciNumber = new FibonacciNumber
        {
            RowKey = n.ToString(),
            Sequence = fibonacciNumbers
        };

        await repository.UpdateSequenceAsync(fibonacciNumber);

        return fibonacciNumbers;        
    }
    return fibonacciNumber.Sequence;
    

})
.WithName("GetFibonacciNumbers")
.WithOpenApi(generatedOperation =>
{
    var parameter = generatedOperation.Parameters[0];
    parameter.Description = "The sequence number to generate";
    return generatedOperation;
});

app.MapDelete("/fibonacci/{n}", ([FromServices] IFibonacciRepository repository, int n) =>
{
    return Results.NoContent();
})
.WithName("DeleteSavedSequence")
.WithOpenApi();

app.Run();