import 'entities.dart';

class CanMakePaymentsRequest {
  final List<APayPaymentNetwork>? usingNetworks;
  final List<APayMerchantCapability>? capabilities;

  const CanMakePaymentsRequest({this.usingNetworks, this.capabilities});

  Map toJson() => {
        'usingNetworks': usingNetworks?.map((e) => e.toJson()).toList(),
        'capabilities': capabilities?.map((e) => e.toJson()).toList(),
      };
}

class ProcessPaymentRequest {
  final String merchantIdentifier;
  final String countryCode;
  final String currencyCode;
  final List<APayPaymentNetwork> supportedNetworks;
  final List<APayMerchantCapability> merchantCapabilities;
  final List<APayPaymentSummaryItem> paymentSummaryItems;
  final List<APayContactField>? requiredBillingContactFields;
  final List<APayContactField>? requiredShippingContactFields;
  final APayContact? billingContact;
  final APayContact? shippingContact;
  final List<APayShippingMethod>? shippingMethods;
  final APayShippingType shippingType;
  final String? applicationData;
  final List<String>? supportedCountries;

  const ProcessPaymentRequest({
    required this.merchantIdentifier,
    required this.countryCode,
    required this.currencyCode,
    required this.supportedNetworks,
    required this.merchantCapabilities,
    required this.paymentSummaryItems,
    this.requiredBillingContactFields,
    this.requiredShippingContactFields,
    this.billingContact,
    this.shippingContact,
    this.shippingMethods,
    required this.shippingType,
    this.applicationData,
    this.supportedCountries,
  });

  Map toJson() => {
        'merchantIdentifier': merchantIdentifier,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
        'supportedNetworks': supportedNetworks.map((e) => e.toJson()).toList(),
        'merchantCapabilities': merchantCapabilities.map((e) => e.toJson()).toList(),
        'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
        'requiredBillingContactFields': requiredBillingContactFields?.map((e) => e.toJson()).toList(),
        'requiredShippingContactFields': requiredShippingContactFields?.map((e) => e.toJson()).toList(),
        'billingContact': billingContact?.toJson(),
        'shippingContact': shippingContact?.toJson(),
        'shippingMethods': shippingMethods?.map((e) => e.toJson()).toList(),
        'shippingType': shippingType.toJson(),
        'applicationData': applicationData,
        'supportedCountries': supportedCountries,
      };
}

class SelectPaymentMethodRequest {
  final int id;
  final APayPaymentMethod paymentMethod;

  const SelectPaymentMethodRequest({required this.id, required this.paymentMethod});

  static SelectPaymentMethodRequest fromJson(Map map) {
    return SelectPaymentMethodRequest(
      id: map['id'] as int,
      paymentMethod: APayPaymentMethod.fromJson(map['paymentMethod'] as Map),
    );
  }
}

class SelectShippingContactRequest {
  final int id;
  final APayContact shippingContact;

  const SelectShippingContactRequest({required this.id, required this.shippingContact});

  static SelectShippingContactRequest fromJson(Map map) {
    return SelectShippingContactRequest(
      id: map['id'] as int,
      shippingContact: APayContact.fromJson(map['shippingContact'] as Map),
    );
  }
}

class SelectShippingMethodRequest {
  final int id;
  final APayShippingMethod shippingMethod;

  const SelectShippingMethodRequest({required this.id, required this.shippingMethod});

  static SelectShippingMethodRequest fromJson(Map map) {
    return SelectShippingMethodRequest(
      id: map['id'] as int,
      shippingMethod: APayShippingMethod.fromJson(map['shippingMethod'] as Map),
    );
  }
}

class AuthorizePaymentRequest {
  final int id;
  final APayPayment payment;

  const AuthorizePaymentRequest({required this.id, required this.payment});

  static AuthorizePaymentRequest fromJson(Map map) {
    return AuthorizePaymentRequest(
      id: map['id'] as int,
      payment: APayPayment.fromJson(map['payment'] as Map),
    );
  }
}