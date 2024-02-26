part of tinkoff_sdk_models;

/// Система налогообложения (СН)
enum Taxation {
  /// Общая СН
  osn(name: 'osn'),

  /// Упрощенная СН (доходы)
  usnIncome(name: 'usnIncome'),

  /// Упрощенная СН (доходы минус расходы)
  usnIncomeOutcome(name: 'usnIncomeOutcome'),

  /// Единый налог на вмененный доход
  envd(name: 'envd'),

  /// Единый сельскохозяйственный налог
  esn(name: 'esn'),

  /// Патентная СН
  patent(name: 'patent');

  final String name;

  const Taxation({required this.name});
}
