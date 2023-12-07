# Install Pyramid using HELM

Use Helm charts to enable the installation of the Pyramid Platform on a Kubernetes cluster.

## Basic HELM Installation

### Step 1 - Prerequisites

Before you install Pyramid itself, you should install the auto-scaling tools:

1. First, run the following command to install Keda. Keda supports automatic scaling for Task Services and the Web Server:
    
    `helm repo add kedacore https://kedacore.github.io/charts`
    
    `helm repo update kedacore`

    `helm install keda kedacore/keda --namespace keda --create-namespace`

2. Run the following commands to install the Metrics server. Metrics server supports automatic scaling.

    Note: This step should NOT be performed when installing on GCP, since the Kubernetes engine on GCP comes pre-installed with the Metrics Server.

    `helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/`

    `helm repo update metrics-server`

    `helm install my-metrics-server metrics-server/metrics-server --version 3.9.0`

### Step 2 - Customize your installation configuration file (values.yaml)
You may need to fine-tune Pyramid by tweaking different settings in the HELM configuration (values.yaml). These changes affect:
- The number of pods for each service.
- The auto-scaling settings for each service, including scaling metrics.
- The minimum and maximum memory, ephemeral storage, and CPU settings for each service.
- The persistent storage sizes and target.
- The settings that allow an unattended installation, if required.

To configure HELM:

1. Download the file values.yaml from Github.
    
    This file contains some default configuration options for your installation.

2. Check that the values.yaml configuration is accurate for your Pyramid installation and update it as required.

    For reference information about the configuration options that you might want to add, see:

   - [Configuration for a HELM installation](https://help.pyramidanalytics.com/Content/Root/Guides/installation/Kubernetes/helm/Ref_Installation_HELM.htm).
   - [Configuration for an unattended installation](https://help.pyramidanalytics.com/Content/Root/Guides/installation/Kubernetes/helm/Ref_Installation_Unattended.htm).
   

3. Save your changes.

### Step 3 - Install Pyramid
Finally, install Pyramid by adding the Pyramid repo and then running the appropriate `install` command:

1. Add the Pyramid repo. Run the following commands:

    `helm repo add pyramid https://pyramidanalytics.github.io/helm/`

    `helm repo update pyramid`

2. Run the appropriate installation command:

    a. If you did not edit values.yaml and you want to install to the default namespace, run:

    `helm install pyramid pyramid/pyramidanalytics`

   b. If you did not edit values.yaml and you want to install in a different namespace, run:

    `helm install pyramid pyramid/pyramidanalytics --namespace=pyramid --create-namespace`

    c. If you updated your configuration values in values.yaml, run:

    `helm install -f .\values.yaml pyramid pyramid/pyramidanalytics`

