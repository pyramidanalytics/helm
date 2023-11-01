# HELM Configuration

The following Pyramid services configuration should be added to values.yaml to enable a HELM install.

For more information, see [Install Pyramid using HELM](readme.md).

## Fields and values

### Docker Settings:
- **repo** : The Docker registry to pull the images from.
- **imagePullPolicy** : The policy to use when pulling images from the Docker registry. By default, this is "ifNotPresent", indicating that images should only be pulled if they are not already present locally.

### Attendance:
- **unattended** : Where applicable, the details for the unattended install.
  - **enabled** : Indicates whether the installation should run in the unattended mode or not:
    - If "false", the installation will be "attended". In this case, there is no "installationData" block. Instead, the Installation UI opens for you to enter your installation settings.
    - If "true", the installation will be "unattended". In this case, you also need to add the sibling "installationData" block for your installation settings (the database and storage settings to enable the unattended installation).

### Local storage
- **storage**: Root for local storage details. These details are used when you create the mount using HELM.
    - **type**: Type of local storage. Can be one of "GoogleStore", "NFS", or "other". The value "other" indicates that local storage is not used, and FTP, S3, or Azure Blob is used instead. In this case, the storage should be configured in the web UI or in the unattended installation configuration.
      - **size**: Minimum size of local storage. Not required for type "other".
      - **nfs**: NFS server settings, only required if the type is NFS. The path and ip attributes describe where the storage is available.

### Service settings
In addition to the preceding details, it is also necessary to provision initialization settings for each of the services. Each block of settings is as follows:

#### Web server
The Web server handles HTTP networking and authentication.

- **ws**:
  - **port**: The default port for your web server. Match this with your ingress.
  - **replicas**: The number of replicas (pods) required for this service
  - **requests**: The minimum memory, cpu, and ephemeral_storage guaranteed for the service. Tip: We recommend that you only increase and do not reduce the default values.
  - **limits**: The memory limits for the service (memory, cpu, and ephemeral_storage). You can increase these values to better match your nodes, but do not typically need to do so. Note: The main limitation for web servers specifically is IO.
  - **kedaAutoscaling**: The "auto-scale" settings where Keda is enabled.
    - **enabled**: Whether auto-scaling is enabled for this service.
    - **minReplicas**: The minimum number of replicas for this service. Note: Auto-scaling will never reduce the number of pods below this number.
    - **maxReplicas**: The maximum number of replicas for this service. Note: Auto-scaling will never increase the number of pods above this number.
    - **threshold**: The number of active requests that the server can handle before the auto-scaling threshold is met. If maxReplicas has not been met, meeting this threshold causes a new replica to be added.

#### Request routing
The Request routing service decides where to send requests.

- **rtr**:
  - **replicas**: As above.
  - **requests**: As above.
  - **limits**: As above. 

#### Runtime engine
The Runtime engine handles all active requests, queries, and the CMS.

- **rte**:
  - **replicas**: As above.
  - **requests**: As above.
  - **limits**: As above.
  - **satellites**: The number of satellites used to preview Data Flow results.
  - **autoscaling**: The standard "auto scale" settings. The settings indicate the min and max number of replicas, the target CPU utilization, and the scale down duration when auto scaling.
    - **enabled**: Whether auto-scaling is enabled for this service.
    - **minReplicas**: The minimum number of replicas for this service. Note: Auto-scaling will never reduce the number of pods below this number.
    - **maxReplicas**: The maximum number of replicas for this service. Note: Auto-scaling will never increase the number of pods above this number.
    - **targetCpuUtilization**: The percentage of CPU usage across all pods associated with this service before the auto-scaling threshold is met. If maxReplicas has not been met, meeting this threshold causes a new replica to be added.

#### Natural language processing engine (NLP)
The Natural language processing engine is responsible for the chat bot function in Discover.

- **nlp**:
  - **replicas**: As above.
  - **requests**: As above.
  - **limits**: As above. Note: Based on system usage, NLP can be CPU heavy.
  - **autoscaling**: As above. 

#### Task engine
The Task engine handles Data Flow (ETL) and prints.

- **te**:
  - **replicas**: As above.
  - **requests**: As above.
  - **limits**: As above. Note: Task Engine can be CPU and memory heavy.
  - **satellites**: As above.
  - **kedaAutoscaling**:
    - **enabled**: As above.
    - **minReplicas**: As above.
    - **maxReplicas**: As above.
  - **terminationGracePeriodSeconds**: A grace period for a termination to complete after a termination signal is sent to the pod. If the termination is not completed by the end of the grace period, it is forced. If you do not supply a grace period, the default is 30 seconds.
  - **printers**: The actual number of print "engines" available at all times, per task engine service.

#### Artificial intelligence
The Artificial intelligence server hosts all Python and R script handling.

- **ai**:
  - **replicas**: As above.
  - **requests**: As above.
  - **limits**: As above. Note: Based on system usage, AI can be CPU heavy.
  - **satellites**: As above.
  - **autoscaling**: As above.
    
#### GeoSpatial server
The GeoSpatial server handles mapping data for queries. Can be disabled if not in use.

- **gis**:
  - **enabled**: Set to "true" if the GeoSpatial server is in use. Otherwise, set to "false".
  - **requests**: As above.
  - **limits**: As above.

## Example

[Example values.yaml - HELM Configuration](Values_Helm.yaml)

