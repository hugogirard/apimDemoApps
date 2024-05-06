param location string
param appInsightsName string
param cosmosDbName string
param suffix string

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: appInsightsName
}

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' existing = {
  name: cosmosDbName  
}

var cosmosDbConnectionString = cosmosdb.listConnectionStrings().connectionStrings[0].connectionString

resource asp 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-${suffix}'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  properties: {
  }
}

resource web 'Microsoft.Web/sites@2023-01-01' = {
  name: 'fiboapi-${suffix}'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }            
        {
          name: 'COSMOS_CONNECTION_STRING'
          value: cosmosDbConnectionString   
        }
      ]
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
      netFrameworkVersion: 'v8.0'
      alwaysOn: true
    }
  }  
}

output fiboApiName string = web.name
