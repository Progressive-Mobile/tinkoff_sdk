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

/// Данные чека
abstract class Receipt {
  Map<String, dynamic> get arguments;
}

/// Реализация объекта чека с ФФД 1.05
class Receipt105 implements Receipt {
  static const _email = 'email';
  static const _phone = 'phone';
  static const _taxation = 'taxation';
  static const _items = 'items';
  static const _shopCode = 'shopCode';
  static const _agentData = 'agentData';
  static const _supplierInfo = 'supplierInfo';

  /// Электронный адрес для отправки чека покупателю. Параметр email или phone должен быть заполнен
  final String? email;

  /// Телефон покупателя. Параметр email или phone должен быть заполнен
  final String? phone;

  /// Система налогообложения
  final Taxation taxation;

  /// Массив, содержащий в себе информацию о товарах
  final List<Item105> items;

  /// Код магазина
  final String? shopCode;

  /// Данные агента
  final AgentData? agentData;

  /// Данные поставщика платежного агента
  final SupplierInfo? supplierInfo;

  Receipt105({
    this.email,
    this.phone,
    required this.taxation,
    required this.items,
    this.shopCode,
    this.agentData,
    this.supplierInfo,
  }) : assert(email != null || phone != null);

  @override
  Map<String, dynamic> get arguments => {
        _email: email,
        _phone: phone,
        _taxation: taxation.name,
        _items: items.map((e) => e.arguments).toList(),
        _shopCode: shopCode,
        _agentData: agentData?._arguments,
        _supplierInfo: supplierInfo?._arguments,
      }..removeWhere((key, value) => value == null);
}

/// Реализация объекта чека с ФФД 1.2
class Receipt12 implements Receipt {
  static const _email = 'email';
  static const _phone = 'phone';
  static const _taxation = 'taxation';
  static const _items = 'items';
  static const _clientInfo = 'clientInfo';
  static const _customer = 'customer';
  static const _customerInn = 'customerInn';
  static const _payments = 'payments';
  static const _operatingCheckProps = 'operatingCheckProps';
  static const _sectoralCheckProps = 'sectoralCheckProps';
  static const _addUserProp = 'addUserProp';
  static const _additionalCheckProps = 'additionalCheckProps';

  /// Электронный адрес для отправки чека покупателю. Параметр email или phone должен быть заполнен
  final String? email;

  /// Телефон покупателя. Параметр email или phone должен быть заполнен
  final String? phone;

  /// Система налогообложения
  final Taxation taxation;

  /// Массив, содержащий в себе информацию о товарах
  final List<Item12> items;

  /// Информация о клиенте.
  final ClientInfo? clientInfo;

  /// Идентификатор покупателя
  final String? customer;

  /// Инн покупателя. Если ИНН иностранного гражданина, необходимо указать 00000000000
  final String? customerInn;

  /// Детали платежа. Если объект не передан, будет автоматически указана итоговая сумма чека с
  /// видом оплаты "Безналичный". Если передан объект receipt.Payments, то значение в Electronic
  ///  должно быть равно итоговому значению Amount в методе Init. При этом сумма введенных значений
  ///  по всем видам оплат, включая Electronic, должна быть равна сумме (Amount) всех товаров, переданных в
  ///  объекте receipt.Items.
  final Payments? payments;

  /// Операционный реквизит чека (тег 1270)
  final OperatingCheckProps? operatingCheckProps;

  /// Отраслевой реквизит чека (тег 1261)
  final SectoralCheckProps? sectoralCheckProps;

  /// Дополнительный реквизит пользователя (тег 1084)
  final AddUserProp? addUserProp;

  /// Дополнительный реквизит чека (БСО) (тег 1192)
  final String? additionalCheckProps;

  Receipt12({
    this.email,
    this.phone,
    required this.taxation,
    required this.items,
    this.clientInfo,
    this.customer,
    this.customerInn,
    this.payments,
    this.operatingCheckProps,
    this.sectoralCheckProps,
    this.addUserProp,
    this.additionalCheckProps,
  }) : assert(email != null || phone != null);

  @override
  Map<String, dynamic> get arguments => {
        _email: email,
        _phone: phone,
        _taxation: taxation.name,
        _items: items.map((e) => e.arguments).toList(),
        _clientInfo: clientInfo?._arguments,
        _customer: customer,
        _customerInn: customerInn,
        _payments: payments?.arguments,
        _operatingCheckProps: operatingCheckProps?._arguments,
        _sectoralCheckProps: sectoralCheckProps?._arguments,
        _addUserProp: addUserProp?._arguments,
        _additionalCheckProps: additionalCheckProps,
      }..removeWhere((key, value) => value == null);
}

