param location string
param appInsightsName string
param cosmosDbName string
param suffix string
param apimIpAddress string

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: appInsightsName
}

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' existing = {
  name: cosmosDbName  
}

var cosmosDbConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${cosmosdb.name};AccountKey=${cosmosdb.listKeys().primaryMasterKey};TableEndpoint=https://${cosmosdb.name}.table.cosmos.azure.com:443/;'

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
      publicNetworkAccess: 'Enabled'
      ipSecurityRestrictions: [
        {
          ipAddress: '${apimIpAddress}/32'
          action: 'Allow'
          priority: 100
          name: 'AllowOnlyAPIM'
          description: 'Allow only APIM'
        }
        {
          ipAddress: 'Any'
          action: 'Deny'
          priority: 200
          name: 'DenyAll'
          description: 'Deny all'
        }
      ]
      ipSecurityRestrictionsDefaultAction: 'Deny'
    }
  }  
}

output fiboApiName string = web.name
output fibiApiUrl string = 'https://${web.properties.defaultHostName}'
