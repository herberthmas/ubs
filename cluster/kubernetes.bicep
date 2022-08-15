param location string 
param clusterName string 
param nodeCount int 
param vmSize string
param sourceKind string
var url = 'https://asademodev.blob.${environment().suffixes.storage}/dev'
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
resource fluxConfigGit 'Microsoft.KubernetesConfiguration/fluxConfigurations@2021-11-01-preview' = {
  name: 'flux-bootstrap'
  scope: aks
  dependsOn: [
    flux
  ]
  properties: {
    scope: 'cluster'
    namespace: 'flux-system'
    sourceKind: sourceKind
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
      staging: {
        path: './environments/staging'
        dependsOn: []
        timeoutInSeconds: 60
        syncIntervalInSeconds: 60
        validation: 'none'
        prune: true
      }/*
      production: {
        path: './environments/production'
        dependsOn: []
        timeoutInSeconds: 600
        syncIntervalInSeconds: 60
        retryIntervalInSeconds: 600
        prune: true
      }*/
    }
  }
} 
/*
resource fluxConfigGit 'Microsoft.KubernetesConfiguration/fluxConfigurations@2021-11-01-preview' = if (sourceKind == 'GitRepository'){
  name: 'flux-config-git'
  scope: aks
  dependsOn: [
    flux
  ]
  properties: {
    scope: 'cluster'
    namespace: 'flux-config'
    sourceKind: sourceKind
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
      workload: {
        path: './workloads'
        dependsOn: []
        timeoutInSeconds: 600
        syncIntervalInSeconds: 60
        validation: 'none'
        prune: true
      }
      namespace: {
        path: './namespaces'
        dependsOn: []
        timeoutInSeconds: 600
        syncIntervalInSeconds: 60
        retryIntervalInSeconds: 600
        prune: true
      }
      patches:{

      }
    }
  }
} 

resource fluxConfigStorageAccount 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01' = if (sourceKind == 'Bucket'){
  name: 'flux-config-storage-account'
  scope: aks
  dependsOn: [
    flux
  ]
  properties: {
    bucket: {
      accessKey: 'DWmPQPD8FZWD5u2bABiHnXYhKY0j6ncg12lG6gphhsTSOeSMYMbcnsC6JT7854NcraQdH64LbUeY+AStDoGBSg=='
      bucketName: 'dev'
      insecure: false
      syncIntervalInSeconds: 60
      timeoutInSeconds: 600
      url: url
    }
    configurationProtectedSettings: {}
    kustomizations: {}
    namespace: 'flux-config'
    scope: 'cluster'
    sourceKind: sourceKind
  }
}
*/
output url string = url
