targetScope = 'managementGroup'

@description('ID of the \'Contoso Governance Initiative\'')
param policyDefinitionSetId string

@description('Provide the virtual machine SKU.')
param skuNameValue string

@description('Provide the Azure locations to allow.')
param allowedLocationsValue array

resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2019-09-01' = {
  name: 'ContosoGovernance'
  properties: {
    displayName: 'Contoso governance initiative'
    description: 'Assign the Contoso governance initiative'
    metadata: {
      assignedBy: 'Cloud Center of Excellence'
    }
    notScopes: []
    policyDefinitionId: policyDefinitionSetId
    parameters: {
      init_skuName: {
        value: skuNameValue
      }
      init_allowedLocations: {
        value: allowedLocationsValue
      }
    }
  }
}
