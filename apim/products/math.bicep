param ApimServiceName string

resource apim 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: ApimServiceName
}

resource product 'Microsoft.ApiManagement/service/products@2023-05-01-preview' = {
  name: 'math'
  parent: apim
  properties: {
    displayName: 'Math APIS'
    description: 'Mathmatical operations APIS'
    subscriptionRequired: true
    approvalRequired: true
    subscriptionsLimit: 1
    state: 'published'
  }
}
