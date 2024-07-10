part of tinkoff_sdk_models;

class SectoralCheckProps {
  static const _federalId = 'federalId';
  static const _date = 'date';
  static const _number = 'number';
  static const _value = 'value';

  /// Идентификатор ФОИВ (тег 1262). Максимальное количество символов – 3
  final String federalId;

  /// Дата документа основания в формате ДД.ММ.ГГГГ (тег 1263)
  final String date;

  /// Номер документа основания (тег 1264)
  final String number;

  /// Значение отраслевого реквизита (тег 1265)
  final String value;

  SectoralCheckProps({
    required this.federalId,
    required this.date,
    required this.number,
    required this.value,
  });

  Map<String, dynamic> get _arguments => {
        _federalId: federalId,
        _date: date,
        _number: number,
        _value: value,
      };
}
