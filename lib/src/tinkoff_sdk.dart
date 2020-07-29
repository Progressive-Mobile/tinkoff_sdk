part of tinkoff_sdk;

class TinkoffSdk {
  String _terminalKey;

  final MethodChannel _channel;
  static TinkoffSdk _instance;

  factory TinkoffSdk() {
    if (_instance == null) {
      _instance = TinkoffSdk._private(
          const MethodChannel(_Method.channel)
      );
    }
    return _instance;
  }

  bool get activated => _terminalKey != null;

  TinkoffSdk._private(this._channel);

  /// Создание объекта для взаимодействия с SDK и передача данных продавца.
  /// Данные для активации выдаются в личном кабинете после подключения к ​Интернет-Эквайрингу.​
  ///
  /// [terminalKey] - Терминал Продавца.
  /// [password] - Пароль от терминала.
  /// [publicKey] - Публичный ключ. Используется для шифрования данных.
  ///               Необходим для интеграции вашего приложения с интернет-эквайрингом Тинькофф.
  ///
  /// [language] - Язык
  ///
  /// Флаги ниже используются для тестирования настроек эквайринга:
  /// [isDeveloperMode] - Тестовый URL (в этом режиме деньги с карт не списываются).
  /// [logging] - Логирование запросов.
  Future<void> activate({
    @required String terminalKey,
    @required String password,
    @required String publicKey,
    
    bool isDeveloperMode = false,
    bool logging = false,
    LocalizationSource language = LocalizationSource.ru,
  }) async {
    final method = _Method.activate;

    final arguments = <String, dynamic> {
      method.terminalKey: terminalKey,
      method.password: password,
      method.publicKey: publicKey,

      method.isDeveloperMode: isDeveloperMode,
      method.isDebug: logging,
      method.language: _LocalizationSource(language).toString()
    };

    final activated = await _channel.invokeMethod<bool>(
      method.name,
      _checkNullArguments(arguments, ignore: [method.language])
    );

    if (activated)
      _terminalKey = terminalKey;
    else
      throw 'Cannot activate TinkoffSDK.'
            '\nOne or more of parameters are invalid.';
  }

  /// Открытие экрана оплаты.
  /// Возвращает [true] при успешной оплате, а
  /// в случае ошибки либо отмены вернет [false].
  ///
  /// Подробное описание параметров см. в реализации
  /// [OrderOptions], [CustomerOptions], [FeaturesOptions].
  Future<bool> openPaymentScreen({
    @required OrderOptions orderOptions,
    @required CustomerOptions customerOptions,
    FeaturesOptions featuresOptions
  }) async {
    _checkActivated();
    if (customerOptions == null) {
      throw ArgumentError.notNull('CustomerOptions cannot be null');
    }
    final _featuresOptions = featuresOptions ?? FeaturesOptions();

    final method = _Method.openPaymentScreen;

    final arguments = <String, dynamic> {
      method.orderOptions: _checkNullArguments(
          orderOptions._arguments(),
          ignore: orderOptions.reccurentPayment
            ? []
            : [OrderOptions._parentPaymentId]
      ),
      method.customerOptions: _checkNullArguments(
          customerOptions._arguments(),
          ignore: [CustomerOptions._email]
      ),
      method.featuresOptions: _checkNullArguments(
          _featuresOptions._arguments()
      )
    };

    return _channel.invokeMethod<bool>(
      method.name,
      arguments
    );
  }

  /// Открытие экрана привязки карт.
  ///
  /// iOS - [Completer] завершается сразу после вызова экрана.
  /// Android - [Completer] завершается после закрытия экрана.
  ///
  /// Подробное описание параметров см. в реализации
  /// [CustomerOptions], [FeaturesOptions].
  Future<void> openAttachCardScreen({
    @required CustomerOptions customerOptions,
    FeaturesOptions featuresOptions,
  }) async {
    _checkActivated();
    if (customerOptions == null) {
      throw ArgumentError.notNull('CustomerOptions cannot be null');
    }
    final _featuresOptions = featuresOptions ?? FeaturesOptions();

    final method = _Method.attachCardScreen;

    final arguments = <String, dynamic> {
      method.customerOptions: customerOptions._arguments(),
      method.featuresOptions: _featuresOptions._arguments()
    };

    await _channel.invokeMethod<void>(
      method.name,
      arguments
    );
  }

  /// Экран приема оплаты по QR коду через СПБ.
  ///
  /// Результат оплаты товара покупателем по статическому QR коду не отслеживается в SDK,
  /// соответственно [Completer] завершается только при ошибке либо отмене (закрытии экрана).
  Future<void> showSBPQrScreen() async {
    _checkActivated();
    final method = _Method.showQrScreen;

    return _channel.invokeMethod<void>(method.name);
  }


  // TODO: ApplePay + GooglePay
  Future<void> openNativePaymentScreen() async {
    _checkActivated();
    final method = _Method.openNativePayment;

    final arguments = <String, dynamic> {};

    return _channel.invokeMethod(
      method.name,
      _checkNullArguments(arguments)
    );
  }

  Map<String, dynamic> _checkNullArguments(Map<String, dynamic> arguments, {List<String> ignore = const []}) {
    for (final argument in arguments.entries) {
      if (argument.value == null) {
        if (!ignore.contains(argument.key))
          throw ArgumentError.notNull(argument.key);
      }
    }
    return arguments;
  }

  void _checkActivated() {
    if (_terminalKey == null) {
      throw 'TinkoffSDK is not activated.'
            '\nYou need call TinkoffSdk.activate method before calling other methods.';
    }
  }
}