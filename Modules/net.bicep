param location string
param date string
param email string
param appName string
param product string
param env string
param client string
param service string
param locShort string
param address string


//working variables
var vnetName = 'vnet-${appName}-${env}-${locShort}'

var firstOutput = split(address, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]
var mask3 = firstOutput[2]

var sub1 = '${mask1}.${mask2}.${mask3}.0/26'
var sub2 = '${mask1}.${mask2}.${mask3}.64/26'



resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        address
      ]
    }
    subnets: [
      {
        name: 'snet-asp'
        properties: {
          addressPrefix: sub1
       }
      }
      {
        name: 'snet-test'
        properties: {
          addressPrefix: sub2
        }
      }
    ]
  }
}

output net string = vnet.id
