targetScope = 'subscription'

param location string
param name string
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: name
  location: location
}
output location string = rg.location
