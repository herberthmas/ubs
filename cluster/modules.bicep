param location string = resourceGroup().location
param vmSize string = 'standard_d16ads_v5'

@description('Specify the environment')
@allowed([
  'Prod'
  'Dev'
])
param environment string 
param sourceKind string = '${sourceKind}'
param clusterName string = 'aks-HmgDemo${environment}'
param nodeCount int = (environment == 'Dev') ? 1 :3

module aksModule 'aks-cluster.bicep' = {
  name: 'aksDeploy'
  params: {
    location: location
    clusterName:clusterName
    vmSize:vmSize
    nodeCount:nodeCount
    sourceKind:= sourceKind
  }

}
