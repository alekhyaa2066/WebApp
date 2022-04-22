param subnet2Id string
param Location string

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'vm1-nic'
  location: Location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet2Id
          }
          privateIPAddressVersion: 'IPv4'
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'vm1-publicIpAddress'
  location: Location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

param virtualMachineName string
param adminUserName string
param adminPassword string
param virtualMachineSize string
resource windowsVm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'vm1'
  location: Location
  properties: {
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUserName
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nic.id
        }
      ]
    }
  }

}
