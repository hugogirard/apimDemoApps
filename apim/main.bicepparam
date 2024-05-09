using 'main.bicep'

param ApimServiceName = readEnvironmentVariable('APIM_NAME')
param WebUrl = readEnvironmentVariable('FIBO_URL')
