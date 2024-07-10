# Tinkoff SDK для Flutter
SDK позволяет интегрировать [Интернет-Эквайринг от Тинькофф][acquiring] в мобильные приложения на Flutter.

## Возможности SDK
- [x] Прием платежей (в том числе рекуррентных)
- [x] Завершение оплаты в приложении
- [x] Оплата с помощью:
	- [x] СБП (Системы быстрых платежей)
	- [x] TinkoffPay
	- [x] QR-кода (статический и динамический)
- [x] Получение информации о картах клиента
	- [x] Добавление новой банковской карты
	- [x] Управление сохраненными картами

## Содержание
- [Tinkoff SDK для Flutter](#tinkoff-sdk-для-flutter)
	- [Возможности SDK](#возможности-sdk)
	- [Содержание](#содержание)
	- [Требования](#требования)
		- [Android](#android)
		- [iOS](#ios)
	- [Использование](#использование)
		- [Подготовка к работе](#подготовка-к-работе)
		- [Проведение оплаты](#проведение-оплаты)
		- [СБП](#сбп)
			- [iOS](#ios-1)
			- [Android](#android-1)
		- [Оплата с помощью QR-кода](#оплата-с-помощью-qr-кода)
			- [Статический QR-код](#статический-qr-код)
			- [Динамический QR-код](#динамический-qr-код)
		- [T-Pay](#t-pay)
			- [iOS](#ios-2)
			- [Android](#android-2)
		- [Список привязанных карт](#список-привязанных-карт)
		- [Добавление новой банковской карты](#добавление-новой-банковской-карты)
		- [Решение возможных проблем](#решение-возможных-проблем)
			- [Ошибка 309. Неверные параметры](#ошибка-309-неверные-параметры)

## Требования
Для работы `Tinkoff SDK` необходимо:

### Android
* Поддержка Android 7.0 и выше (API level 24)
* Использование FragmentActivity вместо Activity

`MainActivity.kt`
```kotlin
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class  MainActivity: FlutterFragmentActivity() {
	override  fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
		GeneratedPluginRegistrant.registerWith(flutterEngine);
	}
}
```
или `MainActivity.java`
```java
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public  class MainActivity extends FlutterFragmentActivity {
	@Override
	public  void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
		GeneratedPluginRegistrant.registerWith(flutterEngine);
	}
}
```
### iOS
* Поддержка iOS 13.0 и выше

## Использование

### Подготовка к работе

Для начала работы с SDK вам понадобятся:
* **Terminal Key**
* **PublicKey**
Эти данные вы получите после подключения к [Интернет-Эквайрингу][acquiring].

```dart

import  'package:tinkoff_sdk/tinkoff_sdk.dart';

static  const _TERMINAL_KEY = 'TERMINAL_KEY';
static  const _PUBLIC_KEY = 'PUBLIC_KEY';

final TinkoffSdk acquiring = TinkoffSdk();

Future<void> activate() async {
	await acquiring.activate(
		terminalKey: _TERMINAL_KEY,
		publicKey: _PUBLIC_KEY,
		// SDK позволяет настроить режим работы (debug/prod). По умолчанию - режим prod.
		// Чтобы настроить debug режим, установите параметры:
		isDeveloperMode: true,
		logging: true,
	);
}
```

:exclamation: Обратите особое внимание на параметр `isDeveloperMode`.

Используйте `isDeveloperMode: true` только с данными **тестового** терминала (terminal key и public key), а `isDeveloperMode: false` только с данными **боевого** терминала.

***При попытке использовать `isDeveloperMode: true` с данными боевого терминала (и наоборот) возникнет ошибка на этапе инициализации TinkoffSdk в приложении.***

  

### Проведение оплаты

Для проведения оплаты нужно вызвать метод `openPaymentScreen`.
```dart

import  'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

Future<TinkoffResult> openPaymentScreen({
	required String terminalKey,
	required String publicKey,
	required OrderOptions orderOptions,
	required CustomerOptions customerOptions,
	FeaturesOptions featuresOptions = const FeaturesOptions(),
}) async {
	await tinkoffSdk.openPaymentScreen(
		terminalKey: terminalKey,
		publicKey: publicKey,
		orderOptions: orderOptions,
		customerOptions: customerOptions,
		featuresOptions: featuresOptions,
	);
}

```

Метод вернет результат типа `TinkoffResult`.

  

![Image](https://github.com/Progressive-Mobile/tinkoff_sdk/assets/64842975/636ee5eb-1f2c-4d08-9235-95fc9b19fbff)

  

Для проведения рекуррентного платежа добавьте в `OrderOptions` поле `recurrentPayment: true`.
```dart
final orderOptions = OrderOptions(
	recurrentPayment: true,
);
```

TASDK предоставляет возможность инициализировать платеж вне приложения (например, на сервере) и завершить его в приложении, используя SDK.
Для проведения такого сценария необходимо:
 1. Инициализировать платеж вне приложения используя метод /v2/Init (подробнее [здесь][init-method])
 2. После успешной инициализации платежа получить в ответе поле `paymentId`
 3. Взять значение `paymentId` и провести завершение оплаты из приложения с помощью метода `.finishPayment()`
```dart
import  'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

Future<TinkoffResult> finishPayment({
	required String terminalKey,
	required String publicKey,
	required String paymentId,
	required OrderOptions orderOptions,
	CustomerOptions? customerOptions,
	FeaturesOptions featuresOptions = const FeaturesOptions(),
}) async {
	final result = await tinkoffSdk.finishPayment(
		terminalKey: terminalKey,
		publicKey: publicKey,
		paymentId: paymentId,
		orderOptions: orderOptions,
		customerOptions: customerOptions,
		featuresOptions: featuresOptions,
	);

	return result;
}
```

### СБП
:exclamation: **Перед началом работы с СБП (Системой быстрых платежей) включите "Оплату через Систему быстрых платежей" в Личном кабинете [Интернет-Эквайринга][acquiring].**

**Информация взята из [документации TASDK iOS][ios-docs]**

#### iOS

Перед началом работы добавьте в `Info.plist` список банков, поддерживающих СБП.

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>bank100000000111</string>
	<string>bank100000000004</string>
	<string>bank110000000005</string>
	<string>bank100000000008</string>
</array>
```

:exclamation: **В список можно внести не более 50-ти схем**

---

#### Android
Дополнительных шагов не требуется

---
После выполнения всех необходимых требований, возможность оплаты через СБП появится в общей форме оплаты.

  

![Image](https://github.com/Progressive-Mobile/tinkoff_sdk/assets/64842975/e6bff613-1363-42fd-be10-0221e46fa7c9)

При выборе конкретного банка из списка произойдет переход в соответствующее банковское приложение.

### Оплата с помощью QR-кода
Оплата с помощью QR-кода может быть проведена двумя способами: через *статический* или *динамический* QR-код.

:exclamation: **Для работы оплаты по QR-коду включите "Оплату через Систему быстрых платежей" в Личном кабинете [Интернет-Эквайринга][acquiring].**

#### Статический QR-код

Отображает экран с многразовым QR-кодом, отсканировав который пользователь сможет провести оплату по СБП (Системе быстрых платежей).

:exclamation: **При данном способе оплаты SDK никак не отслеживает статус платежа**

  

Для отображения статического QR-кода вызовите метод `showStaticQRCode`.

```dart

import 'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

Future<void> showStaticQrCode() async {
	await tinkoffSdk.showStaticQRCode();
}
```

#### Динамический QR-код

Отображает экран с одноразовым QR-кодом, отсканировав который пользователь сможет провести оплату по СБП (Системе быстрых платежей).

Для отображения динамического QR-кода вызовите метод `showDynamicQRCode`.

```dart

import  'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

Future<TinkoffResult> showDynamicQRCode({
	required AndroidDynamicQrCode androidDynamicQrCode,
	required IosDynamicQrCode iOSDynamicQrCode,
}) async {
	await tinkoffSdk.showDynamicQRCode(
		androidDynamicQrCode: androidDynamicQrCode,
		iOSDynamicQrCode: iOSDynamicQrCode,
	);
}
```

Метод вернет результат типа `TinkoffResult`.

### T-Pay

:exclamation: **Перед началом работы подключите "Оплату через T-Pay" в Личном кабинете [Интернет-Эквайринга][acquiring]**


**Информация взята из [документации Tinkoff ASDK iOS][ios-docs]**

#### iOS
Прежде всего для корректной работы `T-Pay` в вашем приложении необходимо добавить в `Info.plist` в массив по ключу `LSApplicationQueriesSchemes` значение `bank100000000004`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>bank100000000004</string>
</array>
```

Так приложение сможет определить наличие приложения `Т-Банк` на устройстве пользователя.

#### Android
Дополнительных шагов не требуется

### Список привязанных карт
Вы можете отобразить список привязанных карт пользователя. Для этого вызовите метод `getCardList`:
```dart
import  'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

Future<void> getCardsList({
	required String terminalKey,
	required String publicKey,
	required CustomerOptions customerOptions,
}) async {
	await tinkoffSdk.getCardList(
		terminalKey: terminalKey,
		publicKey: publicKey,
		customerOptions: _customerOptions,
	);
}
```

### Добавление новой банковской карты

Вы можете отобразить на новом экране форму добавления новой банковской карты. Для этого вызовите метод `openAttachCardScreen`:

```dart
import  'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

Future<void> openAttachCardScreen({
	required String terminalKey,
	required String publicKey,
	required CustomerOptions customerOptions,
	FeaturesOptions featuresOptions = const FeaturesOptions(),
}) async {
	await tinkoffSdk.openAttachCardScreen(
		terminalKey: terminalKey,
		publicKey: publicKey,
		customerOptions: customerOptions,
		featuresOptions: featuresOptions,
	);
}
```

### Решение возможных проблем
#### Ошибка 309. Неверные параметры
*"Details":"{request.validate.expected.receipt}"*

Ошибка появляется в случае, если в вашем магазине подключена Онлайн-Касса, которой необходимо к каждому платежу прикреплять чек.

**Решение**

В методе `openPaymentScreen` в `OrderOptions` необходимо добавить следующее:
 1. Поле чека (`receipt`) с **непустым** списком позиций чека (`items`)
 2. Для каждой позиции в чеке (`Item105`) добавьте поле `quantity` (количество/вес товара)
 3. В поле `receipt` в `Receipt105/Receipt12` добавьте поля `taxation` (cистема налогообложения) и `email`/`phone` (e-mail или номер телефона).

Пример:
```dart
import  'package:tinkoff_sdk/tinkoff_sdk.dart';

final tinkoffSdk = TinkoffSdk();

final orderOptions = OrderOptions(
	orderId: '111111',
	amount: 1000,
	receipt: Receipt105(
		taxation: Taxation.osn, // добавить это
		email: 'test@gmail.com', // это (почту или телефон)
		items: [
			Item105(
				name: 'Успокоительное',
				amount: 1000,
				tax: Tax.vat0,
				paymentMethod: PaymentMethod.fullPrepayment,
				price: 1000,
				quantity: 1, // и это
			),
		],
	)
);

Future<TinkoffResult> openPaymentScreen({
	required String terminalKey,
	required String publicKey,
	required CustomerOptions customerOptions,
	FeaturesOptions featuresOptions = const FeaturesOptions(),
}) async {
	await tinkoffSdk.openPaymentScreen(
		terminalKey: terminalKey,
		publicKey: publicKey,
		orderOptions: orderOptions,
		customerOptions: customerOptions,
		featuresOptions: featuresOptions,
	); 
}
```

[acquiring]: https://www.tbank.ru/kassa/
[ios-docs]: https://opensource.tinkoff.ru/mobile-tech/asdk-ios#t-bank-acquiring-sdk-for-ios
[init-method]: https://www.tbank.ru/kassa/dev/payments/#tag/Standartnyj-platezh