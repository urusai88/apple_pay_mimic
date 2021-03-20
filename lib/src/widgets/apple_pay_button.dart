import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class APayPaymentButtonType {
  final String value;

  const APayPaymentButtonType._(this.value);

  factory APayPaymentButtonType.fromJson(Map map) {
    return APayPaymentButtonType._(map['value'] as String);
  }

  static const APayPaymentButtonType plain = APayPaymentButtonType._('plain');
  static const APayPaymentButtonType buy = APayPaymentButtonType._('buy');
  static const APayPaymentButtonType addMoney = APayPaymentButtonType._('addMoney');
  static const APayPaymentButtonType book = APayPaymentButtonType._('book');
  static const APayPaymentButtonType checkout = APayPaymentButtonType._('checkout');
  static const APayPaymentButtonType contribute = APayPaymentButtonType._('contribute');
  static const APayPaymentButtonType donate = APayPaymentButtonType._('donate');
  static const APayPaymentButtonType inStore = APayPaymentButtonType._('inStore');
  static const APayPaymentButtonType order = APayPaymentButtonType._('order');
  static const APayPaymentButtonType reload = APayPaymentButtonType._('reload');
  static const APayPaymentButtonType rent = APayPaymentButtonType._('rent');
  static const APayPaymentButtonType setUp = APayPaymentButtonType._('setUp');
  static const APayPaymentButtonType subscribe = APayPaymentButtonType._('subscribe');
  static const APayPaymentButtonType tip = APayPaymentButtonType._('tip');
  static const APayPaymentButtonType topUp = APayPaymentButtonType._('topUp');

  Map toJson() => {'value': value};
}

class APayPaymentButtonStyle {
  final String value;

  const APayPaymentButtonStyle._(this.value);

  factory APayPaymentButtonStyle.fromJson(Map map) {
    return APayPaymentButtonStyle._(map['value'] as String);
  }

  static const APayPaymentButtonStyle white = APayPaymentButtonStyle._('white');
  static const APayPaymentButtonStyle whiteOutlined = APayPaymentButtonStyle._('whiteOutlined');
  static const APayPaymentButtonStyle black = APayPaymentButtonStyle._('black');
  static const APayPaymentButtonStyle automatic = APayPaymentButtonStyle._('automatic');

  Map toJson() => {'value': value};
}

class APayPaymentButtonArguments {
  final APayPaymentButtonType type;
  final APayPaymentButtonStyle style;

  const APayPaymentButtonArguments({required this.type, required this.style});

  Map toJson() => {'type': type.toJson(), 'style': style.toJson()};
}

class _ApplyPayButtonHandler {
  static const _channel = MethodChannel('apple_pay_mimic_button');
  static final _handlers = <int, VoidCallback>{};

  static bool _isInit = false;

  static void _init() {
    if (_isInit) return;
    _isInit = true;
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static Future<void> _methodCallHandler(MethodCall call) async {
    final arguments = call.arguments;
    if (call.method == 'tap') {
      if (arguments is int) {
        _handlers[arguments]?.call();
      }
    }
  }

  static void _register(int id, VoidCallback onTap) {
    _init();
    _handlers[id] = onTap;
  }
}

class ApplePayButton extends StatelessWidget {
  final APayPaymentButtonType? type;
  final APayPaymentButtonStyle? style;
  final VoidCallback? onPressed;

  const ApplePayButton({this.type, this.style, this.onPressed}) : assert((type == null) == (style == null));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        assert(() {
          if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
            throw 'Provide a bounded constraints';
          }
          return true;
        }());

        APayPaymentButtonArguments? arguments;
        dynamic creationParams;
        if (type != null && style != null) {
          arguments = APayPaymentButtonArguments(type: type!, style: style!);
          creationParams = jsonEncode(arguments.toJson());
        }

        return UiKitView(
          hitTestBehavior: PlatformViewHitTestBehavior.translucent,
          key: creationParams != null ? ValueKey(creationParams) : null,
          viewType: 'apple_pay_mimic_button',
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          onPlatformViewCreated: (int id) {
            if (onPressed != null) {
              _ApplyPayButtonHandler._register(id, onPressed!);
            }
          },
        );
      },
    );
  }
}
