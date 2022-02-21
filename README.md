# Flutter TinkoffSDK

SDK позволяет интегрировать [Интернет-Эквайринг Tinkoff][acquiring] в мобильные приложения, написанных с помощью Flutter.

Возможности SDK:

* [x] Прием платежей (в том числе рекуррентных)
* [x]  Оплата с помощью:
    * [x] СБП (система быстрых платежей)
    * [x]  ApplePay
    * [x]  Google Pay
* [x] Получение информации о клиенте и сохраненных картах:
    * [x] Сохранение банковских карт клиента
    * [x] Управление сохраненными картами
* [ ]  Сканирование и распознавание карт с помощью камеры или NFC
* [ ]  Кастомизация экранов SDK
* [ ]  Интеграция с онлайн-кассами
* [ ]  Поддержка локализации
    * [x] Android
    * [ ] iOS


### Требования
Для работы Tinkoff Acquiring SDK необходимо: 
* Поддержка Android версии 4.4 и выше (API level 19)
* Поддержка iOS 11 и выше


## iOS Integration
###  `iOS version: 11+`

## Android Integration
### `Minimum API: 19`

Обратите внимание, что плагин TinkoffSDK требует использования FragmentActivity заместо Activity.
Это можно легко сделать, переключившись на использование `FlutterFragmentActivity`, а не `FlutterActivity` в вашем
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

## Использование
### Подготовка к работе
Для начала работы с SDK вам понадобятся:
* Terminal key
* Пароль
* Public key

Которые выдаются после подключения к [Интернет-Эквайрингу][acquiring].

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
    // SDK позволяет настроить режим работы (debug/prod). По умолчанию - режим prod.
    // Чтобы настроить debug режим, установите параметры:
    logging: true,
    isDeveloperMode: true
);
```

### Пример работы

Для проведения оплаты необходимо вызвать метод `openPaymentScreen`.
В метод необходимо передать настройки проведения оплаты, включающие в себя данные заказа, данные покупателя и опционально параметры кастомизации экрана оплаты.
Метод возвращает `TinkoffResult`.
```dart
final result paymentSuccessful = await TinkoffSdk().openPaymentScreen(
  orderOptions: OrderOptions(
    orderId: 1,
    amount: 10000,
    title: "Название платежа",
    description: "Описание платежа",
    reccurentPayment: false
  ),
  customerOptions: CustomerOptions(
    customerKey: "CUSTOMER_KEY",
    email: "email@example.com",
    checkType: CheckType.no
  ),
  featuresOptions: FeaturesOptions(
    useSecureKeyboard: true,
    localizationSource: LocalizationSource.ru,
    enableCameraCardScanner: false
  )
);
```

Для проведения оплаты через Google/Apple pay необходимо вызвать метод `openNativePaymentScreen`.
В метод необходимо передать настройки проведения оплаты, включающие в себя данные заказа, данные покупателя и merchantId в случае оплаты через Apple Pay (рекомендуется использовать .env для хранения такой информации)
```dart
final result paymentSuccessful = await TinkoffSdk().openNativePaymentScreen(
  orderOptions: OrderOptions(
    orderId: 1,
    amount: 10000,
    title: "Название платежа",
    description: "Описание платежа",
    reccurentPayment: false
  ),
  customerOptions: CustomerOptions(
    customerKey: "CUSTOMER_KEY",
    email: "email@example.com",
    checkType: CheckType.no
  ),
  merchantId: 'example.merchant.id',
);
```

### Экран привязки карт

Для запуска экрана привязки карт необходимо вызвать `openAttachCardScreen`.
В метод также необходимо передать некоторые параметры - данные покупателя и опционально параметры кастомизации (по-аналогии с экраном оплаты):

```dart
await TinkoffSdk().openAttachCardScreen(
  customerOptions: CustomerOptions(
    customerKey: "CUSTOMER_KEY"
  ),
  featuresOptions: FeaturesOptions()
);
```

### Система Быстрых Платежей

Включение причема платежей через Систему быстрых платежей осуществляется в Личном кабинете.

##### Включение приема оплаты через СБП по кнопке для покупателя:

При конфигурировании параметров экрана оплаты, необходимо передать соответствующий параметр в featuresOptions.
По умолчанию Система быстрых платежей в SDK отключена.

```dart
final features = FeaturesOptions(
  sbpEnabled: true
);
```

[acquiring]: https://www.tinkoff.ru/business/internet-acquiring/