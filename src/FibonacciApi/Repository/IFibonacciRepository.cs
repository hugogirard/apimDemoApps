namespace Fibonacci.Api.Repository;

public interface IFibonacciRepository
{
    Task<FibonacciNumber?> GetSequenceAsync(int len);
    Task UpdateSequenceAsync(int len, IEnumerable<int> sequence);

    Task DeleteSequenceAsync(int len);

}