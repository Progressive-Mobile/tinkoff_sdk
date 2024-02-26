part of tinkoff_sdk_models;

/// Данные поставщика платежного агента
class SupplierInfo {
  static const _phones = 'phones';
  static const _name = 'name';
  static const _inn = 'inn';

  /// Телефоны поставщика
  final List<String>? phones;

  /// Наименование поставщика
  final String? name;

  /// ИНН поставщика
  final String? inn;

  SupplierInfo({
    this.phones,
    this.name,
    this.inn,
  });

  Map<String, dynamic> get _arguments => {
        _phones: phones,
        _name: name,
        _inn: inn,
      };
}
