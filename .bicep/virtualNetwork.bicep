param vnetName string
param virtualNetwork_CIDR string


param Location string = resourceGroup().location
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetwork_CIDR
      ]
    }

    // subnets: [
    //   {
    //     name: subnet1Name
    //     properties: {
    //       addressPrefix: subnet1AddressPrefix
    //       delegations: [
    //         {
    //           name: 'appServiceDelegation'
    //           properties: {
    //             serviceName: 'Microsoft.Web/serverFarms'
    //           }
    //         }
    //       ]
    //     }
    //   }

    //   {
    //     name: subnet2Name
    //     properties: {
    //       addressPrefix: subnet2AddressPrefix
    //     }
    //   }
    // ]
  }
}

output VnetId string = virtualNetwork.id

