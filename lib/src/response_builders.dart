import 'entities.dart';

typedef SelectShippingMethodBuilder = APayRequestShippingMethodUpdate Function({
  required APayPaymentAuthStatus status,
  required List<APayPaymentSummaryItem> paymentSummaryItems,
});
