# Dartivity
An Iot client package for Dart.

Dartivity is a server side IOT client for Dart that wraps various existing IOT clients and uses
Googles pub/sub service as a messaging backbone to allow IOT device discovery, control and reporting.

The intention is that the package provide a common interface to as many IOT clients as possible, allowing
reporting and control of these clients through a web site that simply listens to and generates pub/sub messages
ie it has nor needs any knowledge of how many Dartivity clients exist, where they are or what devices they control.
This information is garnered from the Dartivity clients using a simple ARP like whohas/ihave protocol.

Currently the package supports the [Iotivity](https://www.iotivity.org/) IOT client, however other IOT clients
will be supported, e.g MQTT support will be added in a later release. Also, currently only device discovery is
supported, device control(PUT/GET) will be added in a later release.

The package depends on an async native extension that binds to the C/C++ API's of these clients where needed, this
extension is developed separatley and can be found [here](https://github.com/shamblett/dartivity_extension).

## Design

The client is designed to run all the time, i.e. it is an active client with its own housekeeping heartbeat, the
only interface to the outside world from the platform the client runs on is through the Google pub/sub service.
This gives a system design whereby a(or many) web site(s) can listen to the pub/sub messages to provide control and
monitoring facilities to operators. Clients can run on any supported platforms, multi-client per platform is also
supported.

The messaging protocol is as simple as possible, using an ARP like whohas/ihave protocol, a simple example would be
as follows :-

1. A Dartivity web site is running on a webserver and is listening to Dartivity client messages, in initial releases
the clients are not active in that they will only respond to requests, not generate information asynchronously, however
this facility will be added in later releases.

2. An operator wishes to see all thermostat IOT devices and issues a 'whoHas' message, all the clients recieve this message
and perform local device discovery, any clients that find the requested devices reply with a 'Ihave' message containing
the device details

3. The web site then populates a web page/database backend with this information.

4. Once devices have been discovered control operations can be performed, such as set temperature, switch on/off etc.
(Not yet, see above). Also platform information is harvesetd, what the client id is(unique to the client), what platform
it is running on etc.

This gives a highly decoupled structure, the web site is not dependant on any specific clients, the clients themselves do
not need a built in webserver, the clients are standalone, they neither know of nor expect any other clients to be present,
nor indeed do they require any web sites to be present.

## Testing

The test directory provies unit tests and standalone test for messging only, client IOT device only and both modes.
To run the IOT device tests suitable IOT servers need to be present such as the Iotovity projects 'simpleserver''
somewhere on your test network. Also, you need a working pub/sub 'pull' account.
Please inspect the various files in the test directory for API usage and client configuration.

## Roadmap

Next to do is a simple web site to show the IOT devices and allow on demand device discovery, its then a simple!!
matter of expanding the client facilities to add other IOT interfaces(MQTT et al), control and finally device observability
and presence monitoring. Also documentation is needed on client usage and configuration.

