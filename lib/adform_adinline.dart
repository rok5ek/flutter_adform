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
    if (state == AppLifecycleState.resumed) {
      _channel.invokeMethod("resumed");
    } else if (state == AppLifecycleState.paused) {
      _channel.invokeMethod("paused");
    } else if (state == AppLifecycleState.detached) {
      _channel.invokeMethod("detached");
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
                "masterTagId": widget.masterTagId,
                "width": widget.width.toInt(),
                "height": widget.height.toInt()
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
                "masterTagId": widget.masterTagId,
                "width": widget.width.toInt(),
                "height": widget.height.toInt()
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
    _channel.invokeMethod("dispose");
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel("${ADFORM_INLINE_CHANNEL}_$id");
  }
}
