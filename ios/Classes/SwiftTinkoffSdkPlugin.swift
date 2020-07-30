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

import Flutter
import UIKit

import TinkoffASDKUI
import TinkoffASDKCore

public class SwiftTinkoffSdkPlugin: NSObject, FlutterPlugin {
    private var acquiring: AcquiringUISDK!
    private var language: String!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tinkoff_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftTinkoffSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "activate":
            handleActivate(call, result: result)
            break
        case "openPaymentScreen":
            handleOpenPaymentScreen(call, result: result)
            break;
        case "attachCardScreen":
            handleAttachCardScreen(call, result: result);
            break;
        case "showQrScreen":
            handleShowQrScreen(call, result: result);
            break;
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleActivate(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let terminalKey = args!["terminalKey"] as! String
        let password = args!["password"] as! String
        let publicKey = args!["publicKey"] as! String
        let logging = args!["isDebug"] as! Bool
        let isDeveloperMode = args!["isDeveloperMode"] as! Bool
        
        self.language = (args!["language"] as! String).lowercased()
        
        let credential = AcquiringSdkCredential(
            terminalKey: terminalKey,
            password: password,
            publicKey: publicKey
        )
        
        let server = isDeveloperMode
            ? AcquiringSdkEnvironment.test
            : AcquiringSdkEnvironment.prod
        
        let configuration = AcquiringSdkConfiguration(
            credential: credential,
            server: server
        )
        
        if (logging) {
            configuration.logger = AcquiringLoggerDefault()
        }
        configuration.showErrorAlert = isDeveloperMode
        configuration.fpsEnabled = true
        
        if let sdk = try? AcquiringUISDK.init(
            configuration: configuration
        ) {
            self.acquiring = sdk
            result(true)
        } else {
            result(false)
        }
    }
    
    private func handleOpenPaymentScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let orderOprionsArgs = args!["orderOptions"] as? Dictionary<String, Any>
        let orderId = orderOprionsArgs!["orderId"] as! Int64
        let coins = orderOprionsArgs!["amount"] as! Int64
        let title = orderOprionsArgs!["title"] as! String
        let description = orderOprionsArgs!["description"] as! String
        let reccurentPayment = orderOprionsArgs!["reccurentPayment"] as! Bool
        
        let customerOprionsArgs = args!["customerOptions"] as? Dictionary<String, Any>
        let customerKey = customerOprionsArgs?["customerKey"] as! String
        let email = customerOprionsArgs?["email"] as? String
        let checkType = customerOprionsArgs!["checkType"] as! String
        
        let featuresOprionsArgs = args!["featuresOptions"] as? Dictionary<String, Any>
        let fpsEnabled = featuresOprionsArgs!["fpsEnabled"] as! Bool
        let cameraCardScannerEnabled = featuresOprionsArgs!["enableCameraCardScanner"] as! Bool
        
//        let useSecureKeyboard = featuresOprionsArgs!["useSecureKeyboard"] as! Bool
//        let darkThemeMode = featuresOprionsArgs!["darkThemeMode"] as! String
        
        let paymentData = PaymentInitData(
            amount: coins,
            orderId: orderId,
            customerKey: customerKey
        )
        
        let viewConfiguration = getViewConfiguration(
            enableCardScanner: cameraCardScannerEnabled,
            title: title,
            description: description,
            amount: coins,
            enableSPB: fpsEnabled,
            email: email
        )
        
        let topViewController : UIViewController = Utils.getView()
        
        
        if reccurentPayment {
            let parentPaymentId = orderOprionsArgs!["parentPaymentId"] as! Int64

            self.acquiring.presentPaymentView(
                on: topViewController,
                paymentData: paymentData,
                parentPatmentId: parentPaymentId,
                configuration: viewConfiguration,
                completionHandler: setPaymentHandler(flutterResult: result)!
            )
        } else {
            self.acquiring.presentPaymentView(
                on: topViewController,
                paymentData: paymentData,
                configuration: viewConfiguration,
                completionHandler: setPaymentHandler(flutterResult: result)!
            )
        }
                
        acquiring.addCardNeedSetCheckTypeHandler = {
            return PaymentCardCheckType.init(rawValue: checkType)
        }
    }
    
    private func handleAttachCardScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let customerOprionsArgs = args!["customerOptions"] as? Dictionary<String, Any>
        let customerKey = customerOprionsArgs?["customerKey"] as! String
        let checkType = customerOprionsArgs!["checkType"] as! String
        
        let featuresOprionsArgs = args!["featuresOptions"] as? Dictionary<String, Any>
        let cameraCardScannerEnabled = featuresOprionsArgs!["enableCameraCardScanner"] as! Bool
        //let darkThemeMode = featuresOprionsArgs!["darkThemeMode"] as! String
        
        let cardListViewConfigration = AcquiringViewConfigration.init()
        cardListViewConfigration.viewTitle = NSLocalizedString("title.paymentCardList", comment: "Список карт")
        
        if (cameraCardScannerEnabled) {
            cardListViewConfigration.scaner = self
        }

        cardListViewConfigration.localizableInfo = AcquiringViewConfigration.LocalizableInfo.init(lang: self.language)
        
        self.acquiring.presentCardList(
            on: Utils.getView(),
            customerKey: customerKey,
            configuration: cardListViewConfigration
        )
        acquiring.addCardNeedSetCheckTypeHandler = {
            return PaymentCardCheckType.init(rawValue: checkType)
        }
        
        result(nil)
    }
    
    private func handleShowQrScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        result(nil)
    }
    
    ///
    private func getViewConfiguration(
        enableCardScanner: Bool,
        title: String,
        description: String,
        amount: Int64,
        enableSPB: Bool,
        email: String?
    ) -> AcquiringViewConfigration {
        //!TODO: Локализация экрана оплаты
        
        let viewConfigration = AcquiringViewConfigration.init()
        if (enableCardScanner) {
            viewConfigration.scaner = self
        }
        
        viewConfigration.viewTitle = "Оплата"
        
        viewConfigration.fields = []
        // InfoFields.amount
        let paymentTitle = NSAttributedString.init(
            string: "Оплата",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 22)
            ]
        )
        let amountString = Utils.formatAmount(NSDecimalNumber.init(floatLiteral: Double(amount)/100))
        let amountTitle = NSAttributedString.init(
            string: "на сумму \(amountString)",
            attributes: [
                .font : UIFont.systemFont(ofSize: 17)
            ]
        )
        
        // Добавление заголовка
        viewConfigration.fields.append(
            AcquiringViewConfigration.InfoFields.amount(
                title: paymentTitle,
                amount: amountTitle
            )
        )
        
        let productDetail = NSMutableAttributedString.init()
        let titleString = NSAttributedString.init(
            string: title + "\n",
            attributes: [
                .font : UIFont.systemFont(ofSize: 17)
            ]
        )
        let descriptionString = NSAttributedString.init(
            string: description,
            attributes: [
                .font : UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor(red: 0.573, green: 0.6, blue: 0.635, alpha: 1)
            ]
        )
        
        productDetail.append(titleString)
        productDetail.append(descriptionString)
        
        /// Добавление поля для описания покупки
        viewConfigration.fields.append(
            AcquiringViewConfigration.InfoFields.detail(
                title: productDetail
            )
        )
        
        /// Добавление поля для ввода E-mail адреса
        viewConfigration.fields.append(
            AcquiringViewConfigration.InfoFields.email(
                value: email,
                placeholder: "E-mail для получения квитанции"
            )
        )
        
        /// Добавление кнопки "Оплатить с помощью СПБ"
        if (enableSPB) {
            viewConfigration.fields.append(AcquiringViewConfigration.InfoFields.buttonPaySPB)
        }
        
        viewConfigration.localizableInfo = AcquiringViewConfigration.LocalizableInfo.init(lang: language.lowercased())
        viewConfigration.alertViewHelper = nil
        
        return viewConfigration
    }
    
    private func setPaymentHandler(flutterResult: @escaping FlutterResult) -> PaymentCompletionHandler? {
        let handler: PaymentCompletionHandler? = {[weak self] (response) in self?.responseReviewing(response, flutterResult: flutterResult)}
        return handler
    }
    
    private func responseReviewing(_ response: Result<PaymentStatusResponse, Error>, flutterResult: @escaping FlutterResult) {
        switch response {
        case .success(let result):
            flutterResult(result.status != .cancelled)
        case .failure(_):
            flutterResult(false)
        }
    }
}

extension SwiftTinkoffSdkPlugin: AcquiringAlertViewProtocol {
    public func presentAlertView(_ title: String?, message: String?, dismissCompletion: (() -> Void)?) -> UIViewController? {
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            dismissCompletion?()
        }))
        
        return alertView
    }
}

extension SwiftTinkoffSdkPlugin: AcquiringScanerProtocol {
    public func presentScanner(completion: @escaping (_ number: String?, _ yy: Int?, _ mm: Int?) -> Void) -> UIViewController? {
        if let viewController = UIStoryboard.init(name: "Tinkoff", bundle: Bundle.init(for: TinkoffSDKCardScanner.self))
            .instantiateViewController(withIdentifier: "TinkoffSDKCardScanner") as? TinkoffSDKCardScanner {
            viewController.onScannerResult = { (numbres) in
                completion(numbres, nil, nil)
            }
            
            return viewController
        }
        
        return nil
    }
    
}
