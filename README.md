
<h1 align="center">Aqua packages for DC/OS</h1>
<div align="center">
    <img src="https://media.licdn.com/dms/image/C4E0BAQE3VDX3-CraIw/company-logo_200_200/0?e=2159024400&v=beta&t=JlFS2weo0ZUVfyL9YFFUWEhEutltl6W9DG3Ef6UAeEg" />
    <img height="185px" width="250px" src="https://mesosphere.com/wp-content/uploads/2016/04/logo-horizontal-styled.png" />
</div>

This is an example configuration of an Aqua package repo for DC/OS, but this should not be used directly. Instead, clone this and customize it for your environment. Test thoroughly in non-production environment for your own use.

## Contents
- [Quick Deployment Walk-through](#quick-deployment-walk-through)
  - [Step one: Duplicate this GitHub repository](#step-one-duplicate-this-github-repository)
  - [Step two: Add Aqua repository to DC/OS](#step-two-add-aqua-repository-to-dcos)
  - [Step three: Deploy database](#step-three-deploy-database)
  - [Step four: Deploy Aqua console](#step-four-deploy-aqua-console)
  - [Step five: Deploy aqua-gateway](#step-five-deploy-aqua-gateway)
  - [Step Six: Install the agents](#step-six-install-the-agents)
  - [Step Seven: Verify installation](#step-seven-verify-installation)
- [Daemon mode scanners (Scaling image scanning)](#daemon-mode-scanners-scaling-image-scanning)
- [Deployment Considerations](#deployment-considerations)
    - [Changes from default service names](#changes-from-default-service-names)
    - [Database persistence](#database-persistence)
    - [Default passwords](#default-passwords)

----------

# Quick Deployment Walk-through

This will walk through a complete deployment of Aqua console, gateway, and agents.

## Step one: Duplicate this GitHub repository

Clone this GitHub repository for your own change control management. Replace our github repo location with your own. Alternatively, you can upload your own zip file to some alternate location. 


## Step two: Add Aqua repository to DC/OS

Add repository to DC/OS user interface by logging into DC/OS interface and browsing to System -> Repositories tab. Click the 'Add Repository button'.

![Add repository](./images/aqua4.0-dcos-master.png)

Include these details:
* Name: AquaSecurity
* URL: Zip file URL from repository in step one. Example, for this repo it would be `https://github.com/aquasecurity/dcos-universe/archive/master.zip`
* Priority: 1 

Click 'Add' to store it.

Browse to 'Universe' section from left hand menu. You should now have new packages:

![Universe packages](./images/aqua4.0-dcos-tile.png)

## Step three: Deploy database

Create a Postgres instance named 'aqua-db' by searching for 'Postgres' in the Universe. 

![Postgres](./images/aqua4.0-dcos-postgre.png)
 
Change the service name to 'aqua-db':

![aqua-db](./images/aqua4.0-dcos-dbname.png)

You should set up persistent storage on the 'storage' section in left hand menu.

Click 'Review and Install' and then 'Install' to deploy the database.

You can confirm that the service is running on the Services tab.



## Step four: Deploy Aqua console

When aqua-db is running, click back to Universe section and click 'Install' on 'aqua-web' and then 'Advanced Install'.

At a minimum, you will need to enter a license key.

![aqua-web license](./images/aqua4.0-dcos-license.png)

You will also need to decide how you will get the images into the environment. The Aqua images are hosted in private Docker Hub repositories, however you are free to push them to an internal registry if you like (this is a common enterprise scenerio).

DC/OS and Marathon has some interesting behavior around authentication to private registries. You can see this documented [here](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html).

Essentially, there are three options:
- Push images to a registry that does not require authentication and then specify the image name in configuration settings.
- Pre-pull the images on each server. Images will run from cache this way so there is no need to pull them again. Credentials can be removed after pull.
- Create and distribute a docker config tarball per the [Marathon documentation](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html) with a credential to Docker Hub that will allow access to the images.
- Note: An example helper script named deployDockerCreds.sh is located in the ./scripts directory. Edit this script to match your environment.

The default option assumes use of pre-pulled images, but you can change the image name to include your registry or enable the docker config file and specify it's location on the 'docker' tab:

![aqua-web docker configuration](./images/aqua4.0-dcos-dockerpull.png)

This screen will be the same for other images as well.

Other settings like the default passwords and custom database hostnames can be set on the other tabs.

When configuration is set, click 'Review and Install' and then 'Install' to deploy aqua-web.

When you mouse over 'aqua-web' in the Services list, an external link icon will appear that will send you to the login page. Login here will be username and password. Validate that the aqua-web is running before continuing. 

## Step five: Deploy aqua-gateway

Click back through to Universe -> aqua-gateway -> Install. 

If you are using the default options then you can just click 'Install' here.

Otherwise, if you have changed any settings such as the database service name, database passwords, or image name or deployment method, you can click 'Advanced Installation' to edit those settings. Then click 'Review and Install' and then 'Install' to deploy the gateways.

Go back to the Services tab. You should have running services now for everything except the agents:

![Services](./images/aqua4.0-dcos-services.png)

## Step Six: Install the agents

Click back through to Universe -> aqua-agent -> Install, then 'Advanced Installation'. 

Under the 'Instances' tab, set this to the number of nodes in the cluster to ensure agent is deployed everywhere. If this number (default: 3) is higher than the number of nodes, then there will always be tasks pending in the Services list for aqua-agent, but this will ensure the agent is automatically installed if you add a new node to the cluster.

You can also customize the same docker deployment options and other aqua config here. When set, click 'Review and Install' and then 'Install' to deploy the agents.

## Step Seven: Verify installation

Click back through to Services -> aqua-web, and then click "Open Service" to get the login page for the aqua-web. 

Login, and click the 'Hosts' section on the left hand side of the page. You should see the agents connected.

![Hosts list](./images/aqua4.0-dcos-host.png)

# Daemon mode scanners (Scaling image scanning)

There is an additional package for the daemon-mode scanner-cli that can run standalone from aqua-web to provide greater throughput in image scanning.

Before you deploy, you should set up a dedicated scanning user in the Aqua user interface. To do this, browse to 

System -> Users. Click the Create New User button at the top of the page.

On the resulting screen, enter a username, password (twice), and select the 'Scanner' role from the drop-down menu. Then click 'Save changes' to save the user.

![Set up scanner user](./images/aqua4.0-dcos-scanneruser.png)

The defaults used by the aqua-scanner service are username 'scanner' with password 'scanner123'. 

To deploy, you can browse to Universe -> aqua-scanner -> Install. You can click 'Advanced Installation' to customize the username, password, or docker deployment settings (such as the image name).

The default number of scanner-cli instances is 3. This can be changed on the first 'service' screen in Advanced Installation:

![aqua-scanner advanced install](./images/aqua4.0-dcos-scannersetup.png)

Click Review and Install, and then Install to deploy.

You can verify that the scanners are deployed by going back to the Aqua console and browsing to Images -> Scan Queue (at top right, with arrow, may say "Scan Queue is empty" if there are no scans in progress).

The scanners will be listed on the right-hand side. By default there will be 1 scanner included in aqua web. If you added three in the aqua-scanner service then this will show 4 scanners total.

![Scanner list](./images/aqua4.0-dcos-scanners.png)

In DC/OS you can scale this up and down as needed on the Service page.

To do so, click Service -> aqua-scanner -> Scale button. You can set this to a higher or lower value to increase or decrease number of scanners.

![Scale scanners](./images/aqua4.0-dcos-scale.png)

It can take several minutes for a scanner to disappear from the scan queue after it is removed, but new scanners will show up immediately.

# Deployment Considerations

A few considerations should be taken into account.

### Changes from default service names

If you change the service names from 'aqua-web', 'aqua-db', or 'aqua-gateway', you will need to do 'advanced install' options for all of the packages to change the addresses for the services that will be used, as it will use the DC/OS DNS service name instead of specific IPs for services. 

### Database persistence
Be sure to set persistent storage for the database component. External persistent storage is preferred, but this requires a plugin for Mesosphere. 

### Default passwords

The advanced install can also allow you to set non-default passwords (recommended, as defaults are just for demo and are insecure).