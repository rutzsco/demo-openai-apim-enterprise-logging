@description('The name of the API Management service instance')
param apiManagementServiceName string

@description('The email address of the owner of the service')
@minLength(1)
param apiManagmentPublisherEmail string

@description('The name of the owner of the service')
@minLength(1)
param apiManagmentPublisherName string

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Standard'
  'Premium'
])
param apiManagementSKU string = 'Developer'

@description('Location for all resources.')
param location string = resourceGroup().location

param apiManagmentLoggingEventHubNamespaceName string
param apiManagmentLoggingEventHubName string


// APIM - Core Service
module apim 'apim.bicep' = {
	name: 'apim'
	params: {
      location: location
      apiManagementServiceName: apiManagementServiceName
      apiManagmentPublisherEmail: apiManagmentPublisherEmail
      apiManagmentPublisherName: apiManagmentPublisherName
      sku: apiManagementSKU
      apiManagmentLoggingEventHubNamespaceName: apiManagmentLoggingEventHubNamespaceName
      apiManagmentLoggingEventHubName: apiManagmentLoggingEventHubName
}
}

// APIM - Policy
module apimConfig 'apim-policy-fragments.bicep' = {
	name: 'apimConfig'
	params: {
      apiManagementServiceName: apiManagementServiceName
}
}
