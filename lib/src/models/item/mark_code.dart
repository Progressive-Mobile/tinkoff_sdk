part of tinkoff_sdk_models;

class MarkCode {
  static const _markCodeType = 'markCodeType';
  static const _value = 'value';

  final MarkCodeType markCodeType;
  final String value;

  MarkCode({
    required this.markCodeType,
    required this.value,
  });

  Map<String, dynamic> get arguments => {
        _markCodeType: markCodeType.name,
        _value: value,
      };
}

enum MarkCodeType {
  unknown(name: 'unknown'),
  ean8(name: 'ean8'),
  ean13(name: 'ean13'),
  itf14(name: 'itf14'),
  gs10(name: 'gs10'),
  gs1M(name: 'gs1M'),
  short(name: 'short'),
  fur(name: 'fur'),
  egais20(name: 'egais20'),
  egais30(name: 'egais30');

  final String name;

  const MarkCodeType({required this.name});
}
