# Helm Charts for Pyramid Analytics on Kubernetes
The Pyramid Decision Intelligence Platform is a frictionless, integrated, no-code, AI-driven platform that combines data prep, data science, and business analytics capabilities. Everyone can self-serve by directly accessing multiple data sources across their environment with a tailored experience. The analytics stack is simplified and less complex, with a lower total cost of ownership.

This Helm chart enables the installation of the Pyramid Platform on a Kubernetes cluster.
Alternatively, you can also perform the installing using the yaml generator at the [official pyramid site](https://customers.pyramidanalytics.com/kubernetes/).

## Basic Installation
First, run the following command to install Keda to support the automatic scaling of [Task Services](https://help.pyramidanalytics.com/Content/Root/AdminClient/Servers/Task%20Engine.htm) and [Web Server](https://help.pyramidanalytics.com/Content/Root/AdminClient/Servers/Web%20Servers.htm):

    helm repo add kedacore https://kedacore.github.io/charts
	helm install keda kedacore/keda --namespace keda --create-namespace

To support [Run Time Services](https://help.pyramidanalytics.com/Content/Root/AdminClient/Servers/Run%20Time%20Engine.htm) and artificial intelligence services automatic scaling, run the following command, which installs the Metrics server:

*Note: This step shouldn't be performed when installing on GCP, since the kubernetes engine on GCP comes pre-installed with the Metrics Server.


    helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
    helm install my-metrics-server metrics-server/metrics-server --version 3.9.0

Finally, install Pyramid by running:

    helm repo add pyramid https://pyramidanalytics.github.io/helm/
    helm install pyramid pyramid/pyramidanalytics
This will install in the default namespace. To install in a different namespace, use the following command:

    helm install pyramid pyramid/pyramidanalytics --namespace=pyramid --create-namespace
## Customization 
To fine-tune Pyramid, you can tweak different settings, such as:
 - The number of pod for each service 
 - Disable scaling for each service or set scaling metrics
 - Min and max memory and CPU
 - Ephemeral storage min and max for each service
 - Persistence storage sizes and target
 - Unattended installation

To change those values and more details refer to the [values yaml](https://pyramidanalytics.github.io/helm/values.yaml)
This file should be downloaded, and its values should be edited as you see fit, then run the following command to apply the changes:

    helm install f .\values.yaml pyramid pyramid/pyramidanalytics

For example, to disable the auto scaling of the Task Service, edit under `te -> kedaAutoscaling -> enabled` and set it to false:

    te:
      ...snip...
      kedaAutoscaling:
        enabled: false