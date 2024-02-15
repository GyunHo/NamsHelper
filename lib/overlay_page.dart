import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayPage extends StatefulWidget {
  const OverlayPage({super.key});

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withOpacity(0.1),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: StreamBuilder<dynamic>(
                        stream: FlutterOverlayWindow.overlayListener,
                        builder: (context, snapshot) {
                          String data = snapshot.data.toString();
                          return Text(
                            data,
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          );
                        }),
                  ),
                  const Spacer(),
                  const Divider(color: Colors.black54),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    await FlutterOverlayWindow.closeOverlay();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
