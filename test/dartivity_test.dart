/*
 * Package : dartivity
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 28/09/2015
 * Copyright :  S.Hamblett 2015
 */

library dartivity.test;

import 'dart:io';

import 'package:dartivity/dartivity.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:json_object/json_object.dart' as jsonobject;

void main() {
  group("Construction and configuration", () {
    test("No mode supplied", () {
      Dartivity dartivity = new Dartivity(null);
      expect(dartivity.supports, Mode.both);
    });

    test("Both mode", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      expect(dartivity.supports, Mode.both);
    });

    test("Messaging only mode", () {
      Dartivity dartivity = new Dartivity(Mode.messagingOnly);
      expect(dartivity.supports, Mode.messagingOnly);
    });

    test("IOT only mode", () {
      Dartivity dartivity = new Dartivity(Mode.iotOnly);
      expect(dartivity.supports, Mode.iotOnly);
    });

    test("Hostname", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      expect(dartivity.hostname, Platform.localHostname);
    });

    test("Id generation check", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      uuid.Uuid myUuid = new uuid.Uuid();
      var uuid1 =
      myUuid.v5(uuid.Uuid.NAMESPACE_URL, DartivityCfg.CLIENT_ID_URL);
      expect(dartivity.id, "${Platform.localHostname}" + '-' + "${uuid1}");
    });
  });

  group("Initialisation", () {
    test("Initialise state", () {
      Dartivity dartivity = new Dartivity(null);
      expect(dartivity.initialised, false);
    });

    test("No send until initialised", () {
      Dartivity dartivity = new Dartivity(Mode.both);
      expect(dartivity.send(null), null);
    });

    test("No find resource until initialised", () async {
      Dartivity dartivity = new Dartivity(Mode.both);
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
      '{"type":0,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost"}');
    });

    test("Who Has  - fromJSON", () {
      DartivityMessage message = new DartivityMessage.fromJSON(
          '{"type":0,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost"}');
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
    });

    test("Who Has  - fromJSONObject", () {
      jsonobject.JsonObject job = new jsonobject.JsonObject.fromJsonString(
          '{"type":0,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost"}');
      DartivityMessage message = new DartivityMessage.fromJSONObject(job);
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
    });

    test("Who Has - toString", () {
      DartivityMessage message = new DartivityMessage.whoHas(
          DartivityMessage.ADDRESS_WEB_SERVER, "oic/res", "localhost");
      expect(message.toString(),
      "Type : Type.whoHas, Host : localhost, Source : web-server, Destination : global, Resource Name : oic/res, Resource Details : {}");
    });

    test("I Have  - invalid source", () {
      try {
        DartivityMessage message =
        new DartivityMessage.iHave(null, "", "", {}, "");
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
        new DartivityMessage.iHave("", null, "", {}, "");
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
        new DartivityMessage.iHave("", "", null, {}, "");
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
        new DartivityMessage.iHave("", "", "", null, "");
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
        new DartivityMessage.iHave("", "", "", {}, null);
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
          "localhost");
      expect(message.toJSON(),
      '{"type":1,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost"}');
    });

    test("I Have  - fromJSON", () {
      DartivityMessage message = new DartivityMessage.fromJSON(
          '{"type":1,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost"}');
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
    });

    test("I Have  - fromJSONObject", () {
      jsonobject.JsonObject job = new jsonobject.JsonObject.fromJsonString(
          '{"type":1,"source":"web-server","destination":"global","resourceName":"oic/res","resourceDetails":{},"host":"localhost"}');
      DartivityMessage message = new DartivityMessage.fromJSONObject(job);
      expect(message.host, "localhost");
      expect(message.destination, DartivityMessage.ADDRESS_GLOBAL);
      expect(message.source, DartivityMessage.ADDRESS_WEB_SERVER);
      expect(message.resourceDetails, {});
      expect(message.resourceName, "oic/res");
    });

    test("I Have  - toString", () {
      DartivityMessage message = new DartivityMessage.iHave(
          DartivityMessage.ADDRESS_WEB_SERVER,
          DartivityMessage.ADDRESS_GLOBAL,
          "oic/res",
          {},
          "localhost");
      expect(message.toString(),
      "Type : Type.iHave, Host : localhost, Source : web-server, Destination : global, Resource Name : oic/res, Resource Details : {}");
    });
  });
}
