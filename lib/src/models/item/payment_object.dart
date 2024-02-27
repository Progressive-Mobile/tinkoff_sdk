part of tinkoff_sdk_models;

/// Признак предмета расчета
enum PaymentObject105 {
  /// Подакцизный товар
  excise(name: 'excise'),

  /// Работа
  job(name: 'job'),

  /// Услуга
  service(name: 'service'),

  /// Ставка азартной игры
  gamblingBet(name: 'gamblingBet'),

  /// Выигрыш азартной игры
  gamblingPrize(name: 'gamblingPrize'),

  /// Лотерейный билет
  lottery(name: 'lottery'),

  /// Выигрыш лотереи
  lotteryPrize(name: 'lotteryPrize'),

  /// Предоставление результатов интеллектуальной деятельности
  intellectualActivity(name: 'intellectualActivity'),

  /// Платеж
  payment(name: 'payment'),

  /// Агентское вознаграждение
  agentCommission(name: 'agentCommission'),

  /// Составной предмет расчета
  composite(name: 'composite'),

  /// Иной предмет расчета
  another(name: 'another');

  final String name;

  const PaymentObject105({required this.name});
}

/// Признак предмета расчета
enum PaymentObject12 {
  /// Подакцизный товар
  excise(name: 'excise'),

  /// Работа
  job(name: 'job'),

  /// Услуга
  service(name: 'service'),

  /// Ставка азартной игры
  gamblingBet(name: 'gamblingBet'),

  /// Выигрыш азартной игры
  gamblingPrize(name: 'gamblingPrize'),

  /// Лотерейный билет
  lottery(name: 'lottery'),

  /// Выигрыш лотереи
  lotteryPrize(name: 'lotteryPrize'),

  /// Предоставление результатов интеллектуальной деятельности
  intellectualActivity(name: 'intellectualActivity'),

  /// Платеж
  payment(name: 'payment'),

  /// Агентское вознаграждение
  agentCommission(name: 'agentCommission'),

  /// Составной предмет расчета
  composite(name: 'composite'),

  /// Иной предмет расчета
  another(name: 'another'),

  /// Товар
  commodity(name: 'commodity'),

  /// Выплата
  contribution(name: 'contribution'),

  /// Имущественное право
  propertyRights(name: 'propertyRights'),

  /// Внереализационный доход
  unrealization(name: 'unrealization'),

  /// Иные платежи и взносы
  taxReduction(name: 'taxReduction'),

  /// Торговый сбор
  tradeFee(name: 'tradeFee'),

  /// Курортный сбор
  resortTax(name: 'resortTax'),

  /// Залог
  pledge(name: 'pledge'),

  /// Расход
  incomeDecrease(name: 'incomeDecrease'),

  /// Взносы на ОПС ИП без платежей
  iePensionInsuranceWithoutPayments(name: 'iePensionInsuranceWithoutPayments'),

  /// Взносы на ОПС с платежами
  iePensionInsuranceWithPayments(name: 'iePensionInsuranceWithPayments'),

  /// Взносы на ОМС ИП без платежей
  ieMedicalInsuranceWithoutPayments(name: 'ieMedicalInsuranceWithoutPayments'),

  /// Взносы на ОМС с платежами
  ieMedicalInsuranceWithPayments(name: 'ieMedicalInsuranceWithPayments'),

  /// Взносы на ОСС
  socialInsurance(name: 'socialInsurance'),

  /// Платеж казино
  casinoChips(name: 'casinoChips'),

  /// Выдача ДС
  agentPayment(name: 'agentPayment'),

  /// АТНМ
  excisableGoodsWithoutMarkingCode(name: 'excisableGoodsWithoutMarkingCode'),

  /// АТМ
  excisableGoodsWithMarkingCode(name: 'excisableGoodsWithMarkingCode'),

  /// ТНМ
  goodsWithoutMarkingCode(name: 'goodsWithoutMarkingCode'),

  /// ТМ
  goodsWithMarkingCode(name: 'goodsWithMarkingCode');

  final String name;

  const PaymentObject12({required this.name});
}
