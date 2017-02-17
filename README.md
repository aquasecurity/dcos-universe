# aquasec/dcos-universe

Aqua packages for DC/OS (experimental)

If you change the service names from 'aqua-web', 'aqua-db', or 'aqua-gateway', you will need to do 'advanced install' options for all of the packages to change the addresses for the services that will be used, as it will use the DC/OS DNS service name instead of specific IPs for services.  Be sure to set persistent storage for the database component.

The advanced install can also allow you to set non-default passwords (recommended, as defaults are just for demo and are insecure), container mode for agents, set user namespace if supported by OS, number of agents to deploy (number should match the number of nodes in the cluster), resource allocation, location of docker configuration if private registry credentials are needed, and more..

Once you have a desired configuration in the UI, you can download a JSON file for command line deployment with your custom options to avoid filling in the forms again.


## Quick Deploy on DCOS


If you haven't set this up before as 'aqua-web', 'aqua-gateway', and 'aqua-db', and your cluster uses the default 'marathon.l4lb.thisdcos.directory' postfix for apps in the cluster, this is the fastest way to demo the product (though, it uses default passwords which should really be changed).

However, if you do not set data persistence in advanced install when setting up the postgres service, this will not survive a restart of Docker agents.

### Add Aqua package repository.


Click through to System -> Repositories -> Add Repository
  Name:  Aquasec
  URL:   https://github.com/aquasecurity/dcos-universe/archive/master.zip
  Priority:  1 (or higher number than any existing if you have more than one, to give it lowest priority)


### Deploy database
	Click Universe -> Postgres -> Advanced Install
		Change service name in 'service' section to 'aqua-db'
		Check 'enable' under 'Enable persistent storage' in 'storage' section.
		Click Review and Install
		Click Install

	Click Services
	Wait for aqua-db to be in Running state



### Deploy server
* Click Universe -> aqua-web -> Advanced Install
	* In 'configuration' section, add license key to 'license_key'.
		* Click Review and Install
		* Click Install
	* Click Services, and wait for aqua-web to be in Running state before continuing

### Deploy gateway

* Click Universe -> aqua-gateway Install Package
* Click Services and wait for aqua-gateway to be in Running state

* Login to aqua-web to confirm it is running and gateway shows up.
	* Click Services
	* Mouse over aqua-web, click external link icon that pops up to right of service name to open aqua console.
	* Login with 'administrator' and password 'password'.  (if you get two password forms to set initial password, reload the page before entering password)
		* Click System -> Aqua Gateways.  Confirm gateway exists in 'Online' state.

* Go back to DCOS UI


### Deploy Agents

* Click Universe -> aqua-agent -> Install Package
* Click back to Services.  The agents will install.


**Note**
If you do not use container mode installation (the default), there will be a brief point where each of the other services get stopped and started once more as Docker restarts for agent install.  If you do not have persistent storage set for the database, it will be wiped.  To avoid this you can set container mode on aqua-agent (default) and persistent storage for the database (as described above).

