param date string
param email string
param appName string
param product string
param env string
param client string
param service string
param app string

//working variables
var afdName = 'afd-${appName}-${env}'


resource afd 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: afdName
  location: 'Global'
  tags: {
    Client: client
    Service: service
    Built: date
    Owner: email
    Product: product
  }
  sku: {
    name: 'Premium_AzureFrontDoor'
  }
  properties: {
    originResponseTimeoutSeconds: 60
  }
} 

resource afd_endpoint 'Microsoft.Cdn/profiles/afdendpoints@2021-06-01' = {
  parent: afd
  name: 'endpoint'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource afd_origingroup 'Microsoft.Cdn/profiles/origingroups@2021-06-01' = {
  parent: afd
  name: 'origingroup'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource afd_origin 'Microsoft.Cdn/profiles/origingroups/origins@2021-06-01' = {
  parent: afd_origingroup
  name: 'origin'
  properties: {
    hostName: app
    httpPort: 80
    httpsPort: 443
    originHostHeader: app
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

resource afd_endpoint_routes 'Microsoft.Cdn/profiles/afdendpoints/routes@2021-06-01' = {
  parent: afd_endpoint
  name: 'routes'
  properties: {
    originGroup: {
      id: afd_origingroup.id
    }
    supportedProtocols: [
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
}
