# An Azure Automation Runbook to setup an AdventureWorksLT database on B pricing tier for development
# purposes.  B pricing is about $8 per month at the moment.
# The script creates a logical SQL Server as well as the SQL Database on that server.  The pricing
# is for the database and not the server.

#==============================================================================
# Parameters
Param(
	[string]$ResourceGroupName
	[string]$AdminUser
	[string]$AdminPassword
)


#==============================================================================
# Variables
# Corresponds to the pricing tier to use.  Use the most basic for development.
$RequestedServiceObjectiveName = "B"

# The logical server name
$ServerName = "server-$(Get-Random)"

# The sample database name
$DatabaseName = "DevSampleDB"

# The IP address range that is allowed access to the server
$StartIP = "0.0.0.0"
$EndIP = "0.0.0.0"


#==============================================================================
# Authenticate using a Run As connection with Azure.  The Automation Account will exist within
# a given Azure subscription and the AzureRunAsConnection is created when the Automation Account
# is created.
# In the Azure portal look in Connections property for the Automation Account.
$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-Account -ServicePrincipal -Tenant $connection.TenantID `
-ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint

$AzureContext = Set-AzContext -SubscriptionId $connection.SubscriptionID


#==============================================================================

Get-AzResource -ResourceGroupName $ResourceGroupName -DefaultProfile $AzureContext