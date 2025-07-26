import 'dart:async';
import 'package:light/light.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  final _proximityController = StreamController<bool>.broadcast();
  final _lightController = StreamController<int>.broadcast();
  final _shakeController = StreamController<void>.broadcast();

  Stream<bool> get proximityStream => _proximityController.stream;
  Stream<int> get lightStream => _lightController.stream;
  Stream<void> get shakeStream => _shakeController.stream;

  StreamSubscription? _proximitySub;
  StreamSubscription? _lightSub;
  StreamSubscription? _accelSub;

  void initSensors() {
    _proximitySub = ProximitySensor.events.listen((event) {
      _proximityController.add(event > 0); // true = close
    });

    final light = Light();
    _lightSub = light.lightSensorStream.listen((lux) {
      _lightController.add(lux);
    });

    const shakeThreshold = 15.0;
    _accelSub = accelerometerEvents.listen((event) {
      final magnitude =
          event.x * event.x + event.y * event.y + event.z * event.z;
      if (magnitude > shakeThreshold * shakeThreshold) {
        _shakeController.add(null);
      }
    });
  }

  void dispose() {
    _proximitySub?.cancel();
    _lightSub?.cancel();
    _accelSub?.cancel();

    _proximityController.close();
    _lightController.close();
    _shakeController.close();
  }
}
