import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutteradform/flutteradform.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_adform');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Flutteradform.platformVersion, '42');
  });
}
