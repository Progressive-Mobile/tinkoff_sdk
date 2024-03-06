part of tinkoff_sdk_models;

/// Тип проведения оплаты
enum PaymentFlow {
  /// Оплата совершится с помощью вызова `v2/Init` в API эквайринга,
  /// на основе которого будет сформирован `paymentId`
  full(name: 'full'),

  /// Используется в ситуациях, когда вызов `v2/Init` и формирование `paymentId`
  /// происходит на бекенде продавца
  finish(name: 'finish');

  final String name;
  const PaymentFlow({required this.name});
}
