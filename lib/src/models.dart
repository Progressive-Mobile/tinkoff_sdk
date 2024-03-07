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

/// Models

/// [TinkoffResult] - результат выполнения вызванного метода.
/// [TinkoffResult.success] - true, если вызванный метод выполнил свою функцию.
/// [TinkoffResult.isError] - Если для результата выполнения isError помечен как true,
/// возможно, стоит показать сообщение пользователю.
/// [TinkoffResult.message] - Результирующее сообщение.
class TinkoffResult {
  static const _success = 'success';
  static const _isError = 'isError';
  static const _message = 'message';

  final bool success;
  final bool isError;
  final String message;

  TinkoffResult.error()
      : this.success = false,
        this.message = 'Native error',
        this.isError = true;

  TinkoffResult.fromMap(Map<String, dynamic> map)
      : this.success = map[_success],
        this.isError = map[_isError],
        this.message = map[_message] ?? '';
}

class CardData {
  static const _cardId = 'cardId';
  static const _pan = 'pan';
  static const _expDate = 'expDate';

  final String cardId;
  final String pan;
  final String expDate;

  CardData.fromMap(Map<String, dynamic> map)
      : this.cardId = map[_cardId],
        this.pan = map[_pan],
        this.expDate = map[_expDate];

  @override
  String toString() {
    return '$runtimeType("cardId":$cardId, "pan":$pan, "expDate":$expDate)';
  }
}
