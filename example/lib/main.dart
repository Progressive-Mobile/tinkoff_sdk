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

import 'package:flutter/material.dart';
import 'package:tinkoff_sdk/tinkoff_sdk.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinkoff SDK',
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TinkoffSdk acquiring = TinkoffSdk();

  static const _TERMINAL_KEY = '';
  static const _PUBLIC_KEY = '';

  final _terminalKeyController = TextEditingController(text: _TERMINAL_KEY);
  final _publicKeyController = TextEditingController(text: _PUBLIC_KEY);

  OrderOptions? _orderOptions;
  CustomerOptions? _customerOptions;
  FeaturesOptions _featuresOptions = FeaturesOptions();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getLayout(),
    );
  }

  AppBar _getAppBar() => AppBar(
      title: Text('Tinkoff SDK'),
      centerTitle: true,
      actions: acquiring.activated
          ? [_getCardAttachAction(), _getSBPShowQRAction()]
          : []);

  Widget _getLayout() {
    if (!TinkoffSdk().activated) {
      return _getActivatePanel();
    } else {
      return _getPaymentLayout();
    }
  }

  Widget _getActivatePanel() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getTextForm('Terminal Key', _terminalKeyController),
          _getTextForm('Public Key', _publicKeyController),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              acquiring
                  .activate(
                terminalKey: _terminalKeyController.text,
                publicKey: _publicKeyController.text,
                logging: true,
                isDeveloperMode: false,
              )
                  .then((_) {
                if (mounted) setState(() {});
              }).catchError(_showErrorDialog);
            },
            child: Text('Активировать'),
          )
        ],
      ),
    );
  }

  Widget _getPaymentLayout() {
    return ListView(
      children: <Widget>[
        Text(
          'Нажмите на карточку, чтобы внести в неё изменения',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 8.0),
        _getOrderCard(),
        _getCustomerCard(),
        _getFeatureCard(),
        _getPaymentAction(),
        _getCardsAction(),
        _getFinishPayment(),
      ],
    );
  }

  Widget _getOrderCard() {
    return _getCardLayout(
      title: 'Данные заказа',
      body: _orderOptions != null
          ? Column(
              children: [
                _getEntryText('ID заказа', _orderOptions!.orderId,
                    required: true),
                _getEntryText('Заголовок', _orderOptions!.title,
                    required: true),
                _getEntryText('Описание', _orderOptions!.description,
                    required: true),
                _getEntryText('Сумма (в копейках)', _orderOptions!.amount),
                _getEntryText(
                    'Рекуррентный платеж', _orderOptions!.recurrentPayment)
              ],
            )
          : Text('Нажмите чтобы заполнить'),
      onTap: _showOrderOptionsDialog,
    );
  }

  Widget _getCustomerCard() {
    return _getCardLayout(
        title: 'Данные покупателя',
        body: _customerOptions != null
            ? Column(
                children: [
                  _getEntryText('ID', _customerOptions!.customerKey,
                      required: true),
                  _getEntryText('E-mail', _customerOptions!.email),
                  _getEntryText(
                      'Тип проверки карты', _customerOptions!.checkType)
                ],
              )
            : Text('Нажмите чтобы заполнить'),
        onTap: _showCustomerOptionsDialog);
  }

  Widget _getFeatureCard() {
    return _getCardLayout(
        title: 'Настройки экрана',
        body: Column(
          children: [
            _getEntryText('Темная тема', _featuresOptions.darkThemeMode),
            _getEntryText(
                'Безопасная клавиатура', _featuresOptions.useSecureKeyboard),
            _getEntryText('Обработка ошибок списка карт в SDK',
                _featuresOptions.handleCardListErrorInSdk),
            _getEntryText('СБП включено', _featuresOptions.fpsEnabled),
            _getEntryText('Сканер карт включён',
                _featuresOptions.enableCameraCardScanner),
            _getEntryText(
                'Tinkoff Pay включен', _featuresOptions.tinkoffPayEnabled),
            _getEntryText(
                'Yandex Pay включен', _featuresOptions.yandexPayEnabled),
            _getEntryText(
                'Выбор приоритетной карты', _featuresOptions.userCanSelectCard),
            _getEntryText('Показ только рекуррентных карт',
                _featuresOptions.showOnlyRecurrentCards),
            _getEntryText(
                'Обработка ошибок', _featuresOptions.handleErrorsInSdk),
            _getEntryText(
                'Обязательный e-mail', _featuresOptions.emailRequired),
            _getEntryText('Дублирование e-mail в чек',
                _featuresOptions.duplicateEmailToReceipt),
            _getEntryText('Валидация срока действия карты',
                _featuresOptions.validateExpiryDate),
          ],
        ),
        onTap: _showFeatureOptionsDialog);
  }

  Widget _getPaymentAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _orderOptions != null && _customerOptions != null
                  ? () {
                      acquiring
                          .openPaymentScreen(
                            orderOptions: _orderOptions!,
                            customerOptions: _customerOptions!,
                            featuresOptions: _featuresOptions,
                            terminalKey: _TERMINAL_KEY,
                            publicKey: _PUBLIC_KEY,
                          )
                          .then(_showResultDialog)
                          .catchError(_showErrorDialog);
                    }
                  : null,
              child: Text('Тестовая оплата'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCardsAction() {
    return ElevatedButton(
      onPressed: _customerOptions != null
          ? () {
              acquiring.getCardList(
                terminalKey: _TERMINAL_KEY,
                publicKey: _PUBLIC_KEY,
                customerOptions: _customerOptions!,
                featuresOptions: _featuresOptions,
              );
            }
          : null,
      child: Text('Список карт'),
    );
  }

  Widget _getFinishPayment() {
    return ElevatedButton(
      onPressed: _orderOptions != null && _customerOptions != null
          ? () {
              acquiring.finishPayment(
                terminalKey: _TERMINAL_KEY,
                publicKey: _PUBLIC_KEY,
                paymentId: '',
                orderOptions: _orderOptions!,
                customerOptions: _customerOptions,
                featuresOptions: _featuresOptions,
              );
            }
          : null,
      child: Text(
        'Завершить оплату',
      ),
    );
  }

  Widget _getTextForm(
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool isDialog = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 2.0, horizontal: isDialog ? 0.0 : 24.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: hint,
            alignLabelWithHint: true),
      ),
    );
  }

  Widget _getEntryText(String key, dynamic value, {bool required = false}) {
    final canShow = (value != null && value is! String) ||
        (value is String && value.isNotEmpty);
    return Row(
      children: [
        Text(key),
        Spacer(),
        Text(
          canShow ? value.toString() : 'не указано',
          style: TextStyle(
              fontSize: 12.0, color: canShow ? Colors.black : Colors.grey),
        ),
        if (!canShow && required)
          Icon(Icons.warning, color: Colors.red, size: 14.0)
      ],
    );
  }

  Widget _getCardLayout({
    required String title,
    required Widget body,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              SizedBox(height: 4.0),
              body
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _showResultDialog(TinkoffResult result) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Результат'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Success: ' + result.success.toString()),
                  Text('isError: ' + result.isError.toString()),
                  Text('Message: ' + result.message.toString()),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            ));
  }

  Future<Null> _showErrorDialog(error) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Ошибка'),
              content: Text(error.toString()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            ));
  }

  void _showOrderOptionsDialog() async {
    final orderIdController = TextEditingController(
        text: _orderOptions?.orderId.toString() ?? '111111');
    final titleController =
        TextEditingController(text: _orderOptions?.title ?? 'test');
    final descriptionController =
        TextEditingController(text: _orderOptions?.description ?? 'Книга');
    final amountController =
        TextEditingController(text: _orderOptions?.amount.toString() ?? '1000');
    final ValueNotifier<bool> reccurent =
        ValueNotifier(_orderOptions?.recurrentPayment ?? false);

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getTextForm('ID заказа', orderIdController,
                        keyboardType: TextInputType.number, isDialog: true),
                    _getTextForm(
                      'Заголовок',
                      titleController,
                      isDialog: true,
                    ),
                    _getTextForm(
                      'Описание',
                      descriptionController,
                      isDialog: true,
                    ),
                    _getTextForm('Сумма (в копейках)', amountController,
                        keyboardType: TextInputType.number, isDialog: true),
                    _getCheckboxRow('Рекуррентный платеж', reccurent),
                  ],
                ),
              ),
            ));
    final orderId = orderIdController.text;
    setState(() {
      _orderOptions = OrderOptions(
          orderId: orderId,
          amount: int.tryParse(amountController.text)!,
          title: titleController.text,
          description: descriptionController.text,
          recurrentPayment: reccurent.value,
          receipt: Receipt105(
            taxation: Taxation.osn,
            email: _customerOptions?.email ?? '',
            items: [
              Item105(
                name: 'Кружка 350 мл',
                amount: 1000,
                tax: Tax.vat0,
                paymentMethod: PaymentMethod.fullPrepayment,
                price: 1000,
                quantity: 1,
              ),
            ],
          ));
    });
  }

  void _showCustomerOptionsDialog() async {
    final idController =
        TextEditingController(text: _customerOptions?.customerKey ?? '1');
    final emailController =
        TextEditingController(text: _customerOptions?.email ?? '');
    final checkType =
        ValueNotifier<CheckType>(_customerOptions?.checkType ?? CheckType.no);

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getTextForm('ID', idController, isDialog: true),
                    _getTextForm('E-mail', emailController,
                        keyboardType: TextInputType.emailAddress,
                        isDialog: true),
                    Row(
                      children: <Widget>[
                        Text('Тип проверки'),
                        Spacer(),
                        ValueListenableBuilder<CheckType>(
                          valueListenable: checkType,
                          builder: (context, value, _) =>
                              DropdownButton<CheckType>(
                                  value: value,
                                  items: [
                                    DropdownMenuItem(
                                      value: CheckType.no,
                                      child: Text('NO'),
                                    ),
                                    DropdownMenuItem(
                                        value: CheckType.hold,
                                        child: Text('HOLD')),
                                    DropdownMenuItem(
                                        value: CheckType.threeDS,
                                        child: Text('3DS')),
                                    DropdownMenuItem(
                                        value: CheckType.threeDS_hold,
                                        child: Text('3DS_HOLD'))
                                  ],
                                  onChanged: (value) {
                                    checkType.value = value!;
                                  }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
    setState(() {
      _customerOptions = CustomerOptions(
        customerKey: idController.text,
        email: emailController.text,
        checkType: checkType.value,
      );
    });
  }

  void _showFeatureOptionsDialog() async {
    final darkThemeMode =
        ValueNotifier<DarkThemeMode>(_featuresOptions.darkThemeMode);
    final useSecureKeyboard =
        ValueNotifier<bool>(_featuresOptions.useSecureKeyboard);
    final handleCardListErrorInSdk =
        ValueNotifier<bool>(_featuresOptions.handleCardListErrorInSdk);
    final enableCameraCardScanner =
        ValueNotifier<bool>(_featuresOptions.enableCameraCardScanner);
    final userCanSelectCard =
        ValueNotifier<bool>(_featuresOptions.userCanSelectCard);
    final showOnlyRecurrentCards =
        ValueNotifier<bool>(_featuresOptions.showOnlyRecurrentCards);
    final handleErrorsInSdk =
        ValueNotifier<bool>(_featuresOptions.handleErrorsInSdk);
    final emailRequired = ValueNotifier<bool>(_featuresOptions.emailRequired);
    final duplicateEmailToReceipt =
        ValueNotifier<bool>(_featuresOptions.duplicateEmailToReceipt);
    final validateExpiryDate =
        ValueNotifier<bool>(_featuresOptions.validateExpiryDate);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          padding: EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: <Widget>[
                  Text('Темная тема'),
                  Spacer(),
                  ValueListenableBuilder<DarkThemeMode>(
                    valueListenable: darkThemeMode,
                    builder: (context, value, _) =>
                        DropdownButton<DarkThemeMode>(
                            value: value,
                            items: [
                              DropdownMenuItem(
                                value: DarkThemeMode.auto,
                                child: Text('AUTO'),
                              ),
                              DropdownMenuItem(
                                  value: DarkThemeMode.enabled,
                                  child: Text('ENABLED')),
                              DropdownMenuItem(
                                  value: DarkThemeMode.disabled,
                                  child: Text('DISABLED'))
                            ],
                            onChanged: (value) {
                              darkThemeMode.value = value!;
                            }),
                  ),
                ],
              ),
              _getCheckboxRow('Безопасная клавиатура', useSecureKeyboard),
              _getCheckboxRow('Обработка ошибок списка карт в SDK',
                  handleCardListErrorInSdk),
              _getCheckboxRow('Сканнер карт', enableCameraCardScanner),
              _getCheckboxRow('Выбор приоритетной карты', userCanSelectCard),
              _getCheckboxRow(
                  'Показ только рекуррентных карт', showOnlyRecurrentCards),
              _getCheckboxRow('Обработка ошибок', handleErrorsInSdk),
              _getCheckboxRow('Обязательный e-mail', emailRequired),
              _getCheckboxRow(
                  'Дублирование e-mail в чек', duplicateEmailToReceipt),
              _getCheckboxRow(
                  'Валидация срока действия карты', validateExpiryDate),
            ],
          ),
        ),
      ),
    );
    setState(() {
      _featuresOptions = FeaturesOptions(
        darkThemeMode: darkThemeMode.value,
        useSecureKeyboard: useSecureKeyboard.value,
        handleCardListErrorInSdk: handleCardListErrorInSdk.value,
        enableCameraCardScanner: enableCameraCardScanner.value,
        userCanSelectCard: userCanSelectCard.value,
        showOnlyRecurrentCards: showOnlyRecurrentCards.value,
        handleErrorsInSdk: handleErrorsInSdk.value,
        emailRequired: emailRequired.value,
        duplicateEmailToReceipt: duplicateEmailToReceipt.value,
        validateExpiryDate: validateExpiryDate.value,
      );
    });
  }

  Widget _getCheckboxRow(String title, ValueNotifier<bool> valueListenable) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: valueListenable,
          builder: (context, value, _) => Checkbox(
            value: value,
            onChanged: (value) => valueListenable.value = value!,
          ),
        ),
      ],
    );
  }

  Widget _getCardAttachAction() {
    return IconButton(
      icon: Icon(Icons.add_card_rounded),
      onPressed: _customerOptions != null
          ? () async {
              await acquiring.openAttachCardScreen(
                terminalKey: _TERMINAL_KEY,
                publicKey: _PUBLIC_KEY,
                customerOptions: _customerOptions!,
                featuresOptions: _featuresOptions,
              );
            }
          : null,
    );
  }

  Widget _getSBPShowQRAction() {
    return IconButton(
      icon: Icon(Icons.qr_code_rounded),
      onPressed: _orderOptions != null && _customerOptions != null
          ? () async {
              await acquiring.showDynamicQRCode(
                iOSDynamicQrCode: IosDynamicQrCodeFullPaymentFlow(
                  orderOptions: _orderOptions!,
                ),
                androidDynamicQrCode: AndroidDynamicQrCode(
                  orderOptions: _orderOptions!,
                  customerOptions: _customerOptions!,
                  terminalKey: _TERMINAL_KEY,
                  publicKey: _PUBLIC_KEY,
                ),
              );
            }
          : null,
    );
  }
}
