// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_example/screens/tp_scaen_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';
import 'providers/bluetooth_providers.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(ProviderScope(child: MaterialApp(home: const FlutterBlueApp())));
}

class FlutterBlueApp extends ConsumerWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothAdapterAsync = ref.watch(bluetoothAdapterStateProvider);
    return switch (bluetoothAdapterAsync) {
      AsyncData(:final value) => returnScreen(value),
      AsyncError(:final error) => Text(error.toString()),
      _ => CircularProgressIndicator(),
    };
  }

  Widget returnScreen(BluetoothAdapterState adapterState) {
    return adapterState == BluetoothAdapterState.on
        ? const ScanScreenRiverpod()
        : BluetoothOffScreen(adapterState: adapterState);
  }
}
