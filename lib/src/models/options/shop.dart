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

/// Данные магазина
class Shop {
  static const _shopCode = 'shopCode';
  static const _name = 'name';
  static const _amount = 'amount';
  static const _fee = 'fee';

  /// Код магазина
  final String shopCode;

  /// Наименование позиции
  final String name;

  /// Сумма в копейках, которая относится к указанному в ShopCode партнеру
  final int amount;

  /// Сумма комиссии в копейках, удерживаемая из возмещения партнера в пользу маркетплейса.
  /// Если не передано, используется комиссия, указанная при регистрации
  final String? fee;

  Shop({
    required this.shopCode,
    required this.name,
    this.amount = 0,
    this.fee,
  });

  Map<String, dynamic> get _arguments => {
    _shopCode: shopCode,
    _name: name,
    _amount: amount,
    _fee: fee,
  }..removeWhere((key, value) => value == null);
}
