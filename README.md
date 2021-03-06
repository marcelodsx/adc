# AppDynamics Commandline Tool (ADC)

The AppDynamics Commandline Tool (ADC) is a shell script wrapper around [API](https://docs.appdynamics.com/display/PRO43/AppDynamics+APIs#AppDynamicsAPIs-apiindex) calls towards an AppDynamics controller.

## Installation

To use the latest release of ADC just download the raw version of [adc.sh](https://github.com/Appdynamics/adc/blob/master/adc.sh)

Afterwards run `adc.sh config` to provide your controller host and credentials. This will create a configuration file at `~/.appdynamics/adc/config.sh`, e.g.:

```bash
CONFIG_CONTROLLER_HOST=https://appdynamics.example.com:8090
CONFIG_CONTROLLER_CREDENTIALS=me@customer1:secure2
CONFIG_CONTROLLER_COOKIE_LOCATION=/home/ubuntu/.appdynamics/adc/cookie.txt
```

If you want to change your configuration, you can either edit this file or you can re-run the self setup:

```
adc.sh config -f
```

## Usage

`adc.sh` integrates different commands to interact with your AppDynamics controller. Call `adc.sh help` to get a full list:

```
Usage: ./adc.sh <namespace> <command>

To execute a action, provide a namespace and a command, e.g. "dbmon list" to list all database collectors.
Finally the following commands in the global namespace can be called directly:
	help		Display the global usage information
	config	Initialize the adc configuration file

application
	list		List all applications available on the controller

controller
	call		Send a custom HTTP call to a controller
	login		Login to your controller
	ping		Check the availability of an appdynamics controller
	status		Get server status from controller

dashboard
	delete		Delete a specific dashboard
	export		Export a specific dashboard
	list		List all dashboards available on the controller

dbmon
	create		Create a new database collector

event
	create		Create a custom event for a given application

metrics
	get		List all metrics available for one application
	list		List all metrics available for one application

timerange
	create		Create a custom time range
	delete		Delete a specific time range by id
	list		List all custom timeranges available on the controller
```

A simple work flow example is listing, exporting and deleting a dashboard:

```
adc dashboard list
adc dashboard export 13
adc dashboard delete 13
```

Also, you can use `adc.sh` to easily create custom events, like code deployments:

```
./adc.sh event create -s INFO -c "This release fixes some minor issues with the mini cart functionality" -e APPLICATION_DEPLOYMENT -a 145 "Version 3.5.1 released"
```

If a certain API call is not yet wrapped into a command, you can use `controller call` as general interface:

```
adc.sh controller call /controller/rest/applications?output=JSON
```

## Plugins

If you want to use custom plugins with `adc.sh` you can place shell scripts into a plugin folder (default: `~/.appdynamics/adc/plugins`) and they will be sourced automatically. A command plugin requires the following structure:

```
#!/bin/bash
function namespace_command {
...
}
register namespace_command help text
```

Please note, that your plugins will not be validated, so you can change global behavior or break the script.

## Build

To make working on `adc.sh` easier this git repository includes a very simple build system: The file `main.sh` is merged with all scripts in the sub directories, that are `source`d. So, if you want to build a custom version of `adc.sh` clone this directory, edit `main.sh` or any of the other files in this repository and run `build.sh` to update the script. Any changes you made directly to `adc.sh` will be overwritten.
