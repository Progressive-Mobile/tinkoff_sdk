part of tinkoff_sdk_models;

/// Дробное количество маркированного товара
class MarkQuantity {
  static const _numerator = 'numerator';
  static const _denominator = 'denominator';

  /// Числитель дробной части предмета расчета.
  /// Значение реквизита «числитель» должно быть строго меньше значения реквизита «знаменатель».
  /// Не может равняться «0»
  final int? numerator;

  /// Знаменатель дробной части предмета расчета.
  /// Заполняется значением, равным количеству товара в партии (упаковке), имеющей общий код маркировки товара.
  /// Не может равняться «0»
  final int? denominator;

  MarkQuantity({
    this.numerator,
    this.denominator,
  });

  Map<String, dynamic> get _arguments => {
        _numerator: numerator,
        _denominator: denominator,
      }..removeWhere((key, value) => value == null);
}
