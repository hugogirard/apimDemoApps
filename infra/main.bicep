targetScope='subscription'

@description('The location where all resources will be created')
param location string 

@description('The name of the resource group')
param rgName string

@description('The Publisher name of APIM')
param publisherName string

@description('The email of the APIM admin')
@secure()
param publisherEmail string


var suffix = uniqueString(rg.id)

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module apim './modules/apim/apim.bicep' = {
  scope: rg
  name: 'apim'
  params: {
    location: location 
    suffix: suffix
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

module cosmosdb 'modules/cosmos/cosmosdb.bicep' = {
  scope: rg
  name: 'cosmosdb'
  params: {
    location: location
    suffix: suffix
  }
}

module monitoring 'modules/monitoring/appinsight.bicep' = {
  scope: rg
  name: 'monitoring'
  params: {
    location: location
    suffix: suffix
  }
}

module api 'modules/web/web.bicep' = {
  scope: rg
  name: 'api'
  params: {
    appInsightsName: monitoring.outputs.appInsightName
    cosmosDbName: cosmosdb.outputs.cosmosdbName
    location: location
    suffix: suffix
  }
}

output apimName string = apim.outputs.apimName
output fiboApiName string = api.outputs.fiboApiName
output fibiApiUrl string = api.outputs.fibiApiUrl
