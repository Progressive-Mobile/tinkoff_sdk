part of tinkoff_sdk_models;

class SectoralItemProps {
  static const _federalId = 'federalId';
  static const _date = 'date';
  static const _number = 'number';
  static const _value = 'value';

  final String federalId;
  final String date;
  final String number;
  final String value;

  SectoralItemProps({
    required this.federalId,
    required this.date,
    required this.number,
    required this.value,
  });

  Map<String, dynamic> get arguments => {
        _federalId: federalId,
        _date: date,
        _number: number,
        _value: value,
      };
}
