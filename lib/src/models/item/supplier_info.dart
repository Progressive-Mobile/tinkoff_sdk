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

/// Данные поставщика платежного агента
class SupplierInfo {
  static const _phones = 'phones';
  static const _name = 'name';
  static const _inn = 'inn';

  /// Телефоны поставщика. Массив строк длиной от 1 до 19 символов.
  final List<String>? phones;

  /// Наименование поставщика. Строка до 239 символов.
  ///
  /// Внимание: в данные 243 символа включаются телефоны поставщика + 4 символа на каждый телефон.
  /// Например, если передано 2 телефона поставщика длиной 12 и 14 символов, то максимальная длина наименования поставщика будет 239 – (12 + 4) – (14 + 4)  = 205 символов
  final String? name;

  /// ИНН поставщика. Строка длиной от 10 до 12 символов.
  final String? inn;

  SupplierInfo({
    this.phones,
    this.name,
    this.inn,
  });

  Map<String, dynamic> get _arguments => {
        _phones: phones,
        _name: name,
        _inn: inn,
      }..removeWhere((key, value) => value == null);
}
