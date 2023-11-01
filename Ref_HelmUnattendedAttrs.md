# Unattended Kubernetes Configuration

The following configuration should be added to values.yaml to enable an unattended install.

For more information, see [Install Pyramid using HELM](readme.md).

## Fields and values
### Docker Settings:
- **repo** : The Docker registry to pull the images from.
- **imagePullPolicy** : The policy to use when pulling images from the Docker registry. By default, this is "ifNotPresent", indicating that images should only be pulled if they are not already present locally.

### Attendance:
- **unattended** : Where applicable, the details for the unattended install.
  - **enabled** : Indicates whether the installation should run in the unattended mode or not:
    - If "false", the installation will be "attended". In this case, there is no "installationData" block. Instead, the Installation UI opens for you to enter your installation settings.
    - If "true", the installation will be "unattended". In this case, you also need to add the sibling "installationData" block for your installation settings (the database and storage settings that enable the unattended installation).
    
### Installation Data:

The installationData block contains the database and storage settings required to perform an unattended installation. As shown in the following example, the installationData block is contained by the unattended block and is only used where the unattended installation is enabled.

- **installationData**: Contains the fields and blocks that describe the database and storage settings, as described below.
  - **createDB** : If "on", the installer will create the database using the supplied credentials.
  - **repoType** :
    - If "existing", the database server should contain an existing (previously installed) Pyramid database.
    - If "native" or "rds", a new Pyramid database schema will be created in the provided database.
  - **serverType** : The database server type, either SqlServer or Postgresql.
  - **serverAddress** : The database server address, either IP or FQDN.
  - **port** : The database server port number.
  - **database** : The database name.
  - **dbUser** : The user name for connecting the database.
  - **dbPass** : The user's password.
  - **enforceDbSsl** : Specify "on" to enforce SSL over the database connection, or "off" otherwise.
  - **firstUser** :The user name of the first Pyramid admin user.
  - **firstUserPass** : The password of the first Pyramid admin user (this can be changed later from inside the app).
  - **license**: The text content of a Pyramid license file. Use this to seed the license key into the deployment directly. The license file can also be uploaded after installation.
  - **storageType** : The preferred persistent file storage method. One of: AWSS3, AzureBlob, PersistentVolume, FTP, SFTP, or NFS.

### Storage Fields:

Based on the previous **storageType** setting, the following additional settings are required:

#### FTP/SFTP/NFS
- **storageHostName** : FTP server address
- **storagePort** : FTP server port
- **storageUserName** : FTP server username
- **storagePassword** : FTP server password
- **storageFolder** : Directory

#### AWS-S3
- **regionId** : AWS Region Code. A full list can be found here.
- **awsAccessKeyId** : AWS Access Key ID. To use an AWS IAM role, set awsAccessKeyId: "iam" after configuring a role on AWS. In this case you do not need to set awsSecretAccessKey.
- **awsSecretAccessKey** : AWS Secret Access Key
- **awsBucket** : AWS S3 bucket name

#### Azure blobs
- **azureBlobAccountName** : Azure account name
- **azureBlobAccountKey** : Azure account key
- **azureContainer** : Azure container name

## Example

[Example values.yaml - Unattended Configuration](Values_Unattended.yaml)