# Create the Resource Group for the deployment
$rg = New-AzResourceGroup -Name 'VnetPeeringLab' -Location 'Eastus'

# Create the KeyVault in the resource group.
$vault = New-AzKeyVault -Name 'VnetPeeringLabKVeus' -ResourceGroupName $rg -Location 'Eastus' -EnabledForDeployment -EnabledForTemplateDeployment

# Create the admin username and admin password secrets for the vm
$secret1 = ConvertTo-SecureString 'Username' -AsPlainText -Force
$secret2 = ConvertTo-SecureString 'Password' -AsPlainText -Force

# Add the secrets to key vault
Set-AzKeyVaultSecret -VaultName $vault -Name "AdminUsername" -SecretValue $secret1
Set-AzKeyVaultSecret -VaultName $vault -Name "AdminPassword" -SecretValue $secret2