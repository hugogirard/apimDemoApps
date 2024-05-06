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