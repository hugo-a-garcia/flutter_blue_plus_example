import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanScreenRiverpod extends ConsumerWidget {
  const ScanScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncResults = ref.watch(scanResultsProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Blue River')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => ref.refresh(startScanProvider),
              child: Text('Scan'),
            ),
            switch (asyncResults) {
              AsyncData(:final value) => ListView.builder(
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final advName = value[index];
                  return Text(advName);
                },
              ),
              AsyncError(:final error) => Text(error.toString()),
              _ => const CircularProgressIndicator(),
            },
          ],
        ),
      ),
    );
  }
}

final startScanProvider = FutureProvider<void>((ref) async {
  Duration timeout = const Duration(seconds: 3);
  await FlutterBluePlus.startScan(timeout: timeout, oneByOne: true);
});

final scanResultsProvider = StreamProvider<List<String>>((ref) async* {
  ref.watch(startScanProvider);
  Stream<List<ScanResult>> scanResults = FlutterBluePlus.scanResults;

  List<String> scansResultsList = [];
  await for (List<ScanResult> scanResultList in scanResults) {
    for (var element in scanResultList) {
      String advName = element.advertisementData.advName;
      String devId = element.device.remoteId.toString();
      scansResultsList.add('$advName $devId');
      // print('==============');
      // print(scansResultsList);
      // print('<<==============>>');
      yield scansResultsList;
    }
  }
});
