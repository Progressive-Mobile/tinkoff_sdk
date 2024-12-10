/*

  Copyright © 2024 ProgressiveMobile

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

part of tinkoff_sdk_models;

/// Настройки для конфигурирования визуального отображения и функций экранов SDK
class FeaturesOptions {
  static const String _darkThemeMode = 'darkThemeMode';
  static const String _useSecureKeyboard = 'useSecureKeyboard';
  static const String _handleCardListErrorInSdk = 'handleCardListErrorInSdk';
  static const String _fpsEnabled = 'fpsEnabled';
  static const String _enableCameraCardScanner = 'enableCameraCardScanner';
  static const String _tinkoffPayEnabled = 'tinkoffPayEnabled';
  static const String _selectedCardId = 'selectedCardId';
  static const String _userCanSelectCard = 'userCanSelectCard';
  static const String _showOnlyRecurrentCards = 'showOnlyRecurrentCards';
  static const String _handleErrorsInSdk = 'handleErrorsInSdk';
  static const String _emailRequired = 'emailRequired';
  static const String _duplicateEmailToReceipt = 'duplicateEmailToReceipt';
  static const String _validateExpiryDate = 'validateExpiryDate';

  /// Режим темной темы
  final DarkThemeMode darkThemeMode;

  /// Использовать безопасную клавиатуру для ввода данных карты (только Android)
  final bool useSecureKeyboard;

  /// Обрабатывать возможные ошибки при загрузке карт в SDK
  final bool handleCardListErrorInSdk;

  /// Включение приема платежа через Систему быстрых платежей
  final bool fpsEnabled;

  /// Включение сканирования карты
  final bool enableCameraCardScanner;

  /// Включение приема платежа через Tinkoff Pay
  final bool tinkoffPayEnabled;

  /// Идентификатор карты в системе банка.
  /// Если передан на экран оплаты - в списке карт на экране отобразится первой карта с этим cardId.
  /// Если передан на экран списка карт - в списке карт отобразится выбранная карта.
  /// Если не передан или в списке нет карты с таким cardId - список карт будет отображаться по умолчанию.
  final String? selectedCardId;

  /// Возможность выбрать приоритетную карту для оплаты
  final bool userCanSelectCard;

  /// Показывать на экране списка карт только те карты, которые привязаны как рекуррентные
  final bool showOnlyRecurrentCards;

  /// Обрабатывать возможные ошибки в SDK.
  /// Если установлен true, SDK будет обрабатывать некоторые ошибки с API Acquiring самостоятельно, если false - все ошибки будут возвращаться в вызываемый код, а экран SDK закрываться.
  final bool handleErrorsInSdk;

  /// Должен ли покупатель обязательно вводить email для оплаты.
  /// Если установлен false - покупатель может оставить поле email пустым
  final bool emailRequired;

  /// При выставлении параметра в true, введенный пользователем на форме оплаты email будет продублирован в объект чека.
  /// Не имеет эффекта если объект чека отсутствует
  final bool duplicateEmailToReceipt;

  /// Следует ли при валидации данных карты показывать пользователю ошибку, если введенная им срок действия карты уже истек.
  /// Если установить в true - пользователь не сможет добавить или провести оплату с помощью карты с истекшим сроком действия
  final bool validateExpiryDate;

  const FeaturesOptions({
    this.darkThemeMode = DarkThemeMode.auto,
    this.useSecureKeyboard = true,
    this.handleCardListErrorInSdk = true,
    this.fpsEnabled = false,
    this.enableCameraCardScanner = false,
    this.tinkoffPayEnabled = true,
    this.selectedCardId,
    this.userCanSelectCard = false,
    this.showOnlyRecurrentCards = false,
    this.handleErrorsInSdk = true,
    this.emailRequired = true,
    this.duplicateEmailToReceipt = false,
    this.validateExpiryDate = false,
  });

  Map<String, dynamic> get arguments => {
        _darkThemeMode: darkThemeMode.name,
        _useSecureKeyboard: useSecureKeyboard,
        _handleCardListErrorInSdk: handleCardListErrorInSdk,
        _fpsEnabled: fpsEnabled,
        _enableCameraCardScanner: enableCameraCardScanner,
        _tinkoffPayEnabled: tinkoffPayEnabled,
        _selectedCardId: selectedCardId,
        _userCanSelectCard: userCanSelectCard,
        _showOnlyRecurrentCards: showOnlyRecurrentCards,
        _handleErrorsInSdk: handleErrorsInSdk,
        _emailRequired: emailRequired,
        _duplicateEmailToReceipt: duplicateEmailToReceipt,
        _validateExpiryDate: validateExpiryDate,
      }..removeWhere((key, value) => value == null);
}

/// Настройка включения темной темы
enum DarkThemeMode {
  /// Темная тема переключается в зависимости от системы
  auto(name: 'AUTO'),

  /// Темная тема всегда выключена
  disabled(name: 'DISABLED'),

  /// Темная тема всегда включена
  enabled(name: 'ENABLED');

  final String name;
  const DarkThemeMode({required this.name});
}
