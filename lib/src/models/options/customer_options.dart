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

/// Данные покупателя
class CustomerOptions {
  static const _customerKey = 'customerKey';
  static const _checkType = 'checkType';
  static const _email = 'email';
  static const _data = 'data';

  /// Идентификатор покупателя в системе продавца. Максимальная длина - 36 символов
  final String customerKey;

  /// Email, на который будет отправлена квитанция об оплате
  final String? email;

  /// Тип привязки карты
  final CheckType checkType;

  /// Объект содержащий дополнительные параметры в виде "ключ":"значение".
  /// Данные параметры будут переданы в запросе платежа/привязки карты.
  /// Максимальная длина для каждого передаваемого параметра:
  /// Ключ – 20 знаков, Значение – 100 знаков.
  /// Максимальное количество пар "ключ-значение" не может превышать 20
  final Map<String, String>? data;

  const CustomerOptions({
    required this.customerKey,
    this.checkType = CheckType.hold,
    this.email,
    this.data,
  });

  Map<String, dynamic> get arguments => {
        _customerKey: customerKey,
        _checkType: checkType.name,
        _email: email,
        _data: data,
      }..removeWhere((key, value) => value == null);
}

/// Тип проверки при привязке карты
enum CheckType {
  /// Привязка без проверки
  no(name: 'NO'),

  /// Привязка с блокировкой в 1 руб. Используется по умолчанию
  hold(name: 'HOLD'),

  /// Привязка с 3DS
  threeDS(name: '3DS'),

  /// Привязка с 3DS и блокировкой маленькой суммы до 2 руб
  threeDS_hold(name: '3DSHOLD');

  final String name;
  const CheckType({required this.name});
}
