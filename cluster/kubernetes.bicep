param location string 

param clusterName string 
param nodeCount int 
param vmSize string 

resource aks 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: clusterName
  location: location
  tags: {
    runDuring:'businessHours'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: nodeCount
        vmSize: vmSize
        mode: 'System'
      }
    ]

  }
}

resource flux 'Microsoft.KubernetesConfiguration/extensions@2021-09-01' = {
  name: 'flux'
  scope: aks
  properties: {
    extensionType: 'microsoft.flux'
    scope: {
      cluster: {
        releaseNamespace: 'flux-system'
      }
    }
    configurationSettings: {
      'multiTenancy.enforce': 'false'
    }
    autoUpgradeMinorVersion: true
  
  }
}

resource fluxConfig 'Microsoft.KubernetesConfiguration/fluxConfigurations@2021-11-01-preview' = {
  name: 'flux-config'
  scope: aks
  dependsOn: [
    flux
  ]
  properties: {
    scope: 'cluster'
    namespace: 'gitops-demo'
    sourceKind: 'GitRepository'
    suspend: false
    gitRepository: {
      url: 'https://github.com/herberthmas/ubs'
      timeoutInSeconds: 600
      syncIntervalInSeconds: 60
      repositoryRef: {
        branch: 'main'
      }

    }
    kustomizations: {
      environments: {
        path: 'environments/staging'
        dependsOn: []
        timeoutInSeconds: 60
        syncIntervalInSeconds: 60
        validation: 'none'
        prune: true
      }
      patches:{

      }
    }
  }
}

