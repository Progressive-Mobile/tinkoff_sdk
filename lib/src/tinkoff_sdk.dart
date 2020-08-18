/*

  Copyright © 2020 ProgressiveMobile

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

part of tinkoff_sdk;

class TinkoffSdk {
  static TinkoffSdk _instance;

  factory TinkoffSdk() {
    if (_instance == null) {
      _instance = TinkoffSdk._private(
          const MethodChannel(Method.channel)
      );
    }
    return _instance;
  }

  TinkoffSdk._private(this._channel);

  final MethodChannel _channel;
  String _terminalKey;
  
  bool get activated => _terminalKey != null;

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
  Future<bool> activate({
    @required String terminalKey,
    @required String password,
    @required String publicKey,
    
    bool isDeveloperMode = false,
    bool logging = false,
    LocalizationSource language = LocalizationSource.ru,
  }) async {
    final method = Method.activate;

    final arguments = <String, dynamic> {
      method.terminalKey: terminalKey,
      method.password: password,
      method.publicKey: publicKey,

      method.isDeveloperMode: isDeveloperMode,
      method.isDebug: logging,
      method.language: localizationString(language)
    };

    final activated = await _channel.invokeMethod<bool>(
      method.name,
      checkNullArguments(arguments, ignore: [method.language])
    );

    if (activated)
      _terminalKey = terminalKey;
    else
      throw 'Cannot activate TinkoffSDK.'
            '\nOne or more of parameters are invalid.';

    return activated;
  }

  Future<List<CardData>> getCardList(String customerKey) async {
    _checkActivated();

    final method = Method.getCardList;

    final arguments = <String, dynamic> {
      method.customerKey: customerKey
    };

    return _channel
        .invokeMethod(method.name, checkNullArguments(arguments))
        .then(parseCardListResult);
  }

  /// Открытие экрана оплаты.
  /// Возвращает [true] при успешной оплате, а
  /// в случае ошибки либо отмены вернет [false].
  ///
  /// Подробное описание параметров см. в реализации
  /// [OrderOptions], [CustomerOptions], [FeaturesOptions].
  Future<TinkoffResult> openPaymentScreen({
    @required OrderOptions orderOptions,
    @required CustomerOptions customerOptions,
    FeaturesOptions featuresOptions
  }) async {
    _checkActivated();
    if (customerOptions == null) {
      throw ArgumentError.notNull('CustomerOptions cannot be null');
    }
    final _featuresOptions = featuresOptions ?? FeaturesOptions();

    final method = Method.openPaymentScreen;

    final arguments = <String, dynamic> {
      method.orderOptions: checkNullArguments(
          orderOptions._arguments()
      ),
      method.customerOptions: checkNullArguments(
          customerOptions._arguments(),
          ignore: [CustomerOptions._email]
      ),
      method.featuresOptions: checkNullArguments(
          _featuresOptions._arguments()
      )
    };

    return _channel
        .invokeMethod(method.name, arguments)
        .then(parseTinkoffResult);
  }

  /// Открытие экрана привязки карт.
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

    final method = Method.attachCardScreen;

    final arguments = <String, dynamic> {
      method.customerOptions: customerOptions._arguments(),
      method.featuresOptions: _featuresOptions._arguments()
    };

    return _channel
        .invokeMethod(method.name, arguments);
  }

  /// Экран приема оплаты по QR коду через СПБ.
  ///
  /// Результат оплаты товара покупателем по статическому QR коду не отслеживается в SDK,
  /// соответственно [Completer] завершается только при ошибке либо отмене (закрытии экрана).
  Future<TinkoffResult> showSBPQrScreen() async {
    _checkActivated();
    final method = Method.showQrScreen;

    return _channel
        .invokeMethod(method.name)
        .then(parseTinkoffResult);
  }


  // TODO: implement ApplePay + GooglePay
  Future<TinkoffResult> openNativePaymentScreen() async {
    _checkActivated();
    final method = Method.openNativePayment;

    final arguments = <String, dynamic> {};

    return _channel
        .invokeMethod(method.name, arguments)
        .then(parseTinkoffResult);
  }

  // TODO: implement Charge
  Future<TinkoffResult> startCharge() async {
    _checkActivated();
    final method = Method.startCharge;

    final arguments = <String, dynamic> {};

    return _channel
        .invokeMethod(method.name, arguments)
        .then(parseTinkoffResult);
  }

  void _checkActivated() {
    if (_terminalKey == null) {
      throw 'TinkoffSDK is not activated.'
            '\nYou need call TinkoffSdk.activate method before calling other methods.';
    }
  }
}