targetScope = 'subscription'

@description('The location of the resource group to create.')
param location string

@description('The name of the resource group to create.')
param name string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: name
  location: location
}

output resourceGroup string  = resourceGroup.id
