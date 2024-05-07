using Azure;
using Azure.Data.Tables;
using System.Collections.Generic;

namespace FibonacciApi.Models;

public class FibonacciNumber : ITableEntity
{
    public string RowKey { get; set; } = default!;
    public string PartitionKey { get; set; } = default!;
    public string Sequence { get; set; } = default!;
    public ETag ETag { get; set; }
    public DateTimeOffset? Timestamp { get; set; }
}
