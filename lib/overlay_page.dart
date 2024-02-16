import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayPage extends StatefulWidget {
  const OverlayPage({super.key});

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  List<dynamic>? data = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withOpacity(0.4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        width: double.infinity,
        child: StreamBuilder<dynamic>(
            stream: FlutterOverlayWindow.overlayListener,
            builder: (context, snapshot) {
              data = snapshot.data;
              return ListView.builder(
                  itemCount: data?.length ?? 0,
                  itemBuilder: (BuildContext listContext, int count) {
                    SendPort? toHomePort =
                        IsolateNameServer.lookupPortByName('HOME');
                    List<dynamic> showData = data?[count];
                    List<TextButton> barcodes = showData.map((barcode) {
                      return TextButton(
                          onPressed: () {
                            toHomePort?.send(barcode.toString());
                          },
                          child: Text(
                            barcode.toString(),
                            style: TextStyle(color: Colors.red),
                          ));
                    }).toList();
                    return ListTile(
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: barcodes,
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
