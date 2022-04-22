param appServicePlanName string

@allowed([
  'linux'
  'windows'
])
param oSType string

param Location string = resourceGroup().location

@allowed([
  'dev'
  'prod'
])
param environmentType string

@allowed([
  'F1'
  'B1'
])
param appServicePlanSkuDev string

@allowed([
  'P1v2'
  'P1v3'
  'P2v2'
  'P2v3'
  'P3v2'
  'P3v3'
])
param appServicePlanSkuProd string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: Location
  kind: oSType
  properties: {
    
  }
  sku: {
    name: (environmentType == 'prod') ? appServicePlanSkuProd : appServicePlanSkuDev
    
  } 
}
