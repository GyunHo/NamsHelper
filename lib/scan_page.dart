import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ai_barcode/ai_barcode.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<String> dataList = [];
  late ScannerController _scannerController;
  final StreamController<String> _streamController = StreamController<String>();

  void _streamCallback(String result) {
    _streamController.sink.add(result);
  }

  @override
  void initState() {
    _scannerController = ScannerController(
        scannerResult: _streamCallback,
        scannerViewCreated: () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _scannerController.stopCamera();
    _scannerController.stopCameraPreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('scan')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: PlatformAiBarcodeScannerWidget(

              platformScannerController: _scannerController,
            )),
            StreamBuilder(
                stream: _streamController.stream,
                builder: (streamContext, snapshot) {
                  if (snapshot.hasData) {
                    if (!dataList.contains(snapshot.data!)) {
                      dataList.add(snapshot.data!);
                    }
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (listContext, index) {
                        return ListTile(
                          title: Text(dataList[index]),
                        );
                      },
                      itemCount: dataList.length,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
