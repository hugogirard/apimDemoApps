param ApimServiceName string
param WebUrl string

module fiboapi 'apis/FibonacciApi/apiMetadata.bicep' = {
  name: 'fiboapi'
  params: {
    ApimServiceName: ApimServiceName
    WebUrl: WebUrl
  }
}

module productMath 'products/math.bicep' = {
  name: 'productMath'
  params: {
    ApimServiceName: ApimServiceName    
  }
}
