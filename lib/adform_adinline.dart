import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AdformAdinline extends StatefulWidget {
  final int masterTagId;
  final double width;
  final double height;

  AdformAdinline(
      {Key key,
      @required this.masterTagId,
      @required this.width,
      @required this.height})
      : super(key: key);

  @override
  _AdformAdinlineState createState() => _AdformAdinlineState();
}

class _AdformAdinlineState extends State<AdformAdinline>
    with WidgetsBindingObserver {
  UniqueKey _key = UniqueKey();
  static const ADFORM_INLINE_CHANNEL = "flutter_adform/adInline";
  static const RESUMED = "resumed";
  static const PAUSED = "paused";
  static const DETACHED = "detached";
  static const DISPOSE = "dispose";
  static const ARG_MASTER_TAG_ID = "masterTagId";
  static const ARG_WIDTH = "width";
  static const ARG_HEIGHT = "height";
  MethodChannel _channel;
  Future<Size> adSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    adSize = adSize = Future.value(Size(
      widget.width,
      widget.height,
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // call lifecycle method only on Android
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (state == AppLifecycleState.resumed) {
        _channel.invokeMethod(RESUMED);
      } else if (state == AppLifecycleState.paused) {
        _channel.invokeMethod(PAUSED);
      } else if (state == AppLifecycleState.detached) {
        _channel.invokeMethod(DETACHED);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: adSize,
      builder: (context, snapshot) {
        final adSize = snapshot.data;
        if (adSize == null) {
          return SizedBox.shrink();
        }

        if (defaultTargetPlatform == TargetPlatform.android) {
          return SizedBox.fromSize(
            size: adSize,
            child: AndroidView(
              key: _key,
              viewType: ADFORM_INLINE_CHANNEL,
              creationParams: <String, dynamic>{
                ARG_MASTER_TAG_ID: widget.masterTagId,
                ARG_WIDTH: widget.width.toInt(),
                ARG_HEIGHT: widget.height.toInt()
              },
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),
          );
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          return SizedBox.fromSize(
            size: adSize,
            child: UiKitView(
              key: _key,
              viewType: ADFORM_INLINE_CHANNEL,
              creationParams: <String, dynamic>{
                ARG_MASTER_TAG_ID: widget.masterTagId,
                ARG_WIDTH: widget.width.toInt(),
                ARG_HEIGHT: widget.height.toInt()
              },
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),
          );
        }
        return Text(
            '$defaultTargetPlatform is not yet supported by the plugin');
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _channel.invokeMethod(DISPOSE);
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel("${ADFORM_INLINE_CHANNEL}_$id");
  }
}
