# aquasec/dcos-universe

Aqua packages for DC/OS (experimental)

This is an example configuration of an Aqua package repo for DC/OS, but this should not be used directly.  Instead, clone this and customize it for your environment.  Test thoroughly in non-production environment for your own use.

Contents:
* [Quick Deployment Walk-through](#quick-deployment-walk-through)
* [Deployment Considerations](#deployment-considerations) 

----------


# Quick Deployment Walk-through

This will walk through a complete deployment of Aqua console, gateway, and agents.

## Step one: Duplicate this GitHub repository

Clone this GitHub repository for your own change control management.  Replace our github repo location with your own.  Alternatively, you can upload your own zip file to some alternate location.   


## Step two: Add Aqua repository to DC/OS

Add repository to DC/OS user interface by logging into DC/OS interface and browsing to System -> Repositories tab.  Click the 'Add Repository button'.

![Add repository](http://i.imgur.com/RgjA9oh.png)

Include these details:
* Name:  Aquasec
* URL:   https://github.com/aquasecurity/dcos-universe/archive/master.zip
* Priority:  1 

Click 'Add' to store it.

Browse to 'Universe' section from left hand menu.  You should now have new packages:

![Package List](http://i.imgur.com/lJYtQXQ.png)


## Step three: Deploy database

Create a Postgres instance named 'aqua-web' by searching for 'Postgres' in the Universe.  

![Postgres](http://i.imgur.com/PZsG8cK.png)
  
You should change the service name to 'aqua-web':

![aqua-db](http://i.imgur.com/iuErsNe.png)

You can set up persistent storage on the 'storage' section in left hand menu.

Click 'Review and Install' and then 'Install' to deploy the database.

You can confirm that the service is running on the Services tab.



## Step four:  Deploy Aqua console

When aqua-db is running, click back to Universe section and click 'Install' on 'aqua-web' and then 'Advanced Install'.

At a minimum, you will need to enter a license key.

![aqua-web license](http://i.imgur.com/Pc2Nk4S.png)

You will also need to decide how you will get the images into the environment.  The Aqua images are hosted in private Docker Hub repositories, but you are free to push them to an internal registry if you like (this is how most customers deploy).

DC/OS and Marathon has some interesting behavior around authentication to private registries.  You can see this documented [here](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html).

Essentially, there are three options:
- Push images to a registry that does not require authentication and then specify the image name in configuration settings.
- Pre-pull the images on each server.  Images will run from cache this way so there is no need to pull them again.  Credentials can be removed after pull.
- Create and distribute a docker config tarball per the [Marathon documentation](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html) with a credential to Docker Hub that will allow access to the images.  

The default option assumes use of pre-pulled images, but you can change the image name to include your registry or enable the docker config file and specify it's location on the 'docker' tab:

![Docker configuration](http://i.imgur.com/8OLe0SI.png)

This screen will be the same for other images as well.

Other settings like the default passwords and custom database hostnames can be set on the other tabs.

When configuration is set, click 'Review and Install' and then 'Install' to deploy aqua-web.

When you mouse over 'aqua-web' in the Services list, an external link icon will appear that will send you to the login page.  Login here will be username and password.  Validate that the aqua-web is running before continuing.  


## Step five:  Deploy aqua-gateway

Click back through to Universe -> aqua-gateway -> Install.  

If you are using the default options then you can just click 'Install' here.

Otherwise, if you have changed any settings such as the database service name, database passwords, or image name or deployment method, you can click 'Advanced Installation' to edit those settings.  Then click 'Review and Install' and then 'Install' to deploy the gateways.


Go back to the Services tab.  You should have running services now for everything except the agents:

![Services](http://i.imgur.com/7qnSRNN.png)


## Step Six:  Install the agents

Click back through to Universe -> aqua-agent -> Install, then 'Advanced Installation'.  

Under the 'Instances' tab, set this to the number of nodes in the cluster to ensure agent is deployed everywhere.  If this number (default: 3) is higher than the number of nodes, then there will always be tasks pending in the Services list for aqua-agent, but this will ensure the agent is automatically installed if you add a new node to the cluster.

You can also customize the same docker deployment options and other aqua config here.  When set, click 'Review and Install' and then 'Install' to deploy the agents.



## Step Seven:  Verify installation

Click back through to Services -> aqua-web, and then click "Open Service" to get the login page for the aqua-web.  

Login, and click the 'Hosts' section on the left hand side of the page.  You should see the agents connected.

![Hosts list](http://i.imgur.com/28S3aG9.png)




# Deployment Considerations

A few considerations should be taken into account.

### Changes from default service names

If you change the service names from 'aqua-web', 'aqua-db', or 'aqua-gateway', you will need to do 'advanced install' options for all of the packages to change the addresses for the services that will be used, as it will use the DC/OS DNS service name instead of specific IPs for services.  

### Database persistence
Be sure to set persistent storage for the database component.  External persistent storage is preferred, but this requires a plugin for Mesosphere.  


### Default passwords

The advanced install can also allow you to set non-default passwords (recommended, as defaults are just for demo and are insecure).


