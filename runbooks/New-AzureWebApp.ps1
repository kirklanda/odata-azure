# An Azure Automation Runbook to create an Azure App Service Plan and Azure Web App.

#==============================================================================
# Parameters
Param(
#	[Parameter(Mandatory=$true)]
#	[Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]$AzureContext,
	[Parameter(Mandatory=$true)]
	[string]$ResourceGroupName = "Dev-RG",
	[Parameter(Mandatory=$true)]
	[string]$AppServicePlanName = "OData-App-Svc-Plan"
)

#==============================================================================
# Variables
# Corresponds to the pricing tier to use.  Use the most basic for development.
$Tier = "Free"

# The Location to create the resources
$Location = "australiasoutheast"

#App Service Plan Workers
$NumberOfWorkers = 1
$WorkerSize = "Small"

$appServicePlan = New-AzAppServicePlan -ResourceGroupName $ResourceGroupName -Name $AppServicePlanName -Location $Location -Tier $Tier -NumberOfWorkers $NumberOfWorkers