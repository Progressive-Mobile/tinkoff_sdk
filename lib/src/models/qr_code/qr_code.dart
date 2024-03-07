part of tinkoff_sdk_models;

class AndroidDynamicQrCode {
  final OrderOptions orderOptions;
  final CustomerOptions customerOptions;
  final String? paymentId;
  final FeaturesOptions? featuresOptions;
  final String terminalKey;
  final String publicKey;

  AndroidDynamicQrCode({
    required this.orderOptions,
    required this.customerOptions,
    this.paymentId,
    this.featuresOptions,
    required this.terminalKey,
    required this.publicKey,
  });
}

abstract class IosDynamicQrCode {}

class IosDynamicQrCodeFullPaymentFlow implements IosDynamicQrCode {
  final OrderOptions orderOptions;
  final CustomerOptions? customerOptions;
  final String? successUrl;
  final String? failureUrl;
  final Map<String, String>? paymentData;

  IosDynamicQrCodeFullPaymentFlow({
    required this.orderOptions,
    this.customerOptions,
    this.successUrl,
    this.failureUrl,
    this.paymentData,
  });
}

class IosDynamicQrCodeFinishPaymentFlow implements IosDynamicQrCode {
  final String paymentId;
  final int amount;
  final String orderId;
  final CustomerOptions? customerOptions;

  IosDynamicQrCodeFinishPaymentFlow({
    required this.paymentId,
    required this.amount,
    required this.orderId,
    this.customerOptions,
  });
}
