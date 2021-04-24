# Create a new policy definition
$definitionParams = @{
  Name = "DenyVMSku"
  DisplayName = "Deny VM SKU"
  Description = "Deny specific virtual machine SKU"
  Metadata = '{"category":"Compute"}'
  Parameter = "bp_policy_parameters.json"
  Policy = "bp_policy_rules.json"
}

$definition = New-AzPolicyDefinition @definitionParams

# Create an initiative
$policyDefinition = @"
[
    {
        "policyDefinitionId": "$($definition.ResourceId)",
        "parameters": {
            "skuName": {
                "value": "[parameters('skuName')]"
            }
        }
    }
]
"@

$initiativeParams = @{
  Name = "DenyVMSkuPolicySet"
  DisplayName = "Deny VM SKU Policy Set"
  Description = "Deny specific virtual machine SKU"
  Metadata = '{"category":"Compute"}'
  Parameter = '{ "skuName": { "type": "string" } }'
  PolicyDefinition = $policyDefinition
}

$initiative = New-AzPolicySetDefinition @initiativeParams

# Assign the initiave to the subscription, excluding the resource group
$assignParams = @{
  Name = "DenyVMSkuAssignment"
  DisplayName = "Deny VM SKU Policy Set Assignment"
  Scope = "/subscriptions/$((Get-AzContext).Subscription.Id)"
  PolicyParameterObject = @{'skuName'='Standard_H*'}
  PolicySetDefinition = $initiative
}

New-AzPolicyAssignment @assignParams