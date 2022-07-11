

param location string = resourceGroup().location
param nodeCount int = 1
param vmSize string = 'standard_d16ads_v5'

@description('Specify the environment')
@allowed([
  'Prod'
  'Dev'
])
param environment string
param clusterName string = 'aks-HmgDemo${environment}'

module aksModule 'aks-cluster.bicep' = {
  name: 'aksDeploy'
  params: {
    location: location
    clusterName:clusterName
    vmSize:vmSize
    nodeCount:nodeCount
  }
}
