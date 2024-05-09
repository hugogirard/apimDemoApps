param suffix string

// Canada is not available at this moment
var location = 'eastus'


resource apiCenter 'Microsoft.ApiCenter/services@2023-07-01-preview' = {
  name: 'apicenter-${suffix}'
  location: location
  sku: {
    name: 'Free'
  }
}
