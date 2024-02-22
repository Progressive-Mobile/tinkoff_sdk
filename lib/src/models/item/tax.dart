part of tinkoff_sdk_models;

/// Cтавка НДС
enum Tax {
  /// Без НДС
  none(name: 'none'),

  /// НДС по ставке 0%
  vat0(name: 'vat0'),

  /// НДС чека по ставке 10%
  vat10(name: 'vat10'),

  /// НДС чека по ставке 18%
  vat18(name: 'vat18'),

  /// НДС чека по расчетной ставке 10/110
  vat110(name: 'vat110'),

  /// НДС чека по расчетной ставке 18/118
  vat118(name: 'vat118'),

  /// НДС чека по ставке 20%
  vat20(name: 'vat20'),

  /// НДС чека по расчетной ставке 20/120
  vat120(name: 'vat120');

  final String name;

  const Tax({required this.name});
}