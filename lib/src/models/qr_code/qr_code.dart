/*

  Copyright © 2024 ProgressiveMobile

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

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
