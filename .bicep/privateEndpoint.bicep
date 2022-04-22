param privateEndpointName string
param Location string
param privateLinkName string
param webAppId string
param subnetId string

resource privateEndpiont 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: Location

  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: privateLinkName
        properties: {
          privateLinkServiceId: webAppId
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

param dnsGroupName string
param privateDnsZoneId string
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: dnsGroupName
  parent: privateEndpiont
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
  
}
