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

/// Данные заказа
class OrderOptions {
  static const _orderId = 'orderId';
  static const _amount = 'amount';
  static const _recurrentPayment = 'recurrentPayment';
  static const _title = 'title';
  static const _description = 'description';
  static const _receipt = 'receipt';
  static const _shops = 'shops';
  static const _receipts = 'receipts';
  static const _successURL = 'successURL';
  static const _failURL = 'failURL';
  static const _clientInfo = 'clientInfo';
  static const _items = 'items';
  static const _additionalData = 'additionalData';
  static const _payType = 'payType';

  /// Номер заказа в системе продавца.
  /// Максимальная длина - 20 символов
  final String orderId;

  /// Полная сумма заказа в копейках
  final int amount;

  /// Указывает, что совершается рекуррентный родительский или не рекуррентный платеж.
  /// По умолчанию - false
  final bool recurrentPayment;

  /// Наименование заказа
  final String? title;

  /// Описание заказа, максимальная длина - 250 символов
  final String? description;

  /// Объект с данными чека
  final Receipt? receipt;

  /// Список с данными магазинов
  final List<Shop>? shops;

  /// Список с данными чеков
  final List<Receipt>? receipts;

  /// Страница успеха
  final String? successURL;

  /// Страница ошибки
  final String? failURL;

  /// Информация о клиенте
  final ClientInfo? clientInfo;

  /// Информация о товаре
  final List<Item>? items;

  /// Объект содержащий дополнительные параметры в виде "ключ":"значение".
  /// Данные параметры будут переданы в запросе платежа/привязки карты.
  /// Максимальная длина для каждого передаваемого параметра: Ключ – 20 знаков, Значение – 100 знаков.
  /// Максимальное количество пар "ключ-значение" не может превышать 20
  final Map<String, String>? additionalData;

  /// Тип проведения платежа - двухстадийная или одностадийная оплата (только iOS)
  final PayType? payType;

  OrderOptions({
    required this.orderId,
    required this.amount,
    this.recurrentPayment = false,
    this.title,
    this.description,
    this.receipt,
    this.shops,
    this.receipts,
    this.successURL,
    this.failURL,
    this.clientInfo,
    this.items,
    this.additionalData,
    this.payType,
  });

  Map<String, dynamic> get arguments => {
        _orderId: orderId,
        _amount: amount,
        _recurrentPayment: recurrentPayment,
        _title: title,
        _description: description,
        _receipt: receipt?.arguments,
        _shops: shops?.map((e) => e._arguments).toList(),
        _receipts: receipts?.map((e) => e.arguments).toList(),
        _successURL: successURL,
        _failURL: failURL,
        _clientInfo: clientInfo?._arguments,
        _items: items?.map((e) => e.arguments).toList(),
        _additionalData: additionalData,
        _payType: payType?.name,
        
      }..removeWhere((key, value) => value == null);
}

enum PayType {
  oneStage(name: 'oneStage'),
  twoStage(name: 'twoStage');

  final String name;
  const PayType({required this.name});
}
