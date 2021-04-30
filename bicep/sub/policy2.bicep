targetScope = 'subscription'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'AllowedLocations'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    displayName: 'Allowed locations'
    description: 'Restrict locations allowed for deployments'
    metadata: {
      category: 'Compute'
    }
    parameters: {
      allowedLocations: {
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
    policyRule: {
      if: {
        not: {
          field: 'location'
          in: '[parameters(\'allowedLocations\')]'
        }
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
