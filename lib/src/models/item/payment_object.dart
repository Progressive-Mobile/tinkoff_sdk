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

/// Признак предмета расчета (Android)
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

/// Признак предмета расчета (Android)
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

/// Признак предмета расчета (Android)
enum PaymentObjectIos {
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

  const PaymentObjectIos({required this.name});
}
