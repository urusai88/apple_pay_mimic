class APayPaymentAuthStatus {
  final int value;

  const APayPaymentAuthStatus(this.value);

  static APayPaymentAuthStatus fromJson(Map map) => APayPaymentAuthStatus(map['value'] as int);

  Map toJson() => {'value': value};

  static const success = APayPaymentAuthStatus(0);
  static const failure = APayPaymentAuthStatus(1);
}

class APayPaymentNetwork {
  final String value;

  const APayPaymentNetwork(this.value);

  static APayPaymentNetwork fromJson(Map map) => APayPaymentNetwork(map['value'] as String);

  Map toJson() => {'value': value};

  static const carteBancaire = APayPaymentNetwork("carteBancaire");
  static const carteBancaires = APayPaymentNetwork("carteBancaires");
  static const cartesBancaires = APayPaymentNetwork("cartesBancaires");
  static const chinaUnionPay = APayPaymentNetwork("chinaUnionPay");
  static const discover = APayPaymentNetwork("discover");
  static const eftpos = APayPaymentNetwork("eftpos");
  static const electron = APayPaymentNetwork("electron");
  static const elo = APayPaymentNetwork("elo");
  static const idCredit = APayPaymentNetwork("idCredit");
  static const interac = APayPaymentNetwork("interac");
  static const JCB = APayPaymentNetwork("JCB");
  static const mada = APayPaymentNetwork("mada");
  static const maestro = APayPaymentNetwork("maestro");
  static const masterCard = APayPaymentNetwork("masterCard");
  static const privateLabel = APayPaymentNetwork("privateLabel");
  static const quicPay = APayPaymentNetwork("quicPay");
  static const suica = APayPaymentNetwork("suica");
  static const visa = APayPaymentNetwork("visa");
  static const vPay = APayPaymentNetwork("vPay");
  static const barcode = APayPaymentNetwork("barcode");
  static const girocard = APayPaymentNetwork("girocard");
}

class APayMerchantCapability {
  final String value;

  const APayMerchantCapability(this.value);

  static APayMerchantCapability fromJson(Map map) => APayMerchantCapability(map['value'] as String);

  Map toJson() => {'value': value};

  static const capability3DS = APayMerchantCapability("capability3DS");
  static const capabilityEMV = APayMerchantCapability("capabilityEMV");
  static const capabilityCredit = APayMerchantCapability("capabilityCredit");
  static const capabilityDebit = APayMerchantCapability("capabilityDebit");
}

class APayShippingType {
  final String value;

  const APayShippingType(this.value);

  static APayShippingType fromJson(Map map) => APayShippingType(map['value'] as String);

  Map toJson() => {'value': value};

  static const shipping = APayShippingType("shipping");
  static const delivery = APayShippingType("delivery");
  static const storePickup = APayShippingType("storePickup");
  static const servicePickup = APayShippingType("servicePickup");
}

class APayContactField {
  final String value;

  const APayContactField(this.value);

  static APayContactField fromJson(Map map) => APayContactField(map['value'] as String);

  Map toJson() => {'value': value};

  static const postalAddress = APayContactField("postalAddress");
  static const emailAddress = APayContactField("emailAddress");
  static const phoneNumber = APayContactField("phoneNumber");
  static const name = APayContactField("name");
  static const phoneticName = APayContactField("phoneticName");

  static const List<APayContactField> all = [postalAddress, emailAddress, phoneNumber, name, phoneticName];
}

class APayPaymentSummaryItemType {
  final int value;

  const APayPaymentSummaryItemType(this.value);

  static APayPaymentSummaryItemType fromJson(Map map) => APayPaymentSummaryItemType(map['value'] as int);

  Map toJson() => {'value': value};

  static const finall = APayPaymentSummaryItemType(0);
  static const pending = APayPaymentSummaryItemType(1);
}

class APayPaymentMethodType {
  final int value;

  const APayPaymentMethodType(this.value);

  static APayPaymentMethodType fromJson(Map map) => APayPaymentMethodType(map['value'] as int);

  Map toJson() => {'value': value};

  static const unknown = APayPaymentSummaryItemType(0);
  static const debit = APayPaymentSummaryItemType(1);
  static const credit = APayPaymentSummaryItemType(0);
  static const prepaid = APayPaymentSummaryItemType(1);
  static const store = APayPaymentSummaryItemType(0);
}

class APayPaymentMethod {
  final String? displayName;
  final APayPaymentNetwork? network;
  final APayPaymentMethodType type;

  const APayPaymentMethod({this.displayName, this.network, required this.type});

  static APayPaymentMethod fromJson(Map map) => APayPaymentMethod(
        displayName: map['displayName'] as String?,
        network: map['network'] != null ? APayPaymentNetwork.fromJson(map['network'] as Map) : null,
        type: APayPaymentMethodType.fromJson(map['type'] as Map),
      );
}

class APayPaymentSummaryItem {
  final String label;
  final double amount;
  final APayPaymentSummaryItemType type;

  const APayPaymentSummaryItem({
    required this.label,
    required this.amount,
    this.type = APayPaymentSummaryItemType.finall,
  });

  static APayPaymentSummaryItem fromJson(Map map) {
    return APayPaymentSummaryItem(
      label: map['label'] as String,
      amount: map['amount'] as double,
      type: APayPaymentSummaryItemType.fromJson(map['type'] as Map),
    );
  }

  Map toJson() => {'label': label, 'amount': amount, 'type': type.toJson()};
}

class APayShippingMethod {
  final String label;
  final double amount;
  final APayPaymentSummaryItemType type;
  final String? identifier;
  final String? detail;

  const APayShippingMethod({
    required this.label,
    required this.amount,
    this.type = APayPaymentSummaryItemType.finall,
    this.identifier,
    this.detail,
  });

  static APayShippingMethod fromJson(Map map) {
    return APayShippingMethod(
      label: map['label'] as String,
      amount: map['amount'] as double,
      type: APayPaymentSummaryItemType.fromJson(map['type'] as Map),
      identifier: map['identifier'] as String?,
      detail: map['detail'] as String?,
    );
  }

  Map toJson() => {
        'label': label,
        'amount': amount,
        'type': type.toJson(),
        'identifier': identifier,
        'detail': detail,
      };
}

class APayPersonNameComponents {
  final String? namePrefix;
  final String? givenName;
  final String? middleName;
  final String? familyName;
  final String? nameSuffix;
  final String? nickname;
  final APayPersonNameComponents? phoneticRepresentation;

  const APayPersonNameComponents({
    this.namePrefix,
    this.givenName,
    this.middleName,
    this.familyName,
    this.nameSuffix,
    this.nickname,
    this.phoneticRepresentation,
  });

  static APayPersonNameComponents fromJson(Map map) {
    return APayPersonNameComponents(
      namePrefix: map['namePrefix'] as String?,
      givenName: map['givenName'] as String?,
      middleName: map['middleName'] as String?,
      familyName: map['familyName'] as String?,
      nameSuffix: map['nameSuffix'] as String?,
      nickname: map['nickname'] as String?,
      phoneticRepresentation: map['phoneticRepresentation'] != null
          ? APayPersonNameComponents.fromJson(map['phoneticRepresentation'] as Map)
          : null,
    );
  }

  Map toJson() => {
        'namePrefix': namePrefix,
        'givenName': givenName,
        'middleName': middleName,
        'familyName': familyName,
        'nameSuffix': nameSuffix,
        'nickname': nickname,
        'phoneticRepresentation': phoneticRepresentation?.toJson(),
      };
}

class APayPostalAddress {
  final String street;
  final String subLocality;
  final String city;
  final String subAdministrativeArea;
  final String state;
  final String postalCode;
  final String country;
  final String isoCountryCode;

  const APayPostalAddress({
    required this.street,
    required this.subLocality,
    required this.city,
    required this.subAdministrativeArea,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isoCountryCode,
  });

  static APayPostalAddress fromJson(Map map) {
    return APayPostalAddress(
      street: map['street'] as String,
      subLocality: map['subLocality'] as String,
      city: map['city'] as String,
      subAdministrativeArea: map['subAdministrativeArea'] as String,
      state: map['state'] as String,
      postalCode: map['postalCode'] as String,
      country: map['country'] as String,
      isoCountryCode: map['isoCountryCode'] as String,
    );
  }

  Map toJson() => {
        'street': street,
        'subLocality': subLocality,
        'city': city,
        'subAdministrativeArea': subAdministrativeArea,
        'state': state,
        'postalCode': postalCode,
        'country': country,
        'isoCountryCode': isoCountryCode,
      };
}

class APayContact {
  final APayPersonNameComponents? name;
  final APayPostalAddress? postalAddress;
  final String? phoneNumber;
  final String? emailAddress;

  const APayContact({this.name, this.postalAddress, this.phoneNumber, this.emailAddress});

  static APayContact fromJson(Map map) {
    return APayContact(
      name: map['name'] != null ? APayPersonNameComponents.fromJson(map['name'] as Map) : null,
      postalAddress: map['postalAddress'] != null ? APayPostalAddress.fromJson(map['postalAddress'] as Map) : null,
      phoneNumber: map['phoneNumber'] as String?,
      emailAddress: map['emailAddress'] as String?,
    );
  }

  Map toJson() => {
        'name': name?.toJson(),
        'postalAddress': postalAddress?.toJson(),
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
      };
}

class APayPaymentToken {
  final APayPaymentMethod paymentMethod;
  final String transactionIdentifier;
  final String paymentData;

  const APayPaymentToken({required this.paymentMethod, required this.transactionIdentifier, required this.paymentData});

  static APayPaymentToken fromJson(Map map) {
    return APayPaymentToken(
      paymentMethod: APayPaymentMethod.fromJson(map['paymentMethod'] as Map),
      transactionIdentifier: map['transactionIdentifier'] as String,
      paymentData: map['paymentData'] as String,
    );
  }
}

class APayPayment {
  final APayPaymentToken token;
  final APayContact? billingContact;
  final APayContact? shippingContact;
  final APayShippingMethod? shippingMethod;

  const APayPayment({required this.token, this.billingContact, this.shippingContact, this.shippingMethod});

  static APayPayment fromJson(Map map) {
    return APayPayment(
      token: APayPaymentToken.fromJson(map['token'] as Map),
      billingContact: map['billingContact'] != null ? APayContact.fromJson(map['billingContact'] as Map) : null,
      shippingContact: map['shippingContact'] != null ? APayContact.fromJson(map['shippingContact'] as Map) : null,
      shippingMethod: map['shippingMethod'] != null ? APayShippingMethod.fromJson(map['shippingMethod'] as Map) : null,
    );
  }
}

class APayPaymentError {
  final String errorType;
  final String? localizedDescription;
  final String? postalAddressKey;
  final APayContactField? contactField;

  const APayPaymentError({
    required this.errorType,
    this.localizedDescription,
    this.postalAddressKey,
    this.contactField,
  });

  Map toJson() => {
        'errorType': errorType,
        'localizedDescription': localizedDescription,
        'postalAddressKey': postalAddressKey,
        'contactField': contactField?.toJson(),
      };

  factory APayPaymentError.contactInvalid({required APayContactField contactField, String? localizedDescription}) {
    return APayPaymentError(
      errorType: 'paymentErrorContactInvalid',
      contactField: contactField,
      localizedDescription: localizedDescription,
    );
  }

  factory APayPaymentError.shippingAddressInvalid({String postalAddressKey = '', String? localizedDescription}) {
    return APayPaymentError(
      errorType: 'paymentErrorShippingAddressInvalid',
      postalAddressKey: postalAddressKey,
      localizedDescription: localizedDescription,
    );
  }
}

class APayPaymentAuthorizationResult {
  final APayPaymentAuthStatus status;
  final List<APayPaymentError>? errors;

  const APayPaymentAuthorizationResult({required this.status, this.errors});

  Map toJson() => {
        'status': status.toJson(),
        'errors': errors?.map((e) => e.toJson()).toList(),
      };
}

class APayRequestShippingMethodUpdate {
  final APayPaymentAuthStatus status;
  final List<APayPaymentSummaryItem> paymentSummaryItems;

  const APayRequestShippingMethodUpdate({required this.status, required this.paymentSummaryItems});

  Map toJson() => {
        'status': status.toJson(),
        'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
      };
}

class APayRequestShippingContactUpdate {
  final APayPaymentAuthStatus status;
  final List<APayPaymentSummaryItem> paymentSummaryItems;
  final List<APayShippingMethod> shippingMethods;
  final List<APayPaymentError>? errors;

  const APayRequestShippingContactUpdate({
    required this.status,
    required this.paymentSummaryItems,
    required this.shippingMethods,
    this.errors,
  });

  Map toJson() => {
        'status': status.toJson(),
        'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
        'shippingMethods': shippingMethods.map((e) => e.toJson()).toList(),
        'errors': errors?.map((e) => e.toJson()).toList(),
      };
}

class APayRequestPaymentMethodUpdate {
  final APayPaymentAuthStatus status;
  final List<APayPaymentSummaryItem> paymentSummaryItems;
  final List<APayPaymentError>? errors;

  const APayRequestPaymentMethodUpdate({
    required this.status,
    required this.paymentSummaryItems,
    this.errors,
  });

  Map toJson() => {
        'status': status.toJson(),
        'paymentSummaryItems': paymentSummaryItems.map((e) => e.toJson()).toList(),
        'errors': errors?.map((e) => e.toJson()).toList(),
      };
}
