@description('The location of where the resources are to be deployed')
param location string

@description('The location of where the resources are to be deployed.')
param location2 string

@description('The name of the first virtual network.')
param virtualNetwork0Name string

@description('The name of the second virtual network.')
param virtualNetwork1Name string

@description('The name of the third virtual network.')
param virtualNetwork2Name string

@description('The Name of the first network interface card.')
param vm0NetworkInterfaceName string

@description('The Name of the second network interface card.')
param vm1NetworkInterfaceName string

@description('The Name of the third network interface card.')
param vm2NetworkInterfaceName string

@description('The name of the first network security group.')
param networkSecurityGroup0Name string

@description('The name of the second network security group.')
param networkSecurityGroup1Name string

@description('The name of the third network security group.')
param networkSecurityGroup2Name string

@description('The name of the first virtual machine.')
param virtualMachine0Name string

@description('The name of the second virtual machine.')
param virtualMachine1Name string

@description('The name of the third virtual machine.')
param virtualMachine2Name string

@description('The name of the first vm disk.')
param osDisk0Name string

@description('The name of the second vm disk.')
param osDisk1Name string

@description('The name of the third vm disk.')
param osDisk2Name string

@description('The size of the virtual machine.')
param vmSize string

@description('The storage account type of the virtual machine managed disk.')
param virtualMachineManagedDiskStorageAccountType string

@description ('The admin username of the virtual machine.')
@secure()
param adminUsername string

@description('The admin password for the virtual machine.')
@secure()
param adminPassword string

@description('The name of the first public ip address.')
param publicIPAddress0Name string

@description('The name of the first public ip address.')
param publicIPAddress1Name string

@description('The name of the first public ip address.')
param publicIPAddress2Name string

@description('The Sku of the public ip address.')
param publicIPAddressSkuName string

var virtualNetwork0Config = {
  addressprefix: '10.0.0.0/16'
  subnetName: 'subnet0'
  subnetPrefix: '10.0.0.0/24'
}
var virtualNetwork1Config = {
  addressprefix: '10.50.0.0/16'
  subnetName: 'subnet0'
  subnetPrefix: '10.50.0.0/24'
}
var virtualNetwork2Config = {
  addressprefix: '10.80.0.0/16'
  subnetName: 'subnet0'
  subnetPrefix: '10.80.0.0/16'
}
var rdpNetworkSecurityGroupRuleConfig ={
  name: 'allowRDP'
  properties: {
  protocol: 'TCP'
  sourcePortRange: '*'
  destinationPortRange: '3389'
  sourceAddressPrefix: '*'
  destinationAddressPrefix: '*'
  access: 'Allow'
  priority: 300
  direction: 'Inbound'
 }
}
var virtualMAchineImageReference =  {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2019-Datacenter'
  version: 'latest'
}

resource networkSecurityGroup0 'Microsoft.Network/networkSecurityGroups@2023-06-01' ={
  name: networkSecurityGroup0Name
  location: location
  properties: {
    securityRules: [
      {
        name: rdpNetworkSecurityGroupRuleConfig.name
        properties: rdpNetworkSecurityGroupRuleConfig.properties
      }
    ]
  }
  resource RDPNetworkSecurityGroupRule 'securityRules' existing = {
    name: rdpNetworkSecurityGroupRuleConfig.name
  }
}

resource networkSecurityGroup1 'Microsoft.Network/networkSecurityGroups@2023-06-01' ={
  name: networkSecurityGroup1Name
  location: location
  properties: {
    securityRules: [
      {
        name: rdpNetworkSecurityGroupRuleConfig.name
        properties: rdpNetworkSecurityGroupRuleConfig.properties
      }
    ]
  }
  resource RDPNetworkSecurityGroupRule 'securityRules' existing = {
    name: rdpNetworkSecurityGroupRuleConfig.name
  }
}

resource networkSecurityGroup2 'Microsoft.Network/networkSecurityGroups@2023-06-01' ={
  name: networkSecurityGroup2Name
  location: location2
  properties: {
    securityRules: [
      {
        name: rdpNetworkSecurityGroupRuleConfig.name
        properties: rdpNetworkSecurityGroupRuleConfig.properties
      }
    ]
  }
  resource RDPNetworkSecurityGroupRule 'securityRules' existing = {
    name: rdpNetworkSecurityGroupRuleConfig.name
  }
}

resource virtualNetwork0 'Microsoft.Network/virtualNetworks@2023-06-01' ={
  name: virtualNetwork0Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetwork0Config.addressprefix
      ]
    }
    subnets: [
      {
        name: virtualNetwork0Config.subnetName
        properties: {
          addressPrefix: virtualNetwork0Config.subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }

  resource vnet0Subnet0 'subnets' existing = {
    name: virtualNetwork0Config.subnetName
  }

  resource vnet0peering1 'virtualNetworkPeerings' = {
    name: '${virtualNetwork0Name}-${virtualNetwork1Name}'
    properties:{
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: false
      allowGatewayTransit: false
      useRemoteGateways: false
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork: {
        id: virtualNetwork1.id
      }
    }
  }

  resource vnet0peering2 'virtualNetworkPeerings' = {
    name: '${virtualNetwork0Name}-${virtualNetwork2Name}'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: false
      allowGatewayTransit: false
      useRemoteGateways: false
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork:{
        id: virtualNetwork2.id
      }
    }
  }
}

resource virtualNetwork1 'Microsoft.Network/virtualNetworks@2023-06-01' ={
  name: virtualNetwork1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetwork1Config.addressprefix
      ]
    }
    subnets: [
      {
        name: virtualNetwork1Config.subnetName
        properties: {
          addressPrefix: virtualNetwork1Config.subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }

  resource vnet1Subnet0 'subnets' existing = {
    name: virtualNetwork1Config.subnetName
  }

  resource vnet1peering1 'virtualNetworkPeerings' = {
    name: '${virtualNetwork1Name}-${virtualNetwork0Name}'
    properties:{
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: false
      allowGatewayTransit: false
      useRemoteGateways: false
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork: {
        id: virtualNetwork0.id
      }
    }
  }

  resource vnet1peering2 'virtualNetworkPeerings' = {
    name: '${virtualNetwork1Name}-${virtualNetwork2Name}'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: false
      allowGatewayTransit: false
      useRemoteGateways: false
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork:{
        id: virtualNetwork2.id
      }
    }
  }
}

resource virtualNetwork2 'Microsoft.Network/virtualNetworks@2023-06-01' ={
  name: virtualNetwork2Name
  location: location2
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetwork2Config.addressprefix
      ]
    }
    subnets: [
      {
        name: virtualNetwork2Config.subnetName
        properties: {
          addressPrefix: virtualNetwork2Config.subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }

  resource vnet2Subnet0 'subnets' existing = {
    name: virtualNetwork2Config.subnetName
  }

  resource vnet2peering1 'virtualNetworkPeerings' = {
    name: '${virtualNetwork2Name}-${virtualNetwork0Name}'
    properties:{
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: false
      allowGatewayTransit: false
      useRemoteGateways: false
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork: {
        id: virtualNetwork0.id
      }
    }
  }

  resource vnet2peering2 'virtualNetworkPeerings' = {
    name: '${virtualNetwork2Name}-${virtualNetwork1Name}'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: false
      allowGatewayTransit: false
      useRemoteGateways: false
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork:{
        id: virtualNetwork1.id
      }
    }
  }
}

resource vm0NetworkInterface 'Microsoft.Network/networkInterfaces@2023-06-01' = {
  name: vm0NetworkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PublicIPAddress0.id
          }
          subnet: {
            id: virtualNetwork0::vnet0Subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroup0.id
    }
    nicType: 'Standard'
  }
}

resource vm1NetworkInterface 'Microsoft.Network/networkInterfaces@2023-06-01' = {
  name: vm1NetworkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PublicIPAddress1.id
          }
          subnet: {
            id: virtualNetwork1::vnet1Subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroup1.id
    }
    nicType: 'Standard'
  }
}

resource vm2NetworkInterface 'Microsoft.Network/networkInterfaces@2023-06-01' = {
  name: vm2NetworkInterfaceName
  location: location2
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PublicIPAddress2.id
          }
          subnet: {
            id: virtualNetwork2::vnet2Subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroup2.id
    }
    nicType: 'Standard'
  }
}

resource virtualMachine0 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachine0Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: virtualMAchineImageReference
      osDisk: {
        osType: 'Windows'
        name: osDisk0Name
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: virtualMachineManagedDiskStorageAccountType
        }
      }
    }
    osProfile: {
      computerName: virtualMachine0Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm0NetworkInterface.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachine1 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachine1Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: virtualMAchineImageReference
      osDisk: {
        osType: 'Windows'
        name: osDisk1Name
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: virtualMachineManagedDiskStorageAccountType
        }
      }
    }
    osProfile: {
      computerName: virtualMachine1Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm1NetworkInterface.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachine2 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachine2Name
  location: location2
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: virtualMAchineImageReference
      osDisk: {
        osType: 'Windows'
        name: osDisk2Name
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: virtualMachineManagedDiskStorageAccountType
        }
      }
    }
    osProfile: {
      computerName: virtualMachine2Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm2NetworkInterface.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource PublicIPAddress0 'Microsoft.Network/publicIPAddresses@2023-06-01' ={
  name: publicIPAddress0Name
  location: location
  sku: {
    name: publicIPAddressSkuName
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource PublicIPAddress1'Microsoft.Network/publicIPAddresses@2023-06-01' ={
  name: publicIPAddress1Name
  location: location
  sku: {
    name: publicIPAddressSkuName
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource PublicIPAddress2 'Microsoft.Network/publicIPAddresses@2023-06-01' ={
  name: publicIPAddress2Name
  location: location2
  sku: {
    name: publicIPAddressSkuName
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
