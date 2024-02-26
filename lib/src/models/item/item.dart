part of tinkoff_sdk_models;

/// Позиция чека с информацией о товаре
abstract class Item {
  Map<String, dynamic> get arguments;
}

class Item105 implements Item {
  static const String _name = 'name';
  static const String _price = 'price';
  static const String _quantity = 'quantity';
  static const String _amount = 'amount';
  static const String _tax = 'tax';
  static const String _ean13 = 'ean13';
  static const String _shopCode = 'shopCode';
  static const String _paymentMethod = 'paymentMethod';
  static const String _paymentObject = 'paymentObject';
  static const String _agentData = 'agentData';
  static const String _supplierInfo = 'supplierInfo';

  /// Наименование товара. Максимальная длина строки – 64 символа
  final String name;

  /// Сумма в копейках. Целочисленное значение не более 10 знаков
  final double price;

  /// Количество/вес - целая часть не более 8 знаков, дробная часть не более 3 знаков
  final double quantity;

  /// Сумма в копейках. Целочисленное значение не более 10 знаков
  final double amount;

  /// Ставка налога
  final Tax tax;

  /// Штрих-код
  final String? ean13;

  /// Код магазина
  final String? shopCode;

  /// Тип оплаты
  final PaymentMethod? paymentMethod;

  /// Признак предмета расчета
  final PaymentObject105? paymentObject;

  /// Данные агента
  final AgentData? agentData;

  /// Данные поставщика платежного агента
  final SupplierInfo? supplierInfo;

  Item105({
    required this.name,
    this.price = 0,
    this.quantity = 0,
    required this.amount,
    required this.tax,
    this.ean13,
    this.shopCode,
    this.paymentMethod,
    this.paymentObject,
    this.agentData,
    this.supplierInfo,
  });

  @override
  Map<String, dynamic> get arguments => {
        _name: name,
        _price: price,
        _quantity: quantity,
        _amount: amount,
        _tax: tax.name,
        _ean13: ean13,
        _shopCode: shopCode,
        _paymentMethod: paymentMethod?.name,
        _paymentObject: paymentObject?.name,
        _agentData: agentData?._arguments,
        _supplierInfo: supplierInfo?._arguments,
      };
}

class Item12 implements Item {
  static const String _price = 'price';
  static const String _quantity = 'quantity';
  static const String _name = 'name';
  static const String _amount = 'amount';
  static const String _tax = 'tax';
  static const String _paymentMethod = 'paymentMethod';
  static const String _paymentObject = 'paymentObject';
  static const String _agentData = 'agentData';
  static const String _supplierInfo = 'supplierInfo';
  static const String _userData = 'userData';
  static const String _excise = 'excise';
  static const String _countryCode = 'countryCode';
  static const String _declarationNumber = 'declarationNumber';
  static const String _measurementUnit = 'measurementUnit';
  static const String _markProcessingMode = 'markProcessingMode';
  static const String _markCode = 'markCode';
  static const String _markQuantity = 'markQuantity';
  static const String _sectoralItemProps = 'sectoralItemProps';

  /// Сумма в копейках. Целочисленное значение не более 10 знаков
  final double price;

  /// Количество/вес. Целая часть не более 8 знаков
  final double quantity;

  /// Наименование товара. Максимальная длина строки – 128 символов
  final String? name;

  /// Сумма в копейках. Целочисленное значение не более 10 знаков
  final double? amount;

  /// Ставка налога
  final Tax tax;

  /// Тип оплаты
  final PaymentMethod? paymentMethod;

  /// Признак предмета расчета
  final PaymentObject12? paymentObject;

  /// Данные агента
  final AgentData? agentData;

  /// Данные поставщика платежного агента
  final SupplierInfo? supplierInfo;

  /// Дополнительный реквизит предмета расчета
  final String? userData;

  /// Сумма акциза в рублях с учетом копеек, включенная в стоимость предмета расчета
  final double? excise;

  /// Цифровой код страны происхождения товара в соответствии с Общероссийским классификатором стран мира (3 цифры)
  final String? countryCode;

  /// Номер таможенной декларации (32 цифры максимум)
  final String? declarationNumber;

  /// Обозначение единицы измерения в соответствии с метрическими системами на русском или английском
  final String measurementUnit;

  /// Режим обработки кода маркировки
  final String? markProcessingMode;

  /// Данные маркировки
  final MarkCode? markCode;

  /// Реквизит «дробное количество маркированного товара»
  final MarkQuantity? markQuantity;

  /// Реквизит, предусмотренный НПА
  final List<SectoralItemProps>? sectoralItemProps;

  Item12({
    required this.price,
    required this.quantity,
    this.name,
    this.amount,
    required this.tax,
    this.paymentMethod,
    this.paymentObject,
    this.agentData,
    this.supplierInfo,
    this.userData,
    this.excise,
    this.countryCode,
    this.declarationNumber,
    required this.measurementUnit,
    this.markProcessingMode,
    this.markCode,
    this.markQuantity,
    this.sectoralItemProps,
  });

  @override
  Map<String, dynamic> get arguments => {
        _price: price,
        _quantity: quantity,
        _name: name,
        _amount: amount,
        _tax: tax.name,
        _paymentMethod: paymentMethod?.name,
        _paymentObject: paymentObject?.name,
        _agentData: agentData?._arguments,
        _supplierInfo: supplierInfo?._arguments,
        _userData: userData,
        _excise: excise,
        _countryCode: countryCode,
        _declarationNumber: declarationNumber,
        _measurementUnit: measurementUnit,
        _markProcessingMode: markProcessingMode,
        _markCode: markCode?._arguments,
        _markQuantity: markQuantity?._arguments,
        _sectoralItemProps:
            sectoralItemProps?.map((e) => e._arguments).toList(),
      };
}
