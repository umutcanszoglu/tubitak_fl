import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:msku2209b/controllers/data_controller.dart';

class MQTTManager {
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;

  MQTTManager({
    required String host,
    required String topic,
    required String identifier,
  })  : _identifier = identifier,
        _host = host,
        _topic = topic;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    // debugPrint('EXAMPLE::Mosquitto client connecting....');
    _client!.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    final controller = Get.find<DataController>();
    assert(_client != null);
    try {
      // debugPrint('EXAMPLE::Mosquitto start client connecting....');
      await _client!.connect();
      controller.currentState.value = MQTTAppConnectionState.connected;
    } on Exception catch (e) {
      // debugPrint('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    // debugPrint('Disconnected');
    Get.find<DataController>().currentState.value =
        MQTTAppConnectionState.disconnected;

    _client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client?.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!,
        retain: true);
  }

  void onSubscribed(String topic) {
    // debugPrint('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    // debugPrint(
    //     'EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      // debugPrint(
      //     'EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  void onConnected() {
    // debugPrint('EXAMPLE::Mosquitto client connected....');
    _client!.subscribe(_topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final controller = Get.find<DataController>();
      controller.setReceivedText(pt);
      final mapData = <String, RxDouble>{};
      Map map = json.decode(pt);
      for (var key in map.keys) {
        mapData[key] = double.tryParse(map[key])!.obs;
      }

      controller.data.value = mapData;
      // debugPrint(
      //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
    // debugPrint(
    //     'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}
