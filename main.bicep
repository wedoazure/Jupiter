param appNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param productFile string
param envFile string
param clientFile string
param serviceFile string
param locshortbool bool = locationFile =~ 'northeurope'


var locshortStr = locshortbool ? 'ne' : 'we'

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
  }
}

//deploy ASP resources
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
  }
}
