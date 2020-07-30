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
  String get language => 'language';
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