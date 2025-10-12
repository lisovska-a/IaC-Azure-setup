param(
    [string]$SUBS,
    [string]$RG
)

if (-not $SUBS) {
    Write-Error "Subscription ID is required. Usage: .\CreateSP.ps1 -SUBS <subscription-id> -RG <resource-group>"
    exit 1
}

if (-not $RG) {
    Write-Error "Resource Group is required. Usage: .\CreateSP.ps1 -SUBS <subscription-id> -RG <resource-group>"
    exit 1
}

$SCOPE = "/subscriptions/$SUBS/resourceGroups/$RG"

Write-Host "Creating Service Principal with Contributor role on scope: $SCOPE"

# Contributor is usually enough; add User Access Administrator if TF will assign roles.
az ad sp create-for-rbac --name "sp-nebo-tf"  --role "Contributor"  --scopes "$SCOPE"