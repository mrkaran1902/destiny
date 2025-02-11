import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Mqttconn {
  late MqttServerClient client;

  Future<void> connectToMqtt() async {
    client = MqttServerClient('photodiode-y28f5h.a03.euc1.aws.hivemq.cloud', '')
      ..port = 8883
      ..secure = true
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..connectionMessage = MqttConnectMessage()
          .withClientIdentifier('flutter_client')
          .authenticateAs('Rasp-pi', 'Rasp-pi@2025')
          .startClean()
          .withWillQos(MqttQos.atMostOnce);

    try {
      await client.connect();
    } catch (e) {
      client.disconnect();
    }
  }

  void publishMessage(String topic, String message) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder()..addString(message);
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    } else {
    }
  }

  void disconnect() {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.disconnect();
    }
  }
}
