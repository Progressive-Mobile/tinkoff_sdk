part of tinkoff_sdk_models;

/// Реквизит предусмотренный НПА
class SectoralItemProps {
  static const _federalId = 'federalId';
  static const _date = 'date';
  static const _number = 'number';
  static const _value = 'value';

  /// Идентификатор ФОИВ (федеральный орган исполнительной власти)
  final String federalId;

  /// Дата нормативного акта ФОИВ Значение в формате в формате ДД.ММ.ГГГГ
  final String date;

  /// Номер нормативного акта ФОИВ, регламентирующего порядок заполнения реквизита «значение отраслевого реквизита»
  final String number;

  /// Состав значений, определенных нормативного актом ФОИВ
  final String value;

  SectoralItemProps({
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
