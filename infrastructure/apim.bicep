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
param sku string = 'Developer'

@description('The instance size of this API Management service.')
@allowed([
  1
  2
])
param skuCount int = 1

@description('Location for all resources.')
param location string = resourceGroup().location

param apiManagmentLoggingEventHubNamespaceName string
param apiManagmentLoggingEventHubName string
param eventHubSku string = 'Standard'

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: sku
    capacity: skuCount
  }
  properties: {
    publisherEmail: apiManagmentPublisherEmail
    publisherName: apiManagmentPublisherName
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: apiManagmentLoggingEventHubNamespaceName
  location: location
  sku: {
    name: eventHubSku
    tier: eventHubSku
    capacity: 1
  }
  properties: {
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  parent: eventHubNamespace
  name: apiManagmentLoggingEventHubName
  properties: {
    messageRetentionInDays: 7
    partitionCount: 1
  }
}

resource eventHubNamespaceName_eventHubName_ListenSend 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  parent: eventHub
  name: 'ListenSend'
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}
resource ehLoggerWithConnectionString 'Microsoft.ApiManagement/service/loggers@2022-04-01-preview' = {
  name: 'ApimEventHubLogger'
  parent: apiManagementService
  properties: {
    loggerType: 'azureEventHub'
    description: 'Event hub logger with connection string'
    credentials: {
      connectionString: eventHubNamespaceName_eventHubName_ListenSend.listKeys().primaryConnectionString
      name: 'ApimEventHub'
    }
  }
}
