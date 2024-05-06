param location string
param suffix string

var locations = [
  {
    locationName: location
    failoverPriority: 0
    isZoneRedundant: false
  }
]


resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: 'cosmosdb-${suffix}'
  location: location
  properties: {
    capabilities: [
      {
        name: 'EnableTable'
      }
    ]
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Eventual'
    }
    locations: locations    
  }
}

resource table 'Microsoft.DocumentDB/databaseAccounts/tables@2023-11-15' = {
  parent: cosmosdb
  name: 'sequence'
  properties: {
    resource: {
      id: 'sequence'
    }
    options: {
      throughput: 400
    }    
  }
}

output cosmosdbName string = cosmosdb.name
