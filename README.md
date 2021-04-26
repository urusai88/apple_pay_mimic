# Apple Pay Mimic

Apple Pay Mimic contains flexible mimics to PassKit

## Getting Started

### Requires iOS 10

* Add apple_pay_mimic dependency to your pubspec.yaml
* Call ```await ApplePayMimic.init()``` for plugin initialization
* You are ready

## Table of Mimics
### Enums
| PassKit | ApplePayMimic |
| --- | --- |
| [PKPaymentNetwork](https://developer.apple.com/documentation/passkit/pkpaymentnetwork) | ```PKPaymentNetwork``` |
| [PKMerchantCapability](https://developer.apple.com/documentation/passkit/pkmerchantcapability) | ```PKMerchantCapability``` |
| [PKShippingType](https://developer.apple.com/documentation/passkit/pkshippingtype) | ```PKShippingType``` |
| [PKContactField](https://developer.apple.com/documentation/passkit/pkcontactfield) | ```PKContactField``` |
| [PKPaymentSummaryItemType](https://developer.apple.com/documentation/passkit/pkpaymentsummaryitemtype) | ```PKPaymentSummaryItemType``` |
| [PKPaymentMethodType](https://developer.apple.com/documentation/passkit/pkpaymentmethodtype) | ```PKPaymentMethodType``` |

### Structures
| PassKit | ApplePayMimic |
| --- | --- |
| [PKPaymentSummaryItem](https://developer.apple.com/documentation/passkit/pkpaymentsummaryitem) | ```PKPaymentSummaryItem``` |
| [PKShippingMethod](https://developer.apple.com/documentation/passkit/pkshippingmethod) | ```PKShippingMethod``` |
| [PKContact](https://developer.apple.com/documentation/passkit/pkcontact) | ```PKContact``` |
| [PKPaymentToken](https://developer.apple.com/documentation/passkit/pkpaymenttoken) | ```PKPaymentToken``` |
| [PKPaymentMethod](https://developer.apple.com/documentation/passkit/pkpaymentmethod) | ```PKPaymentMethod``` |
| [PKPayment](https://developer.apple.com/documentation/passkit/pkpayment) | ```PKPayment``` |
| [PersonNameComponents](https://developer.apple.com/documentation/foundation/personnamecomponents) | ```PersonNameComponents``` |
| [CNPostalAddress](https://developer.apple.com/documentation/contacts/cnpostaladdress) | ```CNPostalAddress``` |

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

## Usage
Look at the example: https://github.com/urusai88/apple_pay_mimic/tree/master/example
This example fills some conditions: 
* You are book and stationery store. 
* You have two shipping types, a slow for free, and a fast for 5$
* You want to charge payment with two items - a Harry Potter book and a Pencil case
* You can process shipping only in Germany and Russia countries
* You provide to Germany users free bonus item - a Tape
