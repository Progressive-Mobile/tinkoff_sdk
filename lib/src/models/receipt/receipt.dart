part of tinkoff_sdk_models;

/// Данные чека
abstract class Receipt {
  Map<String, dynamic> get arguments;
}

class ReceiptFfd105 implements Receipt {
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
  final List<Item105> items;

  ReceiptFfd105({
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
      };
}

class ReceiptFfd12 implements Receipt {
  static const _clientInfo = 'clientInfo';
  static const _taxation = 'taxation';
  static const _email = 'email';
  static const _phone = 'phone';
  static const _items = 'items';

  /// Информация о клиенте
  final ClientInfo? clientInfo;

  /// Система налогообложения
  final Taxation taxation;

  /// Электронный адрес для отправки чека покупателю. Параметр email или phone должен быть заполнен
  final String? email;

  /// Телефон покупателя. Параметр email или phone должен быть заполнен
  final String? phone;

  /// Массив, содержащий в себе информацию о товарах
  final List<Item12> items;

  ReceiptFfd12({
    this.clientInfo,
    required this.taxation,
    this.email,
    this.phone,
    required this.items,
  });

  @override
  Map<String, dynamic> get arguments => {
        _clientInfo: clientInfo?._arguments,
        _taxation: taxation.name,
        _email: email,
        _phone: phone,
        _items: items.map((e) => e.arguments).toList(),
      };
}
