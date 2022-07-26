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

output workspace string = law.id
