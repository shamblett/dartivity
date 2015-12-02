/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:dartivity_messaging/dartivity_messaging.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:json_object/json_object.dart' as jsonobject;

void main() {
  group("Construction and configuration", () {
    test("No mode supplied", () {
      Dartivity dartivity = new Dartivity(null, null);
      expect(dartivity.supports, Mode.both);
    });

    test("Both mode", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(dartivity.supports, Mode.both);
    });

    test("Messaging only mode", () {
      Dartivity dartivity = new Dartivity(Mode.messagingOnly, null);
      expect(dartivity.supports, Mode.messagingOnly);
    });

    test("Iotivity client", () {
      Dartivity dartivity = new Dartivity(Mode.both, [Client.iotivity]);
      expect(dartivity.supports, Mode.iotOnly);
    });

    test("Hostname", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(dartivity.hostname, Platform.localHostname);
    });

    test("Id generation check", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      uuid.Uuid myUuid = new uuid.Uuid();
      var uuid1 =
      myUuid.v5(uuid.Uuid.NAMESPACE_URL, DartivityCfg.CLIENT_ID_URL);
      if (DartivityCfg.tailedUuid) {
        String newId = dartivity.id.split('%').first;
        expect(newId, "${Platform.localHostname}" + '-' + "${uuid1}");
      } else {
        expect(dartivity.id, "${Platform.localHostname}" + '-' + "${uuid1}");
      }
    });
  });

  group("Initialisation", () {
    test("Initialise state", () {
      Dartivity dartivity = new Dartivity(null, null);
      expect(dartivity.initialised, false);
    });

    test("No send until initialised", () {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(dartivity.send(null), null);
    });

    test("No find resource until initialised", () async {
      Dartivity dartivity = new Dartivity(Mode.both, null);
      expect(await dartivity.findResource(null, null), null);
    });
  });

  group("Message Tests", () {
    test("Who Has  - invalid source", () {
      try {
        DartivityMessage message = new DartivityMessage.whoHas(null, "");
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_WHOHAS_MESSAGE);
      }
    });

    test("Who Has  - invalid resource name", () {
      try {
        DartivityMessage message = new DartivityMessage.whoHas("", null);
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_WHOHAS_MESSAGE);
      }
    });

    test("Who Has  - invalid host", () {
      try {
        DartivityMessage message =
        new DartivityMessage.whoHas(null, null, null);
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_WHOHAS_MESSAGE);
      }
    });

    test("Who Has  - toJSON", () {
      DartivityMessage message = new DartivityMessage.whoHas(
          DartivityMessage.ADDRESS_WEB_SERVER, "oic/res", "localhost");
      expect(message.toJSON(),
          '{"type":0,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost","provider":"Unknown"}');
    });

    test("Who Has  - fromJSON", () {
      DartivityMessage message = new DartivityMessage.fromJSON(
          '{"type":0,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost", "provider":"Unknown"}');
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
      expect(message.provider, DartivityMessage.PROVIDER_UNKNOWN);
    });

    test("Who Has  - fromJSONObject", () {
      jsonobject.JsonObject job = new jsonobject.JsonObject.fromJsonString(
          '{"type":0,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost", "provider":"Unknown"}');
      DartivityMessage message = new DartivityMessage.fromJSONObject(job);
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
      expect(message.provider, DartivityMessage.PROVIDER_UNKNOWN);
    });

    test("Who Has - toString", () {
      DartivityMessage message = new DartivityMessage.whoHas(
          DartivityMessage.ADDRESS_WEB_SERVER, "oic/res", "localhost");
      expect(message.toString(),
          "Type : Type.whoHas, Provider : Unknown, Host : localhost, Source : web-server, Destination : global, Resource Name : oic/res, Resource Details : {}");
    });

    test("I Have  - invalid source", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave(null, "", "", {}, "", "");
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_IHAVE_MESSAGE);
      }
    });

    test("I Have  - invalid destination", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave("", null, "", {}, "", "");
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_IHAVE_MESSAGE);
      }
    });

    test("I Have  - invalid resource name", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave("", "", null, {}, "", "");
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_IHAVE_MESSAGE);
      }
    });

    test("I Have  - invalid resource details", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave("", "", "", null, "", "");
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_IHAVE_MESSAGE);
      }
    });

    test("I Have  - invalid host", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave("", "", "", {}, null, "");
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_IHAVE_MESSAGE);
      }
    });

    test("I Have  - invalid provider", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave("", "", "", {}, "", null);
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(
            e.toString(),
            DartivityException.HEADER +
                DartivityException.INVALID_IHAVE_MESSAGE);
      }
    });

    test("I Have  - toJSON", () {
      DartivityMessage message = new DartivityMessage.iHave(
          DartivityMessage.ADDRESS_WEB_SERVER,
          DartivityMessage.ADDRESS_GLOBAL,
          "oic/res",
          {},
          "localhost",
          DartivityMessage.PROVIDER_IOTIVITY);
      expect(message.toJSON(),
          '{"type":1,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost","provider":"Iotivity"}');
    });

    test("I Have  - fromJSON", () {
      DartivityMessage message = new DartivityMessage.fromJSON(
          '{"type":1,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost","provider":"Iotivity"}');
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
      expect(message.provider, DartivityMessage.PROVIDER_IOTIVITY);
    });

    test("I Have  - fromJSONObject", () {
      jsonobject.JsonObject job = new jsonobject.JsonObject.fromJsonString(
          '{"type":1,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost", "provider":"Iotivity"}');
      DartivityMessage message = new DartivityMessage.fromJSONObject(job);
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
      expect(message.provider, DartivityMessage.PROVIDER_IOTIVITY);
    });

    test("I Have  - toString", () {
      DartivityMessage message = new DartivityMessage.iHave(
          DartivityMessage.ADDRESS_WEB_SERVER,
          DartivityMessage.ADDRESS_GLOBAL,
          "oic/res",
          {},
          "localhost",
          DartivityMessage.PROVIDER_UNKNOWN);
      expect(message.toString(),
          "Type : Type.iHave, Provider : Unknown, Host : localhost, Source : web-server, Destination : global, Resource Name : oic/res, Resource Details : {}");
    });
  });

  group("Iotivity Resource Tests", () {
    test("Construction - null native pointer", () {
      try {
        DartivityIotivityResource resource =
        new DartivityIotivityResource(
            null,
            "",
            "",
            "",
            [],
            [],
            true);
      } catch (e) {
        expect(e.runtimeType.toString(), 'DartivityException');
        expect(e.toString(),
            DartivityException.HEADER + DartivityException.NULL_NATIVE_PTR);
      }
    });

    test("To String", () {
      DartivityIotivityResource resource =
      new DartivityIotivityResource(
          0,
          "theId",
          "",
          "",
          [],
          [],
          true);
      expect(resource.toString(), "theId");
    });

    test("Equality", () {
      DartivityIotivityResource resource1 =
      new DartivityIotivityResource(
          0,
          "theId",
          "",
          "",
          [],
          [],
          true);
      DartivityIotivityResource resource2 =
      new DartivityIotivityResource(
          0,
          "theId",
          "",
          "",
          [],
          [],
          true);
      expect(resource1 == resource2, true);
      DartivityIotivityResource resource3 =
      new DartivityIotivityResource(
          0,
          "theId3",
          "",
          "",
          [],
          [],
          true);
      expect(resource1 == resource3, false);
    });

    test("To Map", () {
      DartivityIotivityResource resource = new DartivityIotivityResource(
          0, "theId", "/a/light", "localhost", ['bulb'], ['tcp'], true);
      Map resMap = resource.toMap();
      expect(resMap[DartivityIotivityResource.MAP_IDENTIFIER], "theId");
      expect(resMap[DartivityIotivityResource.MAP_HOST], "localhost");
      expect(resMap[DartivityIotivityResource.MAP_URI], "/a/light");
      expect(resMap[DartivityIotivityResource.MAP_RESOURCE_TYPES], ['bulb']);
      expect(resMap[DartivityIotivityResource.MAP_INTERFACE_TYPES], ['tcp']);
      expect(resMap[DartivityIotivityResource.MAP_OBSERVABLE], true);
      expect(resMap[DartivityIotivityResource.MAP_PROVIDER],
          DartivityMessage.PROVIDER_IOTIVITY);
    });
  });

  group("Dartvity Resource Tests", () {
    test("To String", () {
      DartivityIotivityResource iotivityResource =
      new DartivityIotivityResource(
          0,
          "aaaa",
          "",
          "",
          [],
          [],
          true);
      DartivityResource dartivityRes =
      new DartivityResource.fromIotivity(iotivityResource, "bbbbb");
      expect(dartivityRes.toString(), "Id : bbbbb-aaaa, Provider : Iotivity");
    });
  });
}
