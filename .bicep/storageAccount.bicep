@minLength(3)
@maxLength(24)
@description('Name can contain only lowercase letters and numbers.')
param storageAccountName string
param Location string

// @allowed([
//   'dev'
//   'prod'
// ])
// param environmentType string
param storageAccountSku object
//var storageAccountSku = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
@allowed([
  'Hot'
  'Cool'
])
param accessTier string
//param storageSubnetId string
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: Location
  sku: {
    name: storageAccountSku.sku
  }
  kind: storageAccountSku.kind
  properties: {
    accessTier: accessTier
    // networkAcls: {
    //   defaultAction: 'Allow'
    //   virtualNetworkRules: [
    //     {
    //       id: storageSubnetId
    //     }
    //   ]
    // }
  }
  
}



output stoorageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name



