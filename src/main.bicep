@description('The location into which regionally scoped resources should be deployed. Note that Front Door is a global resource.')
param location string

@description('The name of the App Service application to create. This must be globally unique.')
param appName string = 'adilkh-as-${uniqueString(resourceGroup().id)}'

@description('The name of the SKU to use when creating the App Service plan. This must be a SKU that is compatible with private endpoints, i.e. P1v2 or better.')
param appServicePlanSkuName string = 'F1'

@description('The number of worker instances of your App Service plan that should be provisioned.')
param appServicePlanCapacity int = 1

@description('The name of the Front Door endpoint to create. This must be globally unique.')
param frontDoorEndpointName string = 'adilkh-fd-${uniqueString(resourceGroup().id)}'

targetScope = 'resourceGroup'

module appService 'modules/app-service.bicep' = {
  name: 'appService'
  params: {
    location: location
    appName: appName
    appServicePlanSkuName: appServicePlanSkuName
    appServicePlanCapacity: appServicePlanCapacity
  }
}

module frontDoor 'modules/front-door.bicep' = {
  name: 'front-door'
  params: {
    skuName: 'Premium_AzureFrontDoor' // Private Link origins require the premium SKU.
    endpointName: frontDoorEndpointName
    originHostName: appService.outputs.appHostName
    privateEndpointResourceId: appService.outputs.appServiceResourceId
    privateLinkResourceType: 'sites' // For App Service and Azure Functions, this needs to be 'sites'.
    privateEndpointLocation: location
  }
}

output appServiceHostName string = appService.outputs.appHostName
output frontDoorEndpointHostName string = frontDoor.outputs.frontDoorEndpointHostName
