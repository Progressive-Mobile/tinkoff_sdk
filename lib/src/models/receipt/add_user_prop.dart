part of tinkoff_sdk_models;

class AddUserProp {
  static const _name = 'name';
  static const _value = 'value';

  final String name;
  final String value;

  AddUserProp({
    required this.name,
    required this.value,
  });

  Map<String, dynamic> get _arguments => {
        _name: name,
        _value: value,
      };
}
