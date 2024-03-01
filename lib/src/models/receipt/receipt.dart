part of tinkoff_sdk_models;

/// Данные чека
abstract class Receipt {
  Map<String, dynamic> get arguments;
}

/// Android-реализация объекта чека
abstract class AndroidReceipt implements Receipt {
  Map<String, dynamic> get arguments;
}

class AndroidReceiptFfd105 implements AndroidReceipt {
  static const _email = 'email';
  static const _phone = 'phone';
  static const _taxation = 'taxation';
  static const _items = 'items';

  /// Электронный адрес для отправки чека покупателю. Параметр email или phone должен быть заполнен
  final String? email;

  /// Телефон покупателя. Параметр email или phone должен быть заполнен
  final String? phone;

  /// Система налогообложения
  final Taxation taxation;

  /// Массив, содержащий в себе информацию о товарах
  final List<AndroidItem105> items;

  AndroidReceiptFfd105({
    this.email,
    this.phone,
    required this.taxation,
    required this.items,
  });

  @override
  Map<String, dynamic> get arguments => {
        _email: email,
        _phone: phone,
        _taxation: taxation.name,
        _items: items.map((e) => e.arguments).toList(),
      }..removeWhere((key, value) => value == null);
}

class AndroidReceiptFfd12 implements AndroidReceipt {
  static const _clientInfo = 'clientInfo';
  static const _taxation = 'taxation';
  static const _email = 'email';
  static const _phone = 'phone';
  static const _items = 'items';

  /// Информация о клиенте
  final ClientInfo clientInfo;

  /// Система налогообложения
  final Taxation taxation;

  /// Электронный адрес для отправки чека покупателю. Параметр email или phone должен быть заполнен
  final String? email;

  /// Телефон покупателя. Параметр email или phone должен быть заполнен
  final String? phone;

  /// Массив, содержащий в себе информацию о товарах
  final List<AndroidItem12> items;

  AndroidReceiptFfd12({
    required this.clientInfo,
    required this.taxation,
    this.email,
    this.phone,
    required this.items,
  });

  @override
  Map<String, dynamic> get arguments => {
        _clientInfo: clientInfo._arguments,
        _taxation: taxation.name,
        _email: email,
        _phone: phone,
        _items: items.map((e) => e.arguments).toList(),
      }..removeWhere((key, value) => value == null);
}

/// iOS-реализация объекта чека
class IosReceipt implements Receipt {
  static const _shopCode = 'shopCode';
  static const _email = 'email';
  static const _phone = 'phone';
  static const _taxation = 'taxation';
  static const _items = 'items';
  static const _agentData = 'agentData';
  static const _supplierInfo = 'supplierInfo';
  static const _customer = 'customer';
  static const _customerInn = 'customerInn';

  /// Код магазина
  final String? shopCode;

  /// Электронный адрес для отправки чека покупателю.
  /// Параметр `email` или `phone` должен быть заполнен
  final String? email;

  /// Телефон покупателя.
  /// Параметр `email` или `phone` должен быть заполнен
  final String? phone;

  /// Система налогообложения
  final Taxation? taxation;

  /// Массив, содержащий в себе информацию о товарах
  final List<IosItem>? items;

  /// Данные агента
  final AgentData? agentData;

  /// Данные поставщика платежного агента
  final SupplierInfo? supplierInfo;

  /// Идентификатор покупателя
  final String? customer;

  /// Инн покупателя. Если ИНН иностранного гражданина, необходимо указать 00000000000
  final String? customerInn;

  IosReceipt({
    this.shopCode,
    this.email,
    this.phone,
    this.taxation,
    this.items,
    this.agentData,
    this.supplierInfo,
    this.customer,
    this.customerInn,
  });

  @override
  Map<String, dynamic> get arguments => {
        _shopCode: shopCode,
        _email: email,
        _phone: phone,
        _taxation: taxation?.name,
        _items: items?.map((e) => e.arguments).toList(),
        _agentData: agentData?._arguments,
        _supplierInfo: supplierInfo?._arguments,
        _customer: customer,
        _customerInn: customerInn,
      }..removeWhere((key, value) => value == null);
}
