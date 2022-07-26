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
var kvName = 'kv-${appName}-${date}-${locShort}'
var afdID = '205478c0-bd83-4e1b-a9d6-db63a3e1e1c8'

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: kvName
  location: location
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    accessPolicies: [
      {
        objectId: afdID
        permissions: {
          certificates: [
            'list'
            'get'
          ]
          keys: [
            'list'
            'get'
          ]
          secrets: [
            'list'
            'get'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
    }
  }
}

output kvRes string = kv.name
