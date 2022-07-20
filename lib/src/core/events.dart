import '../interfaces/interfaces.dart';

abstract class LiveCareEvent {}

class LiveAuthenticated extends LiveCareEvent {}

class LiveAuthenticateFailed extends LiveCareEvent {}

class LiveScanning extends LiveCareEvent {}

class LiveScanCompleted extends LiveCareEvent {}

class LiveDataReceived extends LiveCareEvent {
  final Device device;
  LiveDataReceived(this.device);
}

class LiveDeviceConnected extends LiveCareEvent {
  final Device device;
  LiveDeviceConnected(this.device);
}

class LiveDeviceDisconnected extends LiveCareEvent {
  final Device device;
  LiveDeviceDisconnected(this.device);
}
