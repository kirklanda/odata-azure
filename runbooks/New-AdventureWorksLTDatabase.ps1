# An Azure Automation Runbook to setup an AdventureWorksLT database on B pricing tier for development
# purposes.  B pricing is about $8 per month at the moment.
# The script creates a logical SQL Server as well as the SQL Database on that server.  The pricing
# is for the database and not the server.

#==============================================================================
# Parameters
Param(
	[Parameter(Mandatory=$true)]
	[string]$ResourceGroupName = "Dev-RG",
	[Parameter(Mandatory=$true)]
	[string]$AdminUser = "SqlAdmin",
	[Parameter(Mandatory=$true)]
	[string]$AdminPassword
)


#==============================================================================
# Variables
# Corresponds to the pricing tier to use.  Use the most basic for development.
$RequestedServiceObjectiveName = "Basic"

# The logical server name
$ServerName = "server-castnet-dev-db"

# The sample database name
$DatabaseName = "DevAdventureWorksLT"

# The Location to create the resources
$Location = "australiasoutheast"

# The IP address range that is allowed access to the server
$StartIP = "0.0.0.0"
$EndIP = "0.0.0.0"


#==============================================================================
# Authenticate using a Run As connection with Azure.  The Automation Account will exist within
# a given Azure subscription and the AzureRunAsConnection is created when the Automation Account
# is created.
# In the Azure portal look in Connections property for the Automation Account.
$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzAccount -ServicePrincipal -Tenant $connection.TenantID `
-ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint

$AzureContext = Set-AzContext -SubscriptionId $connection.SubscriptionID


#==============================================================================
# Create a SQL Server, Firewall rule and AdventureWorksLT Database
$server = New-AzSqlServer -ResourceGroupName $ResourceGroupName `
	-ServerName $ServerName `
	-Location $Location `
	-SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AdminUser, $(ConvertTo-SecureString -String $AdminPassword -AsPlainText -Force))


# Create a server firewall rule that allows access from the specified IP addresses
$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName `
	-ServerName $ServerName `
	-FirewallRuleName "AllowIPs" -StartIpAddress $StartIP -EndIpAddress $EndIP


$database = New-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
	-ServerName $ServerName `
	-DatabaseName $DatabaseName `
	-RequestedServiceObjectiveName $RequestedServiceObjectiveName `
	-SampleName "AdventureWorksLT"