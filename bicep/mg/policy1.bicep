targetScope = 'managementGroup'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'DenyVMSku'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    displayName: 'Deny VM SKU'
    description: 'Deny specific virtual machine SKU'
    metadata: {
      category: 'Compute'
    }
    parameters: {
      skuName: {
        type: 'String'
        metadata: {
          displayName: 'SKU Name'
          description: 'Name of the virtual machine SKU.'
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
