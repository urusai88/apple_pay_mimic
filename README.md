# Apple Pay Mimic

Apple Pay Mimic contains mimics to PassKit

## Getting Started

### Requires iOS 12

* Add apple_pay_mimic dependency to your pubspec.yaml
* Call ```await ApplePayMimic.init()``` for plugin initialization
* You are ready

## Table of Mimics
### Enums
| PassKit | ApplePayMimic |
| --- | --- |
| [PKPaymentNetwork](https://developer.apple.com/documentation/passkit/pkpaymentnetwork) | ```APayPaymentNetwork``` |
| [PKMerchantCapability](https://developer.apple.com/documentation/passkit/pkmerchantcapability) | ```APayMerchantCapability``` |
| [PKShippingType](https://developer.apple.com/documentation/passkit/pkshippingtype) | ```APayShippingType``` |
| [PKContactField](https://developer.apple.com/documentation/passkit/pkcontactfield) | ```APayContactField``` |
| [PKPaymentSummaryItemType](https://developer.apple.com/documentation/passkit/pkpaymentsummaryitemtype) | ```APayPaymentSummaryItemType``` |
| [PKPaymentMethodType](https://developer.apple.com/documentation/passkit/pkpaymentmethodtype) | ```APayPaymentMethodType``` |

### Structures
| PassKit | ApplePayMimic |
| --- | --- |
| [PKPaymentSummaryItem](https://developer.apple.com/documentation/passkit/pkpaymentsummaryitem) | ```APayPaymentSummaryItem``` |
| [PKShippingMethod](https://developer.apple.com/documentation/passkit/pkshippingmethod) | ```APayShippingMethod``` |
| [PKContact](https://developer.apple.com/documentation/passkit/pkcontact) | ```APayContact``` |
| [PKPaymentToken](https://developer.apple.com/documentation/passkit/pkpaymenttoken) | ```APayPaymentToken``` |
| [PKPaymentMethod](https://developer.apple.com/documentation/passkit/pkpaymentmethod) | ```APayPaymentMethod``` |
| [PKPayment](https://developer.apple.com/documentation/passkit/pkpayment) | ```APayPayment``` |
| [PersonNameComponents](https://developer.apple.com/documentation/foundation/personnamecomponents) | ```APayPersonNameComponents``` |
| [CNPostalAddress](https://developer.apple.com/documentation/contacts/cnpostaladdress) | ```APayPostalAddress``` |

### Actions
| PassKit | ApplePayMimic |
| --- | --- |
| [PKPaymentRequest.availableNetworks](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1833288-availablenetworks) | ```ApplePayMimic.availableNetworks``` |
| [PKPaymentAuthorizationController.canMakePayments](https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontroller/1649461-canmakepayments) | ```ApplePayMimic.canMakePayments``` |
| [PKPaymentAuthorizationController.present](https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontroller/1649463-present) | ```ApplePayMimic.processPayment```|

### Widgets
| PassKit | ApplePayMimic |
| --- | --- |
| [PKPaymentButton](https://developer.apple.com/documentation/passkit/pkpaymentbutton) | ```ApplePayButton``` |

### Usage

#### Drawing a native PKPaymentButton
```dart
Container(
  height: 44, // ApplePayButton required a bounded constraints
  child: ApplePayButton(
    onPressed: _processPayment,
    style: APayPaymentButtonStyle.white,
    type: APayPaymentButtonType.checkout,
  ),
),

```

#### Getting a basic payment information
```dart
final List<APayPaymentNetwork> availableNetworks = await ApplePayMimic.availableNetworks();
final bool canMakePayments = await ApplePayMimic.canMakePayments();

/// A mimic to canMakePayments with params 
/// @see https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontroller/1649455-canmakepayments
final merchantCapabilities = [APayMerchantCapability.capability3DS];
final canMakePaymentsCard = await ApplePayMimic.canMakePayments(CanMakePaymentsRequest(
  usingNetworks: availableNetworks, // optional
  capabilities: merchantCapabilities, // optional
));
```

#### Making a payment request
```dart
/// @see https://developer.apple.com/documentation/passkit/pkpaymentrequest
final request = ProcessPaymentRequest(
  // required arguments
  merchantIdentifier: 'merchant.id',
  countryCode: 'US',
  currencyCode: 'USD',
  shippingType: APayShippingType.shipping, // PKShippingType type
  merchantCapabilities: [APayMerchantCapability.capability3DS],
  paymentSummaryItems: items, // list of APayPaymentSummaryItem (PKPaymentSummaryItem)
  supportedNetworks: availableNetworks,
);
/// Lets define a callbacks. Callbacks mimic to PKPaymentAuthorizationControllerDelegate callback methods
/// @see https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontrollerdelegate

/// @see https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontrollerdelegate/2867956-paymentauthorizationcontroller
final onSelectShippingContact = FutureOr<APayRequestShippingContactUpdate>(SelectShippingContactRequest request, ShippingContactUpdateBuilder builder) async {
  if(request.shippingContact.postalAddress == null) {
    return builder.failure([APayPaymentError.shippingAddressInvalid()]); /// Yes, you can for specify PK errors
  }
  
  return builder.success();
}

/// @see https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontrollerdelegate/2867955-paymentauthorizationcontroller
final onSelectPaymentMethod = FutureOr<APayRequestPaymentMethodUpdate> Function(SelectPaymentMethodRequest request, PaymentMethodUpdateBuilder builder) async {
  return builder.success();
}

/// @see https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontrollerdelegate/2867953-paymentauthorizationcontroller
final onSelectShippingMethod = FutureOr<APayRequestShippingMethodUpdate> Function(SelectShippingMethodRequest request, ShippingMethodUpdateBuilder builder) {
  final newItemsResponse = await api.newItemsBasedOnShippingMethod(request.shippingMethod);
  final List<APayPaymentSummaryItems> newItems = yourTransformFunction(newItemsResponse);
  
  return builder.success(paymentSummaryItems: items);
}

/// @see https://developer.apple.com/documentation/passkit/pkpaymentauthorizationcontrollerdelegate/2867952-paymentauthorizationcontroller
final onAuthorize = FutureOr<APayPaymentAuthorizationResult> Function(AuthorizePaymentRequest request, AuthorizationResultBuilder builder) {
  /// process authorize request here
  return builder.success();
}

await ApplePayMimic.processPayment(
  request: request,
  onSelectShippingContact: onSelectShippingContact,
  onSelectPaymentMethod: onSelectPaymentMethod,
  onSelectShippingMethod: onSelectShippingMethod,
  onAuthorize: onAuthorize,
  onError: (error) {
    /// Probably an internal error. Package in early dev
  },
  onDismissed: () {
    /// Called after Apple Pay widget dismissed after user authorize a payment, when error for example 
  }
)
```

