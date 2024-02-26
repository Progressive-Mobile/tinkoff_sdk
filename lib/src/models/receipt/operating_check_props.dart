part of tinkoff_sdk_models;

/// Операционный реквизит чека (тег 1270)
class OperatingCheckProps {
  static const _name = 'name';
  static const _value = 'value';
  static const _timestamp = 'timestamp';

  /// Идентификатор операции (тег 1271)
  final String name;

  /// Данные операции (тег 1272)
  final String value;

  /// Дата и время операции в формате ДД.ММ.ГГГГ ЧЧ:ММ:СС (тег 1273)
  final String timestamp;

  OperatingCheckProps({
    required this.name,
    required this.value,
    required this.timestamp,
  });

  Map<String, dynamic> get _arguments => {
        _name: name,
        _value: value,
        _timestamp: timestamp,
      };
}
