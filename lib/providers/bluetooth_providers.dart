import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothAdapterStateProvider = StreamProvider<BluetoothAdapterState>((
  ref,
) async* {
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;

  await for (var element in FlutterBluePlus.adapterState) {
    adapterState = element;
    yield adapterState;
  }
});
