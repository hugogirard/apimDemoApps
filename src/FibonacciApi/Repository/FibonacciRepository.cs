using System.Text.Json;
using Azure;
using Azure.Data.Tables;
using Microsoft.Extensions.Logging;

namespace Fibonacci.Api.Repository;

public class FibonacciRepository : IFibonacciRepository
{
    private readonly TableClient _tableClient;
    private readonly ILogger<FibonacciRepository> _logger;

    public FibonacciRepository(IConfiguration configuration, ILogger<FibonacciRepository> logger)
    {
        // New instance of the TableClient class
        TableServiceClient tableServiceClient = new TableServiceClient(configuration["COSMOS_CONNECTION_STRING"]);

        // New instance of TableClient class referencing the server-side table
        _tableClient = tableServiceClient.GetTableClient(
            tableName: "sequence"
        );

        _logger = logger;
    }

    public async Task<FibonacciNumber?> GetSequenceAsync(int len)
    {
        try
        {
            var fibonacciNumber = await _tableClient.GetEntityAsync<FibonacciNumber>(
                partitionKey: "fibonacci",
                rowKey: len.ToString()
            );
            
            return fibonacciNumber?.Value ?? null;            
        }
        catch (RequestFailedException ex) when (ex.Status == 404) // This possible error code, no needs to log it
        {
            return null;
        }
        catch (Exception ex)
        {            
            _logger.LogError(ex, "Error getting sequence");
            return null;
        }

    }

    public async Task UpdateSequenceAsync(int len, IEnumerable<int> sequence)
    {   
        try
        {
            FibonacciNumber newSequence = new()
            {
                PartitionKey = "fibonacci",
                RowKey = len.ToString(),
                Sequence = JsonSerializer.Serialize(sequence)
            };
            await _tableClient.UpsertEntityAsync(newSequence);            
        }   
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating sequence");                
        }
    }

    public async Task DeleteSequenceAsync(int len)
    {
        try
        {
            await _tableClient.DeleteEntityAsync(
                partitionKey: "fibonacci",
                rowKey: len.ToString()
            );
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting sequence");
        }
    }
}
