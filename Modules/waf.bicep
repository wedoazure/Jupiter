param date string
param email string
param appName string
param product string
param env string
param client string
param service string

//working variables
var wafName = 'waf-afd-${appName}-${env}'



resource afdWAF 'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2020-11-01' = {
  name: wafName
  location:'Global'
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
     
     
     policySettings: {
        mode: 'Prevention'
        customBlockResponseStatusCode: 406
        customBlockResponseBody: base64('<html><head><title>You are blocked</title></head><body bgcolor="#FFB299"><p><h1>WAF custom response</h1>You are being blocked. If you need access, contact support with this reference{{azure-ref}}</p></body></html>')
     }
     
   }
}

output wafID string = afdWAF.id
