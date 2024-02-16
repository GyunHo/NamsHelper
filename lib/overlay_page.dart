import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter/services.dart';

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
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: StreamBuilder<dynamic>(
              stream: FlutterOverlayWindow.overlayListener,
              builder: (context, snapshot) {
                data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length??0,
                    itemBuilder: (BuildContext listContext, int count) {
                      return ListTile(
                        leading:
                        Text(data?[count]),
                        onTap: () {
                          SendPort? toHomePort =
                              IsolateNameServer.lookupPortByName('HOME');
                          toHomePort?.send('오버레이에서 보냅니다.');
                        },
                        trailing: IconButton(
                          onPressed: () async {
                            await FlutterOverlayWindow.closeOverlay();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
