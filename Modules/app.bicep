param location string
param date string
param email string
param appName string
param product string
param env string
param client string
param service string
param locShort string
param snet string
param aiProp object
param kvRes object

//working variables
var aspName = 'asp-${appName}-${env}-${locShort}'
var sku = 'S1'
var webName = 'app-${appName}-${env}-${locShort}'
var apiName = 'api-${appName}-${env}-${locShort}'
var stack = 'dotnet'
var kvRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: kvRes.Name
}

resource appSP 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: aspName
  location: location
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    reserved: false
  }
  sku: {
    name: sku
  }
  kind: 'windows'
}

resource appWeb 'Microsoft.Web/sites@2021-03-01' = {
  name: webName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    serverFarmId: appSP.id
    enabled: true
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      minTlsVersion: '1.2'
      netFrameworkVersion: 'v6.0'
      ftpsState: 'FtpsOnly'
    }
  }
}

resource appAPI 'Microsoft.Web/sites@2021-03-01' = {
  name: apiName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    serverFarmId: appSP.id
    virtualNetworkSubnetId: snet
    enabled: true
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      minTlsVersion: '1.2'
      netFrameworkVersion: 'v6.0'
      ftpsState: 'FtpsOnly'
    }
  }
}

resource stackAPI 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'metadata'
  parent: appAPI
  properties: {
    CURRENT_STACK: stack
  }
}

resource stackWeb 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'metadata'
  parent: appWeb
  properties: {
    CURRENT_STACK: stack
  }
}

resource settingsAPI 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: appAPI
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: aiProp.InstrumentationKey
    ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
    APPLICATIONINSIGHTS_CONNECTION_STRING: aiProp.ConnectionString
  }
}

resource settingsWeb 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: appWeb
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: aiProp.InstrumentationKey
    ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
    APPLICATIONINSIGHTS_CONNECTION_STRING: aiProp.ConnectionString
  }
}

resource kvWebRole 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(kvRes.name, appAPI.name, kvRole)
  scope: kv
  properties: {
    principalId: appWeb.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: kvRole
  }
}

resource kvApiRole 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(kvRes.name, appAPI.name, kvRole)
  scope: kv
  properties: {
    principalId: appAPI.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: kvRole
  }
}


output appURL string = appWeb.properties.defaultHostName
