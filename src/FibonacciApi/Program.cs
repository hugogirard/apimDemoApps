var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();


app.UseHttpsRedirection();

app.MapGet("/fibonacci/{n}", (int n) =>
{
    var fibonacciNumbers = new List<int> { 0, 1 };
    while (fibonacciNumbers.Count < n)
    {
        var previous = fibonacciNumbers[fibonacciNumbers.Count - 1];
        var current = fibonacciNumbers[fibonacciNumbers.Count - 2];
        fibonacciNumbers.Add(previous + current);
    }
    return fibonacciNumbers;
})
.WithName("GetFibonacciNumbers")
.WithOpenApi();
