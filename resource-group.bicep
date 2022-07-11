targetScope = 'subscription'
param location string = 'northeurope'
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'rg-HmgDemo'
  location: location
}
