using 'main.bicep'

param location = 'canadacentral'
param rgName = 'rg-apim-demo'
param publisherName = 'Contoso'
param publisherEmail = readEnvironmentVariable('PUBLISHER_EMAIL')
