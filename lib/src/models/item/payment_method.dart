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

/// Тип оплаты
enum PaymentMethod {
  /// Предоплата 100%. Полная предварительная оплата до момента передачи предмета расчета
  fullPrepayment(name: 'fullPrepayment'),

  /// Предоплата. Частичная предварительная оплата до момента передачи предмета расчета
  prepayment(name: 'prepayment'),

  /// Аванс
  advance(name: 'advance'),

  /// Полный расчет. Полная оплата, в том числе с учетом аванса (предварительной оплаты) в момент передачи
  fullPayment(name: 'fullPayment'),

  /// Частичный расчет и кредит. Частичная оплата предмета расчета в момент его передачи с последующей оплатой в кредит
  partialPayment(name: 'partialPayment'),

  /// Передача в кредит. Передача предмета расчета без его оплаты в момент его передачи с последующей оплатой в кредит
  credit(name: 'credit'),

  /// Оплата кредита. Оплата предмета расчета после его передачи с оплатой в кредит
  creditPayment(name: 'creditPayment');

  final String name;

  const PaymentMethod({required this.name});
}
