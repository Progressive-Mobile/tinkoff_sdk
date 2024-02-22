part of tinkoff_sdk_models;

class MarkQuantity {
  static const _numerator = 'numerator';
  static const _denominator = 'denominator';

  final int? numerator;
  final int? denominator;

  MarkQuantity({
    this.numerator,
    this.denominator,
  });

  Map<String, dynamic> get arguments => {
        _numerator: numerator,
        _denominator: denominator,
      };
}
