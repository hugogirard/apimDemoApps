param location string
param publisherName string
param publisherEmail string
param suffix string

resource apim 'Microsoft.ApiManagement/service@2022-04-01-preview' = {
  name: 'apim-${suffix}'
  location: location
  properties: {      
      publisherEmail: publisherEmail
      publisherName: publisherName
  }
  identity: {
      type: 'SystemAssigned'
  }  
  sku: {
      name: 'Developer'
      capacity: 1
  }
}

output apimName string = apim.name
output apimIpAddress string = apim.properties.publicIPAddresses[0]
