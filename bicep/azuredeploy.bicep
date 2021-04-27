targetScope = 'subscription'

@description('Name of the Policy definition')
param policyDefinitionName string

@description('Name of the virtual machine SKU')
param vmSku object

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: policyDefinitionName
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      skuName: {
        type: 'String'
        metadata: {
          displayName: 'SKU Name'
          description: 'Name of the virtual machine SKU'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/virtualMachines'
          }
          {
            field: 'Microsoft.Compute/virtualMachines/sku.name'
            like: '[parameters(\'skuName\')]'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2019-09-01' = {
  name: 'deny-vm-sku'
  properties: {
    scope: subscription().id
    policyDefinitionId: subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyDefinitionName)
    parameters: vmSku
  }
  dependsOn: [
    policyDefinition
  ]
}
