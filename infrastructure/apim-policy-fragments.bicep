param apiManagementServiceName string
param quotaQueryURL string = 'TBD'
param QuotaQueryKey string = 'TBD'

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource namedValue_QuotaQueryURL 'Microsoft.ApiManagement/service/namedValues@2022-09-01-preview' = {
  name: 'QuotaQueryURL'
  parent: apiManagementService
  properties: {
    displayName: 'QuotaQueryURL'
    secret: false
    value: quotaQueryURL
  }
}

resource namedValue_QuotaQueryKey 'Microsoft.ApiManagement/service/namedValues@2022-09-01-preview' = {
  name: 'QuotaQueryKey'
  parent: apiManagementService
  properties: {
    displayName: 'QuotaQueryKey'
    secret: false
    value: QuotaQueryKey
  }
}

resource myFragment 'Microsoft.ApiManagement/service/policyFragments@2022-08-01' = {
  name: 'demo-fragment'
  parent: apiManagementService
  properties: {
    description: 'x-request-context-data'
    format: 'rawxml'
    value: loadTextContent('apim-policy-fragment-demo.xml')
  }
}


