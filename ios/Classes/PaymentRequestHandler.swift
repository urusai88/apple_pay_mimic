import Flutter
import UIKit
import PassKit

class PaymentRequestHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    public init(_ channel: FlutterMethodChannel, _ paymentId: Int) {
        self.channel = channel
        self.paymentId = paymentId
    }

    var channel: FlutterMethodChannel
    var paymentId: Int
    var controller: PKPaymentAuthorizationController?

    public func process(_ value: ProcessPaymentRequest) {
        guard let shippingType = value.shippingType.toPK() else {
            return channel.invokeMethod("error", arguments: [
                "id": paymentId,
                "error": "Некоррекнтый shippingType " + value.shippingType.value
            ])
        }

        let supportedNetworks: [PKPaymentNetwork] =
                value.supportedNetworks.map({ $0.toPK() }).onlyType()
        let merchantCapabilities: [PKMerchantCapability] =
                value.merchantCapabilities.map({ $0.toPK() }).onlyType()

        let request = PKPaymentRequest()

        request.shippingType = shippingType
        request.countryCode = value.countryCode
        request.currencyCode = value.currencyCode
        request.merchantIdentifier = value.merchantIdentifier
        request.supportedNetworks = supportedNetworks
        request.paymentSummaryItems = value.paymentSummaryItems.map({ $0.toPK() }).onlyType()
        request.applicationData = value.applicationData?.data(using: .utf8)

        if value.requiredBillingContactFields != nil {
            let list: [PKContactField] =
                    value.requiredBillingContactFields!.map({ $0.toPK() }).onlyType()
            request.requiredBillingContactFields = Set(list)
        }

        if value.requiredShippingContactFields != nil {
            let list: [PKContactField] =
                    value.requiredShippingContactFields!.map({ $0.toPK() }).onlyType()
            request.requiredShippingContactFields = Set(list)
        }

        if value.billingContact != nil {
            request.billingContact = value.billingContact?.toPK()
        }

        if value.shippingContact != nil {
            request.shippingContact = value.shippingContact?.toPK()
        }

        if value.shippingMethods != nil {
            request.shippingMethods = value.shippingMethods!.map({ $0.toPK() }).onlyType()
        }

        if value.supportedCountries != nil {
            request.supportedCountries = Set(value.supportedCountries!)
        }

        for merchantCapability in merchantCapabilities {
            request.merchantCapabilities.insert(merchantCapability)
        }

        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller!.delegate = self
        controller!.present { result in
            if !result {
                self.channel.invokeMethod("error", arguments: ["id": self.paymentId])
            }
        }
    }

    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let request = AuthorizePaymentRequest(
                id: paymentId,
                payment: APayPayment.fromPK(payment)
        )

        channel.invokeMethod("didAuthorizePayment", arguments: encodeJson(request)) { any in
            guard let string = any as? String,
                  let result: APayPaymentAuthorizationResult = decodeJson(string) else {
                self.channel.invokeMethod("error", arguments: [
                    "id": self.paymentId,
                    "step": "didAuthorizePayment",
                ])
                let result = PKPaymentAuthorizationResult()
                result.status = PKPaymentAuthorizationStatus.failure
                return completion(result)
            }

            completion(result.toPK())
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingMethod shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        let request = SelectShippingMethodRequest(
                id: paymentId,
                shippingMethod: APayShippingMethod.fromPK(shippingMethod)
        )

        channel.invokeMethod("didSelectShippingMethod", arguments: encodeJson(request)) { any in
            guard let string = any as? String,
                  let result: APayRequestShippingMethodUpdate = decodeJson(string) else {
                self.channel.invokeMethod("error", arguments: [
                    "id": self.paymentId,
                    "step": "didSelectShippingMethod",
                ])
                let result = PKPaymentRequestShippingMethodUpdate()
                result.status = PKPaymentAuthorizationStatus.failure
                return completion(result)
            }

            completion(result.toPK())
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {
        let request = SelectShippingContactRequest(
                id: paymentId,
                shippingContact: APayContact.fromPK(contact)
        )

        channel.invokeMethod("didSelectShippingContact", arguments: encodeJson(request)) { any in
            guard let string = any as? String,
                  let result: APayRequestShippingContactUpdate = decodeJson(string) else {
                self.channel.invokeMethod("error", arguments: [
                    "id": self.paymentId,
                    "step": "didSelectShippingContact",
                ])
                let result = PKPaymentRequestShippingContactUpdate()
                result.status = PKPaymentAuthorizationStatus.failure
                return completion(result)
            }

            completion(result.toPK())
        }
    }

    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        let request = SelectPaymentMethodRequest(
                id: paymentId,
                paymentMethod: APayPaymentMethod.fromPK(paymentMethod)
        )

        channel.invokeMethod("didSelectPaymentMethod", arguments: encodeJson(request)) { any in
            guard let string = any as? String,
                  let result: APayRequestPaymentMethodUpdate = decodeJson(string) else {
                self.channel.invokeMethod("error", arguments: [
                    "id": self.paymentId,
                    "step": "didSelectPaymentMethod",
                ])
                let result = PKPaymentRequestPaymentMethodUpdate()
                result.status = PKPaymentAuthorizationStatus.failure
                return completion(result)
            }

            completion(result.toPK())
        }
    }
}