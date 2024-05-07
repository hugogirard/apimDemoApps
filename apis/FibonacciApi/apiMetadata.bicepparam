using 'apiMetadata.bicep'

param ApimServiceName = readEnvironmentVariable('APIM_NAME')
param WebUrl = readEnvironmentVariable('FIBO_URL')

