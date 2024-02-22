part of tinkoff_sdk_models;

class SupplierInfo {
  static const _phones = 'phones';
  static const _name = 'name';
  static const _inn = 'inn';

  final List<String>? phones;
  final String? name;
  final String? inn;

  SupplierInfo({
    this.phones,
    this.name,
    this.inn,
  });

  Map<String, dynamic> get arguments => {
        _phones: phones,
        _name: name,
        _inn: inn,
      };
}
