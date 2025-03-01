# Define variables
$ResourceGroup = "WWF-CloudInfra-RG"
$Location = "UK South"
$VMName = "WWF-SecureVM"
$VNetName = "WWF-VNet"
$SubnetName = "WWF-Subnet"
$NSGName = "WWF-NSG"
$PublicIP = "$VMName-PublicIP"
$VMSize = "Standard_B2s"  # Cost-effective VM
$AdminUsername = "WWFAdmin"
$AdminPassword = ConvertTo-SecureString "YourSecureP@ssword123!" -AsPlainText -Force

# Create a resource group
New-AzResourceGroup -Name $ResourceGroup -Location $Location

# Create a Virtual Network & Subnet
$VNet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Location $Location -Name $VNetName -AddressPrefix "10.0.0.0/16"
$Subnet = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix "10.0.1.0/24" -VirtualNetwork $VNet
$VNet | Set-AzVirtualNetwork

# Create a Network Security Group (NSG) to restrict access
$NSG = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroup -Location $Location -Name $NSGName

# Allow only RDP from a specific IP (replace with your IP)
$RuleRDP = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix "YourPublicIP" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
$NSG.SecurityRules.Add($RuleRDP)
$NSG | Set-AzNetworkSecurityGroup

# Create a Public IP for the VM
$PublicIPConfig = New-AzPublicIpAddress -Name $PublicIP -ResourceGroupName $ResourceGroup -Location $Location -AllocationMethod Static

# Create a Virtual Network Interface Card (NIC)
$NIC = New-AzNetworkInterface -Name "$VMName-NIC" -ResourceGroupName $ResourceGroup -Location $Location -SubnetId $VNet.Subnets[0].Id -NetworkSecurityGroupId $NSG.Id -PublicIpAddressId $PublicIPConfig.Id

# Create a Virtual Machine
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VMConfig = Set-AzVMOperatingSystem -VM $VMConfig -Windows -ComputerName $VMName -Credential (New-Object System.Management.Automation.PSCredential ($AdminUsername, $AdminPassword))
$VMConfig = Set-AzVMSourceImage -VM $VMConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest"
$VMConfig = Add-AzVMNetworkInterface -VM $VMConfig -Id $NIC.Id
New-AzVM -ResourceGroupName $ResourceGroup -Location $Location -VM $VMConfig

# Enable Azure Backup for Disaster Recovery
$VaultName = "WWFBackupVault"
$BackupPolicy = "DefaultPolicy"
$Vault = New-AzRecoveryServicesVault -ResourceGroupName $ResourceGroup -Name $VaultName -Location $Location
Set-AzRecoveryServicesBackupProperty -VaultId $Vault.ID -BackupStorageRedundancy LocallyRedundant
Enable-AzRecoveryServicesBackupProtection -Policy $BackupPolicy -VaultId $Vault.ID -Name $VMName


