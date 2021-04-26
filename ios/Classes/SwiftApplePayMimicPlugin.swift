import Flutter
import UIKit
import PassKit

@available(iOS 10, *)
public class SwiftApplePayMimicPlugin: NSObject, FlutterPlugin {
    public init(_ channel: FlutterMethodChannel) {
        self.channel = channel
    }

    var channel: FlutterMethodChannel
    var paymentId: Int = 1
    var handlers: Dictionary<Int, PaymentRequestHandler> = [:]

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        let channel = FlutterMethodChannel(name: "apple_pay_mimic", binaryMessenger: messenger)
        let instance = SwiftApplePayMimicPlugin(channel)
        
        let buttonChannel = FlutterMethodChannel(name: "apple_pay_mimic_button", binaryMessenger: messenger)
        let factory = FLNativeViewFactory(messenger: messenger, channel: buttonChannel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(factory, withId: "apple_pay_mimic_button")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        print("[Apple Pay] SWIFT handle:", call.method);
        switch call.method {
        case "availableNetworks":
            availableNetworks(call, result: result)
        case "canMakePayments":
            canMakePayments(call, result: result)
        case "fetchPostalAddressKeys":
            fetchPostalAddressKeys(call, result: result)
        case "processPayment":
            processPayment(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func availableNetworks(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let availableNetworks = PKPaymentRequest.availableNetworks()
        let json: [APayPaymentNetwork] = availableNetworks.map(APayPaymentNetwork.fromPK).onlyType()

        result(encodeJson(json))
    }

    public func canMakePayments(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        if call.arguments == nil {
            return result(PKPaymentAuthorizationController.canMakePayments())
        }
        guard let string = call.arguments as? String, let request: CanMakeRequest = decodeJson(string) else {
            return result(["error": "wrong arguments", "arguments": call.arguments])
        }

        let usingNetworks: [PKPaymentNetwork]? =
                request.usingNetworks?.map({ $0.toPK() }).onlyType()
        let capabilities: [PKMerchantCapability]? =
                request.capabilities?.map({ $0.toPK() }).onlyType()

        if usingNetworks == nil {
            return result(PKPaymentAuthorizationController.canMakePayments())
        }
        if capabilities == nil {
            return result(PKPaymentAuthorizationController.canMakePayments(
                    usingNetworks: usingNetworks!
            ))
        }

        var c: PKMerchantCapability = []
        for i in capabilities! {
            c.insert(i)
        }

        return result(PKPaymentAuthorizationController.canMakePayments(
                usingNetworks: usingNetworks!,
                capabilities: c
        ))
    }


    public func fetchPostalAddressKeys(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        result([
            "street": CNPostalAddressStreetKey,
            "subLocality": CNPostalAddressSubLocalityKey,
            "city": CNPostalAddressCityKey,
            "subAdministrativeArea": CNPostalAddressSubAdministrativeAreaKey,
            "stateKey": CNPostalAddressStateKey,
            "postalCode": CNPostalAddressPostalCodeKey,
            "country": CNPostalAddressCountryKey,
            "isoCountryCode": CNPostalAddressISOCountryCodeKey,
        ])
    }

    public func processPayment(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        guard let string = call.arguments as? String, let request: ProcessPaymentRequest = decodeJson(string) else {
            return result(["error": "wrong arguments", "arguments": call.arguments])
        }

        let id: Int = paymentId;
        paymentId += 1

        handlers[id] = PaymentRequestHandler(channel, id)
        handlers[id]!.process(request)

        result(Int(id))
    }
}
