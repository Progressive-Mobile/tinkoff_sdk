part of tinkoff_sdk_models;

enum Taxation {
  osn(name: 'osn'),
  usnIncome(name: 'usnIncome'),
  usnIncomeOutcome(name: 'usnIncomeOutcome'),
  envd(name: 'envd'),
  esn(name: 'esn'),
  patent(name: 'patent');

  final String name;

  const Taxation({required this.name});
}
