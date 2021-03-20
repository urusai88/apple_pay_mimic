import 'entities.dart';

class AuthorizationResultBuilder {
  APayPaymentAuthorizationResult success() {
    return APayPaymentAuthorizationResult(status: APayPaymentAuthStatus.success);
  }

  APayPaymentAuthorizationResult failure({List<APayPaymentError>? errors}) {
    return APayPaymentAuthorizationResult(status: APayPaymentAuthStatus.failure, errors: errors);
  }
}

class ShippingMethodUpdateBuilder {
  APayRequestShippingMethodUpdate success({required List<APayPaymentSummaryItem> paymentSummaryItems}) {
    return APayRequestShippingMethodUpdate(
      status: APayPaymentAuthStatus.success,
      paymentSummaryItems: paymentSummaryItems,
    );
  }

  APayRequestShippingMethodUpdate failure({required List<APayPaymentSummaryItem> paymentSummaryItems}) {
    return APayRequestShippingMethodUpdate(
      status: APayPaymentAuthStatus.failure,
      paymentSummaryItems: paymentSummaryItems,
    );
  }
}

class ShippingContactUpdateBuilder {
  APayRequestShippingContactUpdate success({
    required List<APayPaymentSummaryItem> paymentSummaryItems,
    required List<APayShippingMethod> shippingMethods,
  }) {
    return APayRequestShippingContactUpdate(
      status: APayPaymentAuthStatus.success,
      paymentSummaryItems: paymentSummaryItems,
      shippingMethods: shippingMethods,
    );
  }

  APayRequestShippingContactUpdate failure({
    required List<APayPaymentSummaryItem> paymentSummaryItems,
    required List<APayShippingMethod> shippingMethods,
    List<APayPaymentError>? errors,
  }) {
    return APayRequestShippingContactUpdate(
      status: APayPaymentAuthStatus.failure,
      paymentSummaryItems: paymentSummaryItems,
      shippingMethods: shippingMethods,
      errors: errors,
    );
  }
}

class PaymentMethodUpdateBuilder {
  APayRequestPaymentMethodUpdate success({required List<APayPaymentSummaryItem> paymentSummaryItems}) {
    return APayRequestPaymentMethodUpdate(
      status: APayPaymentAuthStatus.success,
      paymentSummaryItems: paymentSummaryItems,
    );
  }

  APayRequestPaymentMethodUpdate failure({
    required List<APayPaymentSummaryItem> paymentSummaryItems,
    List<APayPaymentError>? errors,
  }) {
    return APayRequestPaymentMethodUpdate(
      status: APayPaymentAuthStatus.failure,
      paymentSummaryItems: paymentSummaryItems,
      errors: errors,
    );
  }
}
