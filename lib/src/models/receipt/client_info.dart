part of tinkoff_sdk_models;

/// Информация о покупателе (Обязательно для FfdVersion = 1.2)
class ClientInfo {
  static const _birthdate = 'birthdate';
  static const _citizenship = 'citizenship';
  static const _documentCode = 'documentCode';
  static const _documentData = 'documentData';
  static const _address = 'address';

  /// Дата рождения в формате ДД.ММ.ГГГГ
  final String? birthdate;

  /// Числовой код страны по ОКСМ
  final String? citizenship;

  /// Код вида документа, удостоверяющего личность
  final String? documentCode;

  /// Реквизиты документа (например, серия и номер паспорта)
  final String? documentData;

  /// Адрес покупателя или грузополучателя
  final String? address;

  ClientInfo({
    this.birthdate,
    this.citizenship,
    this.documentCode,
    this.documentData,
    this.address,
  });

  Map<String, dynamic> get _arguments => {
        _birthdate: birthdate,
        _citizenship: citizenship,
        _documentCode: documentCode,
        _documentData: documentData,
        _address: address,
      };
}
