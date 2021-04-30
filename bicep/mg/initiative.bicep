targetScope = 'managementGroup'

@description('ID of the \'Deny VM SKU\' Policy definition.')
param policyDefinition1Id string

@description('ID of the \'Allowed locations\' Policy definition.')
param policyDefinition2Id string

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2019-09-01' = {
  name: 'ContosoGovernance'
  properties: {
    policyType: 'Custom'
    displayName: 'Contoso Governance Initiative'
    description: 'Contoso governance for VM SKUs and allowed locations'
    metadata: {
      category: 'Compute'
    }
    parameters: {
      init_skuName: {
        type: 'String'
        metadata: {
          displayName: 'SKU Name'
          description: 'Name of the virtual machine SKU'
        }
      }
      init_allowedLocations: {
        type: 'Array'
        metadata: {
          description: 'The list of locations that can be specified when deploying resources'
          strongType: 'location'
          displayName: 'Allowed locations'
        }
        allowedValues: [
          'westeurope'
          'northeurope'
        ]
        defaultValue: [
          'westeurope'
        ]
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: policyDefinition1Id
        parameters: {
          skuName: {
            value: '[parameters(\'init_skuName\')]'
          }
        }
      }
      {
        policyDefinitionId: policyDefinition2Id
        parameters: {
          allowedLocations: {
            value: '[parameters(\'init_allowedLocations\')]'
          }
        }
      }
    ]
  }
}
