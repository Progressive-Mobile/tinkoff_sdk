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

/// Тип проведения оплаты
enum PaymentFlow {
  /// Оплата совершится с помощью вызова `v2/Init` в API эквайринга,
  /// на основе которого будет сформирован `paymentId`
  full(name: 'full'),

  /// Используется в ситуациях, когда вызов `v2/Init` и формирование `paymentId`
  /// происходит на бекенде продавца
  finish(name: 'finish');

  final String name;
  const PaymentFlow({required this.name});
}
