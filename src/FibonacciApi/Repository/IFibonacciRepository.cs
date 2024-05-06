namespace Fibonacci.Api.Repository;

public interface IFibonacciRepository
{
    Task<FibonacciNumber?> GetSequenceAsync(int len);
    Task UpdateSequenceAsync(FibonacciNumber fibonacciNumber);

}