#!/usr/bin/env bash
# Creates harmless test activity in a throwaway resource group so that the analytics rules have
# something to detect. Run it with the Azure CLI logged in. Nothing outside "sentlab-test-rg" is touched.
set -euo pipefail
export MSYS_NO_PATHCONV=1

RG="sentlab-test-rg"
LOCATION="${LOCATION:-norwayeast}"

echo "1/4 Creating test resource group $RG"
az group create --name "$RG" --location "$LOCATION" --output none

echo "2/4 Creating a role assignment (Reader) for yourself on the test group"
USER_ID=$(az ad signed-in-user show --query id --output tsv)
RG_ID=$(az group show --name "$RG" --query id --output tsv)
az role assignment create --assignee-object-id "$USER_ID" --assignee-principal-type User \
  --role Reader --scope "$RG_ID" --output none

echo "3/4 Provoking failed operations (reading a group that does not exist)"
for i in 1 2 3 4 5 6; do
  az group show --name "sentlab-does-not-exist-$i" --output none 2>/dev/null || true
done

echo "4/4 Deleting the test resource group"
az group delete --name "$RG" --yes --no-wait

echo "Done. The activity shows up in the AzureActivity table after a few minutes."
echo "Rules run every 5 minutes, so wait roughly 10 to 20 minutes before looking at Incidents."
