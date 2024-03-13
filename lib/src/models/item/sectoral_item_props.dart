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

/// Реквизит предусмотренный НПА
class SectoralItemProps {
  static const _federalId = 'federalId';
  static const _date = 'date';
  static const _number = 'number';
  static const _value = 'value';

  /// Идентификатор ФОИВ (федеральный орган исполнительной власти)
  final String federalId;

  /// Дата нормативного акта ФОИВ Значение в формате в формате ДД.ММ.ГГГГ
  final String date;

  /// Номер нормативного акта ФОИВ, регламентирующего порядок заполнения реквизита «значение отраслевого реквизита»
  final String number;

  /// Состав значений, определенных нормативного актом ФОИВ
  final String value;

  SectoralItemProps({
    required this.federalId,
    required this.date,
    required this.number,
    required this.value,
  });

  Map<String, dynamic> get _arguments => {
        _federalId: federalId,
        _date: date,
        _number: number,
        _value: value,
      }..removeWhere((key, value) => value == null);
}
