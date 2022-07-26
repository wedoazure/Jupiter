param appNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param productFile string
param envFile string
param clientFile string
param serviceFile string
param locshortbool bool = locationFile =~ 'northeurope'
param addressFile string


var locshortStr = locshortbool ? 'ne' : 'we'


//deploy network resources
module netMDL 'Modules/net.bicep' = {
  name: 'net-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    appName: appNameFile
    product: productFile
    env: envFile
    client: clientFile
    service: serviceFile
    locShort: locshortStr
    address: addressFile
  }
}

//deploy monitor resources
module monMDL 'Modules/mon.bicep' = {
  name: 'mon-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    appName: appNameFile
    product: productFile
    env: envFile
    client: clientFile
    service: serviceFile
    locShort: locshortStr
  }
}

//deploy ASP resources
module aspMDL 'Modules/app.bicep' = {
  name: 'app-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    appName: appNameFile
    product: productFile
    env: envFile
    client: clientFile
    service: serviceFile
    locShort: locshortStr
    snet: netMDL.outputs.snet
  }
}

//deploy WAF resources
module wafMDL 'Modules/waf.bicep' = {
  name: 'waf-deploy'
  params: {
    date: dateNow
    email: emailFile
    appName: appNameFile
    product: productFile
    env: envFile
    client: clientFile
    service: serviceFile
  }
}

//deploy AFD resources
module afdMDL 'Modules/afd.bicep' = {
  name: 'afd-deploy'
  params: {
    date: dateNow
    email: emailFile
    appName: appNameFile
    product: productFile
    env: envFile
    client: clientFile
    service: serviceFile
    app: aspMDL.outputs.appURL
    waf: wafMDL.outputs.wafID
    law: monMDL.outputs.workspace
  }
}
