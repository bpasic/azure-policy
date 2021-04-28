# Create policy definition 1
$definition1Params = @{
  Name        = "DenyVMSku"
  DisplayName = "Deny VM SKU"
  Description = "Deny specific virtual machine SKU"
  Metadata    = '{"category":"Compute"}'
  Parameter   = "policy-1-parameters.json"
  Policy      = "policy-1-rule.json"
}

$definition1 = New-AzPolicyDefinition @definition1Params

# Create policy definition 2
$definition2Params = @{
  Name        = "AllowedLocations"
  DisplayName = "Allowed locations"
  Description = "Restrict locations allowed for deployments"
  Metadata    = '{"category":"Compute"}'
  Parameter   = "policy-2-parameters.json"
  Policy      = "policy-2-rule.json"
}

$definition2 = New-AzPolicyDefinition @definition2Params

# Create initiative parameters
$policyParameters = @"
{
  "init_skuName": {
    "type": "string",
    "metadata": {
      "displayName": "SKU Name",
      "description": "Name of the virtual machine SKU"
    }
  },
  "init_allowedLocations": {
    "type": "array",
    "metadata": {
      "description": "The list of locations that can be specified when deploying resources",
      "strongType": "location",
      "displayName": "Allowed locations"
    },
    "allowedValues": [
      "westeurope",
      "northeurope"
    ],
    "defaultValue": [
      "westeurope"
    ]
  }
}
"@

# Create initiative definition
$policyDefinition = @"
[
  {
    "policyDefinitionId": "$($definition1.ResourceId)",
      "parameters": {
        "skuName": {
          "value": "[parameters('init_skuName')]"
          }
      }
  },
  {
    "policyDefinitionId": "$($definition2.ResourceId)",
    "parameters": {
        "allowedLocations": {
            "value": "[parameters('init_allowedLocations')]"
        }
    }
  }
]
"@

$initiativeParams = @{
  Name             = "ContosoGovernance"
  DisplayName      = "Contoso Governance Initiative"
  Description      = "Contoso governance for VM SKUs and allowed locations"
  Metadata         = '{"category":"Compute"}'
  Parameter        = $policyParameters
  PolicyDefinition = $policyDefinition
}

$initiative = New-AzPolicySetDefinition @initiativeParams

# Define allowed locations
$allowedLocationsList = @('northeurope', 'westeurope')

# Assign initiave to the subscription
$assignParams = @{
  Name                  = "ContosoGovernance"
  DisplayName           = "Contoso governance initiative"
  Scope                 = "/subscriptions/$((Get-AzContext).Subscription.Id)"
  PolicyParameterObject = @{
    'init_skuName' = 'Standard_H*'
    'init_allowedLocations' = $allowedLocationsList
  }
  PolicySetDefinition   = $initiative
}

New-AzPolicyAssignment @assignParams