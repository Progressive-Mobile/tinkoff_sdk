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

/// Информация о покупателе (Обязательно для FfdVersion = 1.2)
class ClientInfo {
  static const _birthdate = 'birthdate';
  static const _citizenship = 'citizenship';
  static const _documentCode = 'documentCode';
  static const _documentData = 'documentData';
  static const _address = 'address';

  /// Дата рождения в формате ДД.ММ.ГГГГ
  final String? birthdate;

  /// Числовой код страны, гражданином которой является покупатель (клиент).
  /// Код страны указывается в соответствии с Общероссийским классификатором стран мира ОКСМ.
  final String? citizenship;

  /// Числовой код вида документа, удостоверяющего личность.
  final String? documentCode;

  /// Реквизиты документа, удостоверяющего личность (например: серия и номер паспорта)
  final String? documentData;

  /// Адрес покупателя (клиента), грузополучателя. Максимум 256 символов
  final String? address;

  ClientInfo({
    this.birthdate,
    this.citizenship,
    this.documentCode,
    this.documentData,
    this.address,
  });

  Map<String, dynamic> get _arguments => {
        _birthdate: birthdate,
        _citizenship: citizenship,
        _documentCode: documentCode,
        _documentData: documentData,
        _address: address,
      }..removeWhere((key, value) => value == null);
}
