import 'package:flutter/foundation.dart';
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
  static const _PASSWORD = '';
  static const _PUBLIC_KEY = '';

  final TextEditingController _terminalKeyController = TextEditingController(text: _TERMINAL_KEY);
  final TextEditingController _passwordController = TextEditingController(text: _PASSWORD);
  final TextEditingController _publicKeyController = TextEditingController(text: _PUBLIC_KEY);
  final locale = ValueNotifier<LocalizationSource>(LocalizationSource.ru);

  OrderOptions _orderOptions;
  CustomerOptions _customerOptions;
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

  Widget _getAppBar() {
    return AppBar(
      title: Text('Tinkoff SDK'),
      centerTitle: true,
      actions: TinkoffSdk().activated
        ? [
            _getCardAttachAction(),
            _getSBPShowQRAction()
          ]
        : [
            ValueListenableBuilder<LocalizationSource>(
              valueListenable: locale,
              builder: (context, value, _) => DropdownButton<LocalizationSource>(
                  value: value,
                  items: [
                    DropdownMenuItem(
                      value: LocalizationSource.ru,
                      child: Text('RU'),
                    ),
                    DropdownMenuItem(
                        value: LocalizationSource.en,
                        child: Text('EN')
                    ),
                  ],
                  onChanged: (value) {
                    locale.value = value;
                  }
              ),
            ),
          ]
    );
  }

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
          _getTextForm('Password', _passwordController),
          _getTextForm('Public Key', _publicKeyController),
          SizedBox(height: 16.0),
          RaisedButton(
            onPressed: () {
              acquiring.activate(
                terminalKey: _terminalKeyController.text,
                password: _passwordController.text,
                publicKey: _publicKeyController.text,
                logging: true,
                isDeveloperMode: false,
                language: locale.value
              ).then((_) {
                  if (mounted) setState((){});
                }).catchError(_showErrorDialog);
            },
            child: Text('Активировать'),
          )
        ],
      ),
    );
  }

  Widget _getPaymentLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        SizedBox(height: 8.0),
        _getPaymentAction(),
      ],
    );
  }

  Widget _getOrderCard() {
    return _getCardLayout(
      title: 'Данные заказа',
      body: _orderOptions != null
        ? Column(
            children: [
              _getEntryText('ID заказа', _orderOptions.orderId, required: true),
              _getEntryText('Заголовок', _orderOptions.title, required: true),
              _getEntryText('Описание', _orderOptions.description, required: true),
              _getEntryText('Сумма (в копейках)', _orderOptions.amount),
              if (_orderOptions.reccurentPayment) _getEntryText('ID родительского платежа', _orderOptions.parentPaymentId, required: true),
              _getEntryText('Рекуррентный платеж', _orderOptions.reccurentPayment)
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
              _getEntryText('ID', _customerOptions.customerKey, required: true),
              _getEntryText('E-mail', _customerOptions.email),
              _getEntryText('Тип проверки карты', _customerOptions.checkType)
            ],
          )
        : Text('Нажмите чтобы заполнить'),
      onTap: _showCustomerOptionsDialog
    );
  }

  Widget _getFeatureCard() {
    return _getCardLayout(
      title: 'Настройки экрана',
      body: Column(
        children: [
          _getEntryText('СБП включено', _featuresOptions.sbpEnabled),
          _getEntryText('Безопасная клавиатура', _featuresOptions.useSecureKeyboard),
          _getEntryText('Сканер карт включён', _featuresOptions.enableCameraCardScanner),
          _getEntryText('Обработка ошибок', _featuresOptions.handleCardListErrorInSdk),
          _getEntryText('Темная тема', _featuresOptions.darkThemeMode),
        ],
      ),
      onTap: _showFeatureOptionsDialog
    );
  }

  Widget _getPaymentAction() {
    return RaisedButton(
      onPressed: _orderOptions != null
        ? () {
            acquiring.openPaymentScreen(
                orderOptions: _orderOptions,
                customerOptions: _customerOptions,
                featuresOptions: _featuresOptions
            )
            .then((value) => print(value ? 'PaymentSuccess' : 'PaymentErrorOrCancel'))
            .catchError(_showErrorDialog);
          }
        : null,
      child: Text('Тестовая оплата'),
    );
  }

  Widget _getTextForm(
    String hint,
    TextEditingController controller, {
      TextInputType keyboardType,
      bool isDialog = false,
    }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: isDialog ? 0.0 : 24.0
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
          alignLabelWithHint: true
        ),
      ),
    );
  }

  Widget _getEntryText(String key, dynamic value, {bool required = false}) {
    final canShow = (value != null && value is! String) || (value is String && value.isNotEmpty);
    return Row(
      children: [
        Text(key),
        Spacer(),
        Text(
          canShow
            ? value.toString()
            : 'не указано',
          style: TextStyle(
            fontSize: 12.0,
            color: canShow ? Colors.black : Colors.grey
          ),
        ),
        if (!canShow && required) Icon(Icons.warning, color: Colors.red, size: 14.0)
      ],
    );
  }

  Widget _getCardLayout({
    @required String title,
    @required Widget body,
    VoidCallback onTap
  }) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 24.0
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 4.0),
              body
            ],
          ),
        ),
      ),
    );
  }

  String _emptyStringToNull(String text) {
    if (text.isEmpty)
      return null;
    else
      return text;
  }

  Future<Null> _showErrorDialog(error) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text(error.toString()),
          actions: [
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            )
          ],
        )
    );
  }

  void _showOrderOptionsDialog() async {
    final orderIdController = TextEditingController(text: _orderOptions?.orderId?.toString() ?? '');
    final titleController = TextEditingController(text: _orderOptions?.title ?? '');
    final descriptionController = TextEditingController(text: _orderOptions?.description ?? '');
    final amountController = TextEditingController(text: _orderOptions?.amount?.toString() ?? '');
    final parentIdController = TextEditingController(text: _orderOptions?.parentPaymentId?.toString() ?? '');
    final ValueNotifier<bool> reccurent = ValueNotifier(_orderOptions?.reccurentPayment ?? false);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          padding: EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getTextForm(
                'ID заказа',
                orderIdController,
                keyboardType: TextInputType.number,
                isDialog: true
              ),
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
              _getTextForm(
                'Сумма (в копейках)',
                amountController, keyboardType: TextInputType.number,
                isDialog: true
              ),
              ValueListenableBuilder<bool>(
                valueListenable: reccurent,
                builder: (context, value, child) => value ? child : SizedBox(),
                child: _getTextForm(
                  'ID родительского платежа',
                  parentIdController,
                  keyboardType: TextInputType.number,
                  isDialog: true
                )
              ),
              _getCheckboxRow('Рекуррентный платеж', reccurent),
            ],
          ),
        ),
      )
    );
    final orderId = _emptyStringToNull(orderIdController.text);
    final parentId = _emptyStringToNull(parentIdController.text);
    setState(() {
      _orderOptions = OrderOptions(
        orderId: orderId != null ? int.tryParse(orderId) : null,
        amount: int.tryParse(amountController.text),
        title: titleController.text,
        description: descriptionController.text,
        parentPaymentId: parentId != null ? int.tryParse(parentId) : null,
        reccurentPayment: reccurent.value,
      );
    });
  }

  void _showCustomerOptionsDialog() async {
    final idController = TextEditingController(text: _customerOptions?.customerKey ?? '');
    final emailController = TextEditingController(text: _customerOptions?.email ?? '');
    final checkType = ValueNotifier<CheckType>(_customerOptions?.checkType ?? CheckType.no);

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            padding: EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getTextForm(
                  'ID',
                  idController,
                  isDialog: true
                ),
                _getTextForm(
                  'E-mail',
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                  isDialog: true
                ),
                Row(
                  children: <Widget>[
                    Text('Тип проверки'),
                    Spacer(),
                    ValueListenableBuilder(
                      valueListenable: checkType,
                      builder: (context, value, _) => DropdownButton<CheckType>(
                        value: value,
                        items: [
                          DropdownMenuItem(
                            value: CheckType.no,
                            child: Text('NO'),
                          ),
                          DropdownMenuItem(
                            value: CheckType.hold,
                            child: Text('HOLD')
                          ),
                          DropdownMenuItem(
                            value: CheckType.threeDS,
                            child: Text('3DS')
                          ),
                          DropdownMenuItem(
                            value: CheckType.threeDS_hold,
                            child: Text('3DS_HOLD')
                          )
                        ],
                        onChanged: (value) {
                          checkType.value = value;
                        }
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
    setState(() {
      _customerOptions = CustomerOptions(
        customerKey: _emptyStringToNull(idController.text),
        email: _emptyStringToNull(emailController.text),
        checkType: checkType.value
      );
    });
  }

  void _showFeatureOptionsDialog() async {
    final sbp = ValueNotifier<bool>(_featuresOptions.sbpEnabled);
    final secureKeyboard = ValueNotifier<bool>(_featuresOptions.useSecureKeyboard);
    final scanner = ValueNotifier<bool>(_featuresOptions.enableCameraCardScanner);
    final errorHandle = ValueNotifier<bool>(_featuresOptions.handleCardListErrorInSdk);
    final darkTheme = ValueNotifier<DarkThemeMode>(_featuresOptions.darkThemeMode);

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            padding: EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getCheckboxRow('СБП', sbp),
                _getCheckboxRow('Безопасная клавиатура', secureKeyboard),
                _getCheckboxRow('Сканнер карт', scanner),
                _getCheckboxRow('Обработка ошибок', errorHandle),
                Row(
                  children: <Widget>[
                    Text('Темная тема'),
                    Spacer(),
                    ValueListenableBuilder(
                      valueListenable: darkTheme,
                      builder: (context, value, _) => DropdownButton<DarkThemeMode>(
                          value: value,
                          items: [
                            DropdownMenuItem(
                              value: DarkThemeMode.auto,
                              child: Text('AUTO'),
                            ),
                            DropdownMenuItem(
                                value: DarkThemeMode.enabled,
                                child: Text('ENABLED')
                            ),
                            DropdownMenuItem(
                                value: DarkThemeMode.disabled,
                                child: Text('DISABLED')
                            )
                          ],
                          onChanged: (value) {
                            darkTheme.value = value;
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
    setState(() {
      _featuresOptions = FeaturesOptions(
        sbpEnabled: sbp.value,
        useSecureKeyboard: secureKeyboard.value,
        enableCameraCardScanner: scanner.value,
        handleCardListErrorInSdk: errorHandle.value,
        darkThemeMode: darkTheme.value,
      );
    });
  }

  Widget _getCheckboxRow(String title, ValueNotifier valueListenable) {
    return Row(
      children: <Widget>[
        Text(title),
        Spacer(),
        ValueListenableBuilder(
          valueListenable: valueListenable,
          builder: (context, value, _) => Checkbox(
            value: value,
            onChanged: (value) => valueListenable.value = value
          ),
        ),
      ],
    );
  }

  Widget _getCardAttachAction() {
    return IconButton(
      icon: Icon(Icons.credit_card),
      onPressed: () async {
        await acquiring.openAttachCardScreen(
          customerOptions: _customerOptions,
          featuresOptions: _featuresOptions
        );
      },
    );
  }

  Widget _getSBPShowQRAction() {
    return IconButton(
      icon: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(Icons.apps),
          Icon(Icons.camera_alt, size: 7.0, color: Colors.grey)
        ],
      ),
      onPressed: null /*() async {
        await acquiring.showSBPQrScreen();
      },*/
    );
  }
}
