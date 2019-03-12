#Parameters
Param(
	[string]$ResourceGroupName
)

# Authenticate using a Run As connection with Azure
$connection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzureRmAccount -ServicePrincipal -Tenant $connection.TenantID `
-ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint

$AzureContext = Select-AzureRmSubscription -SubscriptionId $connection.SubscriptionID

Get-AzureRmResource -ResourceGroupName $ResourceGroupName -AzureRmContext $AzureContext