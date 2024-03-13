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

import 'dart:convert';

import 'package:tinkoff_sdk/tinkoff_sdk.dart';

TinkoffResult parseTinkoffResult(dynamic result) {
  if (result == null) return TinkoffResult.error();

  final map = jsonDecode(result);

  return TinkoffResult.fromMap(map);
}

List<CardData> parseCardListResult(dynamic result) {
  final cards = <CardData>[];

  if (result is List) {
    for (final item in result) {
      final map = jsonDecode(item);
      final card = CardData.fromMap(map);
      cards.add(card);
    }
  }

  return cards;
}
