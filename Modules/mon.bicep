param location string
param date string
param email string
param appName string
param product string
param env string
param client string
param service string
param locShort string


//working variables
var lawName = 'law-${appName}-${env}-${locShort}'
var appiName = 'ai-${appName}-${env}-${locShort}'

resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: lawName
  location: location
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appI 'Microsoft.Insights/components@2020-02-02' = {
  name: appiName
  location: location
  kind: 'web'
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: law.id
  }
}

output workspace string = law.id
//output appiKey string = appI.properties.InstrumentationKey
//output appiString string = appI.properties.ConnectionString
output appiProp object = appI.properties
