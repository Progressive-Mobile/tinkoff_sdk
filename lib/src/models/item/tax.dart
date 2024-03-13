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

/// Cтавка НДС
enum Tax {
  /// Без НДС
  none(name: 'none'),

  /// НДС по ставке 0%
  vat0(name: 'vat0'),

  /// НДС чека по ставке 10%
  vat10(name: 'vat10'),

  /// НДС чека по ставке 18%
  vat18(name: 'vat18'),

  /// НДС чека по расчетной ставке 10/110
  vat110(name: 'vat110'),

  /// НДС чека по расчетной ставке 18/118
  vat118(name: 'vat118'),

  /// НДС чека по ставке 20%
  vat20(name: 'vat20'),

  /// НДС чека по расчетной ставке 20/120
  vat120(name: 'vat120');

  final String name;

  const Tax({required this.name});
}