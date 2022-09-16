import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Android platform views'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                const Text('Android EditText:'),
                SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: NativeTextBox(),
                ),
                SizedBox(height: 8),
                const Text('Flutter TextField:'),
                SizedBox(
                  height: 50,
                  child: TextField(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NativeTextBox extends StatelessWidget {
  const NativeTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    const String viewType = 'native-widget';
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    if(!Platform.isAndroid) {
      return Text('Implemented only for Android!');
    }

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}


