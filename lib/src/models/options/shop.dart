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
