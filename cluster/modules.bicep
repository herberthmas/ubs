
param location string = resourceGroup().location
//param location string = 'northeurope'

param vmSize string = 'standard_d16ads_v5'
param subscriptionID string 

@description('Specify the environment')
@allowed([
  'Prod'
  'Dev'
])
param environment string = 'Dev'
param clusterName string = 'aks-HmgDemo${environment}'
param nodeCount int = (environment == 'Dev') ? 1 :3

module aksModule 'aks-cluster.bicep' = {
  name: 'aksDeploy'
  params: {
    location: rsgModule.outputs.location
    clusterName:clusterName
    vmSize:vmSize
    nodeCount:nodeCount
  }

}
