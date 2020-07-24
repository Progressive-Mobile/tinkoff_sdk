
part of tinkoff_sdk;

/// Methods

class _Method {
  static const channel = 'tinkoff_sdk';
  static const _Activate activate = const _Activate();
  static const _OpenPaymentScreen openPaymentScreen = const _OpenPaymentScreen();
  static const _AttachCardScreen attachCardScreen = const _AttachCardScreen();
  static const _ShowQrScreen showQrScreen = const _ShowQrScreen();
  static const _OpenNativePayment openNativePayment = const _OpenNativePayment();
}

class _Activate {
  const _Activate();

  String get name => 'activate';

  String get terminalKey => 'terminalKey';
  String get password => 'password';
  String get publicKey => 'publicKey';

  String get isDeveloperMode => 'isDeveloperMode';
  String get isDebug => 'isDebug';
}

class _OpenPaymentScreen {
  const _OpenPaymentScreen();

  String get name => 'openPaymentScreen';

  String get orderOptions => 'orderOptions';
  String get customerOptions => 'customerOptions';
  String get featuresOptions => 'featuresOptions';
}

class _AttachCardScreen {
  const _AttachCardScreen();

  String get name => 'attachCardScreen';

  String get customerOptions => 'customerOptions';
  String get featuresOptions => 'featuresOptions';
}

class _ShowQrScreen {
  const _ShowQrScreen();

  String get name => 'showQrScreen';

  String get localization => 'localizationSource';
}

class _OpenNativePayment {
  const _OpenNativePayment();

  String get name => 'openNativePayment';
}