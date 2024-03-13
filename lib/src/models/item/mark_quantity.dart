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

/// Дробное количество маркированного товара
class MarkQuantity {
  static const _numerator = 'numerator';
  static const _denominator = 'denominator';

  /// Числитель дробной части предмета расчета.
  /// Значение реквизита «числитель» должно быть строго меньше значения реквизита «знаменатель».
  /// Не может равняться «0»
  final int? numerator;

  /// Знаменатель дробной части предмета расчета.
  /// Заполняется значением, равным количеству товара в партии (упаковке), имеющей общий код маркировки товара.
  /// Не может равняться «0»
  final int? denominator;

  MarkQuantity({
    this.numerator,
    this.denominator,
  });

  Map<String, dynamic> get _arguments => {
        _numerator: numerator,
        _denominator: denominator,
      }..removeWhere((key, value) => value == null);
}
