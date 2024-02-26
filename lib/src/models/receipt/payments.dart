part of tinkoff_sdk_models;

/// Класс данных, представляющий различные формы платежей
class Payments {
  static const _cash = 'cash';
  static const _electronic = 'electronic';
  static const _advancePayment = 'advancePayment';
  static const _credit = 'credit';
  static const _provision = 'provision';

  /// Вид оплаты "Наличные". Сумма к оплате в копейках
  final int? cash;

  /// Вид оплаты "Безналичный"
  final int electronic;

  /// Вид оплаты "Предварительная оплата (Аванс)"
  final int? advancePayment;

  /// Вид оплаты "Постоплата (Кредит)"
  final int? credit;

  /// Вид оплаты "Иная форма оплаты"
  final int? provision;

  Payments({
    this.cash,
    required this.electronic,
    this.advancePayment,
    this.credit,
    this.provision,
  });

  Map<String, dynamic> get _arguments => {
        _cash: cash,
        _electronic: electronic,
        _advancePayment: advancePayment,
        _credit: credit,
        _provision: provision,
      };
}
