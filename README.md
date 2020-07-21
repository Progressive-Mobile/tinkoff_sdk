# Flutter TinkoffSDK

SDK позволяет интегрировать [Интернет-Эквайринг Tinkoff][acquiring] в мобильные приложения, написанные с помощью Flutter.

Возможности SDK:

* Прием платежей (в том числе рекуррентных)
* [ ]  Сохранение банковских карт клиента
* [ ]  Сканирование и распознавание карт с помощью камеры или NFC
* [ ]  Получение информации о клиенте и сохраненных картах
* [ ]  Управление сохраненными картами
* [ ]  Поддержка локализации
* [ ]  Кастомизация экранов SDK
* [ ]  Интеграция с онлайн-кассами
* [ ]  Поддержка Google Pay и Системы быстрых платежей

### Требования
Для работы Tinkoff Acquiring SDK необходим Android версии 4.4 и выше (API level 19).

## Android Integration
### Minimal SDK API: 19

Обратите внимание, что плагин TinkoffSDK требует использования FragmentActivity заместо Activity.
Это можно легко сделать, переключившись на использование
'FlutterFragmentActivity', а не 'FlutterActivity' в вашем
AndroidManifest.xml (или в вашем собственном классе Activity, если вы расширяете базовый класс):

AndroidManifest.xml
```xml
<activity
    android:name="io.flutter.embedding.android.FlutterFragmentActivity"
    ... >
    ...
</activity>
```

MainActivity.kt
```kotlin
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
```

либо MainActivity.java
```java
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
```

## iOS Integration

## Использование
### Подготовка к работе
Для начала работы с SDK вам понадобятся:
* Terminal key
* Пароль
* Public key

Которые выдаются после подключения к [Интернет-Эквайрингу][acquiring].

SDK позволяет настроить режим работы (debug/prod). По умолчанию - режим prod.
Чтобы настроить debug режим, установите параметры:
```dart
import 'package:tinkoff_sdk/tinkoff_sdk.dart';

static const _TERMINAL_KEY = 'TERMINAL_KEY';
static const _PASSWORD = 'PASSWORD';
static const _PUBLIC_KEY = 'PUBLIC_KEY';

final TinkoffSdk acquiring = TinkoffSdk();

acquiring.activate(
    terminalKey: _TERMINAL_KEY,
    password: _PASSWORD,
    publicKey: _PUBLIC_KEY,
    logging: true,
    isDeveloperMode: true
);
```

[acquiring]: https://www.tinkoff.ru/business/internet-acquiring/