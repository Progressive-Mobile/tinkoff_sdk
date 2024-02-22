part of tinkoff_sdk_models;

enum PaymentMethod {
  fullPrepayment(name: 'fullPrepayment'),
  prepayment(name: 'prepayment'),
  advance(name: 'advance'),
  fullPayment(name: 'fullPayment'),
  partialPayment(name: 'partialPayment'),
  credit(name: 'credit'),
  creditPayment(name: 'creditPayment');

  final String name;

  const PaymentMethod({required this.name});
}
