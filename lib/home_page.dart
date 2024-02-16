import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  final _receivePort = ReceivePort();

  bool isGranted = false;

  @override
  void initState() {
    super.initState();

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
        title: const Text('바코드 카피 헬퍼'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: TextField(
                controller: textEditingController,
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final status =
                          await FlutterOverlayWindow.isPermissionGranted();
                      log('권한 승인 상태: $status');
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 1),
                          content:
                              Text(status ? "권한 승인 상태" : '권한 거부 상태, 권한 부여필요')));
                    },
                    child: const Text("권한 확인"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final bool? res =
                          await FlutterOverlayWindow.requestPermission();
                      log("권한 승인 요청 결과: $res");
                    },
                    child: const Text("권한 요청"),
                  ),
                  TextButton(
                      onPressed: () async {
                        final isActive = await FlutterOverlayWindow.isActive();
                        if (isActive) return;
                        await FlutterOverlayWindow.showOverlay(
                            alignment: OverlayAlignment.topCenter,
                            enableDrag: false,
                            overlayTitle: '바코드 헬퍼',
                            overlayContent: '바코드 헬퍼 실행중',
                            flag: OverlayFlag.defaultFlag,
                            visibility: NotificationVisibility.visibilityPublic,
                            positionGravity: PositionGravity.none,
                            height: 500,
                            width: WindowSize.matchParent);
                      },
                      child: const Text('오버레이 켜기')),
                  TextButton(
                    onPressed: () async {
                      await FlutterOverlayWindow.closeOverlay();
                    },
                    child: const Text("오버레이 끄기"),
                  ),
                ],
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () async {
                List<List<String>> data = splitText();
                if (await FlutterOverlayWindow.isPermissionGranted()) {
                  await FlutterOverlayWindow.shareData(data);
                }
              },
              child: const Text("오버레이에 데이터 보내기"),
            ),
          ],
        ),
      ),
    );
  }

  List<List<String>> splitText() {
    Map<String, List<String>> data = {};
    LineSplitter ls = const LineSplitter();
    List<String> lsData = ls.convert(textEditingController.text);

    List<List<String>> res = lsData.map((e) => e.split(' ')).toList();
    for (List<String> barcodes in res) {
      data.update(barcodes[1], (value) {
        List<String> li = value;
        li.add(barcodes[0]);
        return li;
      }, ifAbsent: () {
        return data[barcodes[1]] = [barcodes[0]];
      });
    }
    List<List<String>> result = [];
    data.forEach((key, value) {
      List<String> temp = [key];
      temp.addAll(value);
      result.add(temp);
    });
    return result;
  }
}
