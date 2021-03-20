import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'src/entities.dart';
import 'src/response_builders.dart';
import 'src/rpc.dart';

export 'src/entities.dart';
export 'src/response_builders.dart';
export 'src/rpc.dart';
export 'src/widgets/apple_pay_button.dart';

class ApplePayError {
  final String error;

  const ApplePayError({required this.error});

  @override
  String toString() => error;
}

typedef DidAuthorizePayment = FutureOr<APayPaymentAuthorizationResult> Function(
    AuthorizePaymentRequest request, AuthorizationResultBuilder builder);
typedef DidSelectShippingMethod = FutureOr<APayRequestShippingMethodUpdate> Function(
    SelectShippingMethodRequest request, ShippingMethodUpdateBuilder builder);
typedef DidSelectShippingContact = FutureOr<APayRequestShippingContactUpdate> Function(
    SelectShippingContactRequest request, ShippingContactUpdateBuilder builder);
typedef DidSelectPaymentMethod = FutureOr<APayRequestPaymentMethodUpdate> Function(
    SelectPaymentMethodRequest request, PaymentMethodUpdateBuilder builder);
typedef DidError = FutureOr<void> Function(ApplePayError error);
typedef DidDismissed = FutureOr<void> Function();

class ApplePayPaymentHandler {
  final DidAuthorizePayment onAuthorize;
  final DidSelectShippingMethod onSelectShippingMethod;
  final DidSelectShippingContact onSelectShippingContact;
  final DidSelectPaymentMethod onSelectPaymentMethod;
  final DidError onError;
  final DidDismissed? onDismissed;

  const ApplePayPaymentHandler({
    required this.onAuthorize,
    required this.onSelectShippingMethod,
    required this.onSelectShippingContact,
    required this.onSelectPaymentMethod,
    required this.onError,
    this.onDismissed,
  });
}

class ApplePayConstants {
  static String postalAddressStreetKey = '';
  static String postalAddressSubLocalityKey = '';
  static String postalAddressCityKey = '';
  static String postalAddressSubAdministrativeAreaKey = '';
  static String postalAddressStateKey = '';
  static String postalAddressPostalCodeKey = '';
  static String postalAddressCountryKey = '';
  static String postalAddressISOCountryKey = '';
}

class ApplePayMimic {
  static const MethodChannel _channel = MethodChannel('apple_pay_mimic');

  static final _handlers = <int, ApplePayPaymentHandler>{};

  static Future<void> init() async {
    _channel.setMethodCallHandler(_methodCallHandler);

    final result = (await _channel.invokeMethod('fetchPostalAddressKeys') as Map);

    ApplePayConstants.postalAddressStreetKey = result['street'] as String;
    ApplePayConstants.postalAddressSubLocalityKey = result['subLocality'] as String;
    ApplePayConstants.postalAddressCityKey = result['city'] as String;
    ApplePayConstants.postalAddressSubAdministrativeAreaKey = result['subAdministrativeArea'] as String;
    ApplePayConstants.postalAddressStateKey = result['stateKey'] as String;
    ApplePayConstants.postalAddressPostalCodeKey = result['postalCode'] as String;
    ApplePayConstants.postalAddressCountryKey = result['country'] as String;
    ApplePayConstants.postalAddressISOCountryKey = result['isoCountryCode'] as String;
  }

  static Future<dynamic> _methodCallHandler(MethodCall call) async {
    print('[Apple Pay] FLUTTER handle: ${call.method}');
    if (call.method == 'didAuthorizePayment') {
      return await _didAuthorizePayment(call.arguments);
    } else if (call.method == 'didSelectShippingMethod') {
      return await _didSelectShippingMethod(call.arguments);
    } else if (call.method == 'didSelectShippingContact') {
      return await _didSelectShippingContact(call.arguments);
    } else if (call.method == 'didSelectPaymentMethod') {
      return await _didSelectPaymentMethod(call.arguments);
    } else if (call.method == 'error') {
      return await _handleError(call.arguments);
    } else if (call.method == 'dismissed') {
      return await _handleDismissed(call.arguments);
    }

    throw MissingPluginException();
  }

  static ApplePayPaymentHandler _handler(int id) {
    return _handlers[id]!;
  }

  static Future<dynamic> _didAuthorizePayment(dynamic arguments) async {
    try {
      final request = AuthorizePaymentRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).onAuthorize(request, AuthorizationResultBuilder());
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e');
      print(s);
    }
  }

  static Future<dynamic> _didSelectShippingMethod(dynamic arguments) async {
    try {
      final request = SelectShippingMethodRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).onSelectShippingMethod(request, ShippingMethodUpdateBuilder());
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e');
      print(s);
    }
  }

  static Future<dynamic> _didSelectShippingContact(dynamic arguments) async {
    try {
      final request = SelectShippingContactRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).onSelectShippingContact(request, ShippingContactUpdateBuilder());
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e');
      print(s);
    }
  }

  static Future<dynamic> _didSelectPaymentMethod(dynamic arguments) async {
    try {
      final request = SelectPaymentMethodRequest.fromJson(jsonDecode(arguments as String) as Map);
      final result = await _handler(request.id).onSelectPaymentMethod(request, PaymentMethodUpdateBuilder());
      final json = result.toJson();

      return jsonEncode(json);
    } catch (e, s) {
      print('[Apple Pay] internal error $e');
      print(s);
    }
  }

  static Future<dynamic> _handleError(dynamic arguments) async {
    if (arguments is! Map) {
      return print('[Apple Pay] _handleError arguments is not Map');
    }

    final id = arguments['id'] as int;
    final step = arguments['step'] as String?;

    print('error $arguments');

    _handler(id).onError(ApplePayError(error: step ?? ''));
  }

  static Future<dynamic> _handleDismissed(dynamic arguments) async {
    if (arguments is! Map) {
      return print('[Apple Pay] _handleDismissed arguments is not Map');
    }

    final id = arguments['id'] as int;

    _handler(id).onDismissed?.call();
  }

  static Future<List<APayPaymentNetwork>> availableNetworks() async {
    final result = await _channel.invokeMethod('availableNetworks') as String;
    final json = jsonDecode(result) as List;
    return json.map<APayPaymentNetwork>((e) => APayPaymentNetwork.fromJson(e as Map)).toList();
  }

  static Future<bool> canMakePayments([CanMakePaymentsRequest? request]) async {
    final arguments = request != null ? jsonEncode(request.toJson()) : null;
    final response = await _channel.invokeMethod('canMakePayments', arguments);
    if (response is bool) {
      return response;
    }
    throw response as Object;
  }

  static Future<void> processPayment({
    required ProcessPaymentRequest request,
    required DidAuthorizePayment onAuthorize,
    required DidSelectShippingMethod onSelectShippingMethod,
    required DidSelectShippingContact onSelectShippingContact,
    required DidSelectPaymentMethod onSelectPaymentMethod,
    required DidError onError,
    DidDismissed? onDismissed,
  }) async {
    final arguments = jsonEncode(request.toJson());
    final response = await _channel.invokeMethod('processPayment', arguments);
    if (response is! int) {
      throw 'wrong response';
    }
    _handlers[response] = ApplePayPaymentHandler(
      onAuthorize: onAuthorize,
      onSelectShippingMethod: onSelectShippingMethod,
      onSelectShippingContact: onSelectShippingContact,
      onSelectPaymentMethod: onSelectPaymentMethod,
      onError: onError,
      onDismissed: onDismissed,
    );
  }
}
