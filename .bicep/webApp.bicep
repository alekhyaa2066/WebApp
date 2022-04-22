
param appServicePlanName string

resource serviceplan 'Microsoft.Web/serverfarms@2021-03-01'  existing = {
  name: appServicePlanName
}

param webAppName string
param Location string = resourceGroup().location

resource webApp 'Microsoft.Web/sites@2021-03-01' = {
  name: webAppName
  location: Location
  properties: {
    serverFarmId: serviceplan.id
    httpsOnly: true
  }
}

// for subnet delegation
// param subnetId string
// resource webAppVnet 'Microsoft.Web/sites/networkConfig@2021-03-01' = {
//   parent: webApp
//   name: 'virtualNetwork'
//   properties: {
//     subnetResourceId: subnetId
//     swiftSupported: true
//   }

// }

param slotNames array
resource slots 'Microsoft.Web/sites/slots@2021-03-01' = [for slot in slotNames : {
  //parent: webApp
  name: '${webApp.name}/${slot}'
  location: Location
  properties: {
    enabled: true
  }
  
}]

output webAppId string = webApp.id
