# Tinkoff SDK for Flutter
SDK позволяет интегрировать [Интернет-Эквайринг от Тинькофф][acquiring] в мобильные приложения на Flutter.

## Возможности SDK
- [x] Прием платежей (в том числе рекуррентных)
- [x] Оплата с помощью:
	- [x] СБП (Системы быстрых платежей)
	- [x] TinkoffPay
	- [x] Оплата с помощью QR-кода (статический и динамический)
- [x] Получение информации о картах клиента
	- [x] Добавление новой банковской карты
	- [x] Управление сохраненными картами

## Содержание
- [Tinkoff SDK for Flutter](#tinkoff-sdk-for-flutter)
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
		- [TinkoffPay](#tinkoffpay)
			- [iOS](#ios-2)
			- [Android](#android-2)
		- [Список привязанных карт](#список-привязанных-карт)
		- [Добавление новой банковской карты](#добавление-новой-банковской-карты)

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

	class MainActivity: FlutterFragmentActivity() {
		override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
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
	
	public class MainActivity extends FlutterFragmentActivity {
		@Override
		public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
			GeneratedPluginRegistrant.registerWith(flutterEngine);
		}
	}
```

### iOS
* Поддержка iOS 15.0 и выше

## Использование
### Подготовка к работе
Для начала работы с SDK вам понадобятся:
* **Terminal Key**
* **PublicKey**
Эти данные вы получите после подключения к [Интернет-Эквайрингу][acquiring].
```dart
import  'package:tinkoff_sdk/tinkoff_sdk.dart';

static const _TERMINAL_KEY = 'TERMINAL_KEY';
static const _PUBLIC_KEY = 'PUBLIC_KEY';

final TinkoffSdk acquiring = TinkoffSdk();

acquiring.activate(
	terminalKey: _TERMINAL_KEY,
	publicKey: _PUBLIC_KEY,
	// SDK позволяет настроить режим работы (debug/prod). По умолчанию - режим prod.
	// Чтобы настроить debug режим, установите параметры:
	logging: true,
	isDeveloperMode: true
);
```
:exclamation: Обратите особое внимание на параметр `isDeveloperMode`.
Используйте `isDeveloperMode: true` только с данными **тестового** терминала (terminal key и public key), а `isDeveloperMode: false` только с данными **боевого** терминала.
***При попытке использовать `isDeveloperMode: true` с данными боевого терминала (и наоборот) возникнет ошибка на этапе создания TinkoffSdk в приложении.***

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
	}) async {
		await tinkoffSdk.openPaymentScreen(
			terminalKey: terminalKey,
			publicKey: publicKey,
			orderOptions: orderOptions,
			customerOptions: customerOptions,
		);
	}
```
Метод вернет результат типа `TinkoffResult`.

![Image](https://github.com/Progressive-Mobile/tinkoff_sdk/assets/64842975/636ee5eb-1f2c-4d08-9235-95fc9b19fbff)

Для проведения рекуррентного платежа добавьте в `OrderOptions` поле `recurrentPayment: true`.
```dart
	final orderOptions = OrderOptions(
		recurrentPayment: true
		///
	);
```

### СБП
:exclamation: **Перед началом работы с СБП (Системой быстрых платежей) включите "Оплату через Систему быстрых платежей" в Личном кабинете [Интернет-Эквайринга][acquiring].**

**Информация взята из [документации Tinkoff ASDK iOS][ios-docs]**
#### iOS
Перед началом работы добавьте в  `Info.plist` список банков, поддерживающих СБП. 
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

**Для отображения кнопки оплаты по СБП в общей форме оплаты добавьте в метод `openPaymentScreen` параметр `featuresOptions` с полем `fpsEnabled: true` (по умолчанию `fpsEnabled = false`).**
```dart
	await tinkoffSdk.openPaymentScreen(
		terminalKey: terminalKey,
		publicKey: publicKey,
		orderOptions: orderOptions,
		customerOptions: customerOptions,
		featuresOptions: FeaturesOptions(
			fpsEnabled: true,
		),
	);
```

После выполнения всех необходимых требований, возможность оплаты через СБП появится в общей форме оплаты.

![Image](https://github.com/Progressive-Mobile/tinkoff_sdk/assets/64842975/e6bff613-1363-42fd-be10-0221e46fa7c9)

При выборе конкретного банка из списка произойдет переход в соответствующее банковское приложение.

### Оплата с помощью QR-кода
Оплата с помощью QR-кода может быть проведена двумя способами: через *статический* или *динамический* QR-код.

:exclamation: **Для корректной работы оплаты по QR-коду включите "Оплату через Систему быстрых платежей" в Личном кабинете [Интернет-Эквайринга][acquiring].**

#### Статический QR-код
Отображает экран с многразовым QR-кодом, отсканировав который пользователь сможет провести оплату по СБП (Системе быстрых платежей).

:exclamation: **При данном способе оплаты SDK никак не отслеживает статус платежа**

Для отображения статического QR-кода вызовите метод `showStaticQRCode`.
```dart
	import  'package:tinkoff_sdk/tinkoff_sdk.dart';

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

### TinkoffPay
:exclamation: **На данный момент оплата через TinkoffPay доступна только через общую форму оплаты**
:exclamation: **Перед началом работы подключите "Оплату через TinkoffPay" в Личном кабинете [Интернет-Эквайринга][acquiring]**

**Информация взята из [документации Tinkoff ASDK iOS][ios-docs]**

#### iOS
Для корректной работы `TinkoffPay` в вашем приложении необходимо добавить в `Info.plist` в массив по ключу `LSApplicationQueriesSchemes` значение `tinkoffbank`:
```xml
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>tinkoffbank</string>
	</array>
```
Так приложение сможет определить наличие приложения `Тинькофф` на устройстве пользователя.

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
	}) async {
		await tinkoffSdk.openAttachCardScreen(
			terminalKey: terminalKey,
			publicKey: publicKey,
			customerOptions: _customerOptions,
		);
	}
```

[acquiring]: https://www.tinkoff.ru/business/internet-acquiring/
[ios-docs]: https://opensource.tinkoff.ru/tinkoff-mobile-tech/tinkoff-asdk-ios/-/tree/master#%D0%BE%D0%BF%D0%BB%D0%B0%D1%82%D0%B0-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B-%D0%B1%D1%8B%D1%81%D1%82%D1%80%D1%8B%D1%85-%D0%BF%D0%BB%D0%B0%D1%82%D0%B5%D0%B6%D0%B5%D0%B9