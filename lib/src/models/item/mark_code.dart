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

/// Данные маркировки
class MarkCode {
  static const _markCodeType = 'markCodeType';
  static const _value = 'value';

  /// Тип кода маркировки
  final MarkCodeType markCodeType;

  /// Фактическое значение маркировочного кода
  final String value;

  MarkCode({
    required this.markCodeType,
    required this.value,
  });

  Map<String, dynamic> get _arguments => {
        _markCodeType: markCodeType.name,
        _value: value,
      }..removeWhere((key, value) => value == null);
}

/// Код товара, формат которого не идентифицирован, как один из реквизитов
enum MarkCodeType {
  /// Код товара, формат которого не идентифицирован, как один из реквизитов
  unknown(name: 'unknown'),

  /// Код товара в формате EAN-8
  ean8(name: 'ean8'),

  /// Код товара в формате EAN-13
  ean13(name: 'ean13'),

  /// Код товара в формате ITF-14
  itf14(name: 'itf14'),

  /// Код товара в формате GS1, нанесенный на товар, не подлежащий маркировке средствами идентификации
  gs10(name: 'gs10'),

  /// Код товара в формате GS1, нанесенный на товар, подлежащий маркировке средствами идентификации
  gs1M(name: 'gs1m'),

  /// Код товара в формате короткого кода маркировки, нанесенный на товар, подлежащий маркировке средствами идентификации
  short(name: 'short'),

  /// Контрольно-идентификационный знак мехового изделия
  fur(name: 'fur'),

  /// Код товара в формате ЕГАИС-2.0
  egais20(name: 'egais20'),

  /// Код товара в формате ЕГАИС-3.0
  egais30(name: 'egais30');

  final String name;

  const MarkCodeType({required this.name});
}
