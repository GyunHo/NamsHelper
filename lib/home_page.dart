import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _receivePort = ReceivePort();
  SendPort? homePort;

  @override
  void initState() {
    super.initState();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      'HOME',
    );
    log("오버레이 포트 등록상태 : $res");

    _receivePort.listen((message) async {
      log("오버레이에서 보내온 메세지: $message");
      await Clipboard.setData(ClipboardData(text: message));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('남스 바코드 헬퍼'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  final status =
                      await FlutterOverlayWindow.isPermissionGranted();
                  log('권한 승인 상태: $status');
                },
                child: const Text("권한 확인"),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () async {
                  final bool? res =
                      await FlutterOverlayWindow.requestPermission();
                  log("권한 승인 요청 결과: $res");
                },
                child: const Text("다른앱 위에 그리기 권한 요청"),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                  onPressed: () async {
                    final isActive = await FlutterOverlayWindow.isActive();
                    if (isActive) return;
                    await FlutterOverlayWindow.showOverlay(
                        alignment: OverlayAlignment.topCenter,
                        enableDrag: false,
                        overlayTitle: '남스 헬퍼',
                        overlayContent: '남스 헬퍼 실행중',
                        flag: OverlayFlag.focusPointer,
                        visibility: NotificationVisibility.visibilityPublic,
                        positionGravity: PositionGravity.none,
                        height: 500,
                        width: WindowSize.matchParent);
                  },
                  child: const Text('오버레이 켜기')),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () async {
                  await FlutterOverlayWindow.closeOverlay();
                },
                child: const Text("오버레이 끄기"),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () async {
                  List<List<String>> sendData = [
                    ['1', '2', '3', '4'],
                    ['4', '5', '6', '7'],
                    ['8', '9', '10', '11']
                  ];
                  await FlutterOverlayWindow.shareData(sendData);
                },
                child: const Text("오버레이에 데이터 보내기"),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
