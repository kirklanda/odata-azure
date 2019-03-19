#==============================================================================
# The top level script for creating a complete OData API environment


#==============================================================================
# Parameters
Param(
	[Parameter(Mandatory=$true)]
	[string]$ResourceGroupName = "Dev-RG",
	[Parameter(Mandatory=$true)]
	[string]$AppServicePlanName = "OData-App-Svc-Plan"
)

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
# Create the Azure Web App that will provide the backend API onto the AdventureWorksLT database.

.\New-AzureWebApp.ps1 -ResourceGroupName $ResourceGroupName -AppServicePlanName $AppServicePlanName
