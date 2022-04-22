targetScope = 'subscription'

param subscriptionId string

param resourceGroupName string
param resourceGroupLocation string 
param env string
param taskNumber string
module task2rsg '.bicep/resoourceGroup.bicep' = {
  scope: subscription(subscriptionId)
  name: 'rsg'
  params: {
    env: env
    resourceGroupLocation: resourceGroupLocation
    resourceGroupName: resourceGroupName
    taskNumber: taskNumber
  }
}


param virtualNetwork_CIDR string
param vnetName string
module vnet '.bicep/virtualNetwork.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'virtualnetwork'
  params: {
    Location: resourceGroupLocation
    virtualNetwork_CIDR: virtualNetwork_CIDR
    vnetName: vnetName
  }
  dependsOn: [
    task2rsg
  ]
}

param subnet1_CIDR string
param subnet2_CIDR string
module subnets '.bicep/subnets.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'subnet'
  params: {
    subnet1_CIDR: subnet1_CIDR
    subnet2_CIDR: subnet2_CIDR
    vnetName: vnetName
  }
  dependsOn: [
    task2rsg
    vnet
  ]
}

param appServicePlanName string
param appServicePlanSkuDev string
param appServicePlanSkuProd string
//param environmentType string
param osType string

module servicePlan '.bicep/appServicePlan.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'appSericePlan'
  params: {
    Location: resourceGroupLocation
    appServicePlanName: appServicePlanName
    appServicePlanSkuDev: appServicePlanSkuDev
    appServicePlanSkuProd: appServicePlanSkuProd
    environmentType: env
    oSType: osType
  }
  dependsOn: [
    task2rsg
  ]
}


param webAppName string
param slotNames array
module webapp '.bicep/webApp.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'WebApp'
  params: {
    Location: resourceGroupLocation
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    slotNames: slotNames
  }
  dependsOn: [
    task2rsg
    servicePlan
  ]
}

param privateEndpointName string
param privateLinkName string
module webAppPrivateEndPoint '.bicep/privateEndpoint.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'privateEndPoint'
  params: {
    Location: resourceGroupLocation
    privateEndpointName: privateEndpointName
    privateLinkName: privateLinkName
    subnetId: subnets.outputs.Subnet1Id
    webAppId: webapp.outputs.webAppId
    dnsGroupName: 'DnsGroup'
    privateDnsZoneId: privateDns.outputs.privateDnsZoneId
  }
  dependsOn: [
    task2rsg
    webapp
  ]
}


param privateDnsZoneName string
module privateDns '.bicep/privateDnsZones.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'privateDns'
  params: {
    privateDnsZoneName: privateDnsZoneName
    vnetId: vnet.outputs.VnetId
  }
  dependsOn: [
    task2rsg
    vnet
  ]
}

param vmName string
param adminPassword string
param adminUserName string
param vmSize string
module windowsvm '.bicep/virtualMachine.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: vmName
  params: {
    adminPassword: adminPassword
    adminUserName: adminUserName
    Location: resourceGroupLocation
    subnet2Id: subnets.outputs.Subnet2Id
    virtualMachineName: vmName
    virtualMachineSize: vmSize
  }
  dependsOn: [
    task2rsg
    vnet
    subnets
  ]
}
// param accessTier string
// param blobContainer string
// param  storageAccountName string
// param storageAccountSku object
// module storage 'modules/storage/storageAccount.bicep' = {
//   name: 'storageAccount'
//   params: {
//     accessTier: accessTier
//     //blobContainer: blobContainer
//     Location: resourceGroupLocation
//     storageAccountName:  storageAccountName
//     storageAccountSku: storageAccountSku
//   }
// }

//    params.json

// "accessTier": {
//   "value": "Hot"
// },

// "storageAccountName": {
//   "value": "alexstorages2066"
// },

// "storageAccountSku": {
//   "value": {
//       "sku": "Standard_LRS",
//       "kind": "StorageV2"
//   }
// }
