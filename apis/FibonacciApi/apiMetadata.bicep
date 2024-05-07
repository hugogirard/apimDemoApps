param ApimServiceName string
param WebUrl string

resource apim 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: ApimServiceName
}

resource ApimServiceName_fibonacci 'Microsoft.ApiManagement/service/apis@2023-05-01-preview' = {  
  name: 'FibonacciApi'
  parent: apim
  properties: {
    apiRevision: '2'
    isCurrent: true
    subscriptionRequired: true
    displayName: 'FibonacciApi'    
    format: 'openapi+json'
    value: loadTextContent('./openapi.json')
    serviceUrl: WebUrl
    path: 'Fibo'
    protocols: [
      'https'
    ]
  }  
  dependsOn: []
}
