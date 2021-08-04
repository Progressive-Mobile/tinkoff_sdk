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
    private var sdk: AcquiringSdk!
    private var awaitingResult: Bool!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tinkoff_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftTinkoffSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        awaitingResult = true
        switch call.method {
        case "activate":
            handleActivate(call, result: result)
            break
        case "cardList":
            handleCardList(call, result: result)
            break
        case "openPaymentScreen":
            handleOpenPaymentScreen(call, result: result)
            break
        case "attachCardScreen":
            handleAttachCardScreen(call, result: result)
            break
        case "showQrScreen":
            handleShowQrScreen(call, result: result)
            break
        case "isNativePayAvailable":
            handleIsNativePayAvailable(call, result: result)
            break
        case "openNativePayment":
            handleOpenNativePayment(call, result: result)
            break
        case "startCharge":
            handleStartCharge(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
            awaitingResult = false
        }
    }
    
    private func handleActivate(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let terminalKey = args!["terminalKey"] as! String
        let password = args!["password"] as! String
        let publicKey = args!["publicKey"] as! String
        let logging = args!["isDebug"] as! Bool
        let isDeveloperMode = args!["isDeveloperMode"] as! Bool
        
        Utils.setLanguage((args!["language"] as! String).lowercased())
        
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
            self.sdk = try! AcquiringSdk.init(configuration: configuration)
            result(true)
        } else {
            result(false)
        }
        awaitingResult = false
    }
    
    private func handleCardList(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        let customerKey = args!["customerKey"] as! String
        
        let provider = CardListDataProvider.init(sdk: sdk, customerKey: customerKey)
        
        var cardList = [] as [String?]

        provider.fetch(startHandler: nil) { (cards, _) in
            if cards != nil {
                let cardsAmount = cards!.count
                if (cardsAmount > 0) {
                    for index in 0...cardsAmount-1 {
                        var map = Dictionary<String, Any>()
                        let card = provider.item(at: index)
                        map["cardId"] = card.cardId
                        map["pan"] = card.pan
                        map["expDate"] = card.expDate
                        cardList.append(Utils.prepareJson(map))
                    }
                }
            }
            
            result(cardList)
            self.awaitingResult = false
        }
    }
    
    private func handleOpenPaymentScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let orderOptionsArgs = args!["orderOptions"] as? Dictionary<String, Any>
        let orderId = orderOptionsArgs!["orderId"] as! String
        let coins = orderOptionsArgs!["amount"] as! Int64
        let title = orderOptionsArgs!["title"] as! String
        let description = orderOptionsArgs!["description"] as! String
        let reccurentPayment = orderOptionsArgs!["reccurentPayment"] as! Bool
        
        let customerOptionsArgs = args!["customerOptions"] as? Dictionary<String, Any>
        let customerKey = customerOptionsArgs?["customerKey"] as! String
        let email = customerOptionsArgs?["email"] as? String
        let checkType = customerOptionsArgs!["checkType"] as! String
        
        let featuresOptionsArgs = args!["featuresOptions"] as? Dictionary<String, Any>
        let fpsEnabled = featuresOptionsArgs!["fpsEnabled"] as! Bool
        let cameraCardScannerEnabled = featuresOptionsArgs!["enableCameraCardScanner"] as! Bool
        
//        let useSecureKeyboard = featuresOptionsArgs!["useSecureKeyboard"] as! Bool
//        let darkThemeMode = featuresOptionsArgs!["darkThemeMode"] as! String
        
        var paymentData = PaymentInitData(
            amount: coins,
            orderId: orderId,
            customerKey: customerKey
        )
        paymentData.description = description
        paymentData.savingAsParentPayment = reccurentPayment
        if (reccurentPayment) {
            paymentData.payType = .twoStage
        }
        
        let viewConfiguration = Utils.getViewConfiguration(
            title: title,
            description: description,
            amount: coins,
            enableSPB: fpsEnabled,
            email: email
        )
        viewConfiguration.localizableInfo = Utils.getLanguage()
        
        if cameraCardScannerEnabled {
            viewConfiguration.scaner = self
        }
        
        let view = Utils.getView()
        
        self.acquiring.presentPaymentView(
            on: view,
            paymentData: paymentData,
            configuration: viewConfiguration,
            completionHandler: setPaymentHandler(view, flutterResult: result)
        )

        acquiring.addCardNeedSetCheckTypeHandler = {
            return PaymentCardCheckType.init(rawValue: checkType)
        }
    }
    
    private func handleAttachCardScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let customerOptionsArgs = args!["customerOptions"] as? Dictionary<String, Any>
        let customerKey = customerOptionsArgs?["customerKey"] as! String
        let checkType = customerOptionsArgs!["checkType"] as! String
        
        let featuresOptionsArgs = args!["featuresOptions"] as? Dictionary<String, Any>
        let cameraCardScannerEnabled = featuresOptionsArgs!["enableCameraCardScanner"] as! Bool
        //let darkThemeMode = featuresOptionsArgs!["darkThemeMode"] as! String
        
        let cardListViewConfiguration = AcquiringViewConfiguration.init()
        
        if (cameraCardScannerEnabled) {
            cardListViewConfiguration.scaner = self
        }

        cardListViewConfiguration.localizableInfo = Utils.getLanguage()
        let controller = Utils.getView()
        self.acquiring.presentCardList(
            on: controller,
            customerKey: customerKey,
            configuration: cardListViewConfiguration
        )

        checkForDismiss(controller, result: result)

        acquiring.addCardNeedSetCheckTypeHandler = {
            return PaymentCardCheckType.init(rawValue: checkType)
        }
    }
    
    private func checkForDismiss(_ controller: UIViewController, result: @escaping FlutterResult) {
        let showing = controller.presentedViewController != nil
        
        if (showing) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkForDismiss(controller, result: result)
            }
        } else {
            result(nil)
            awaitingResult = false
        }
    }
    
    private func handleShowQrScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //TODO: implement method
        result(FlutterMethodNotImplemented)
        awaitingResult = false
    }
    
    private func handleIsNativePayAvailable(_ call: FlutterMethodCall, result: FlutterResult) {
        let canMakePayments = acquiring?.canMakePaymentsApplePay(with: .init()) ?? false
        result(canMakePayments)
        awaitingResult = false
    }
    
    private func handleOpenNativePayment(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let orderOptionsArgs = args!["orderOptions"] as? Dictionary<String, Any>
        let orderId = orderOptionsArgs!["orderId"] as! String
        let coins = orderOptionsArgs!["amount"] as! Int64
        let title = orderOptionsArgs!["title"] as! String
        let description = orderOptionsArgs!["description"] as! String
        let reccurentPayment = orderOptionsArgs!["reccurentPayment"] as! Bool
        
        let customerOptionsArgs = args!["customerOptions"] as? Dictionary<String, Any>
        let customerKey = customerOptionsArgs?["customerKey"] as! String
        let email = customerOptionsArgs?["email"] as? String
        
        var paymentData = PaymentInitData(
            amount: coins,
            orderId: orderId,
            customerKey: customerKey
        )
        paymentData.description = description
        paymentData.savingAsParentPayment = reccurentPayment
        if (reccurentPayment) {
            paymentData.payType = .twoStage
        }
        
        let viewConfiguration = Utils.getViewConfiguration(
            title: title,
            description: description,
            amount: coins,
            email: email
        )
        viewConfiguration.localizableInfo = Utils.getLanguage()
        
        let view = Utils.getView()
        
        self.acquiring.presentPaymentApplePay(on: view,
                                              paymentData: paymentData,
                                              viewConfiguration: viewConfiguration,
                                              paymentConfiguration: .init(),
                                              completionHandler: setPaymentHandler(view, flutterResult: result))
    }
    
    private func handleStartCharge(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //TODO: implement method
        result(FlutterMethodNotImplemented)
        awaitingResult = false
    }
    
    private func setPaymentHandler(_ view: UIViewController, flutterResult: @escaping FlutterResult) -> PaymentCompletionHandler {
        return setPaymentHandler(view, flutterResult: flutterResult) {}
    }
    
    private func setPaymentHandler(_ view: UIViewController, flutterResult: @escaping FlutterResult, additional: @escaping () -> Void) -> PaymentCompletionHandler {
        let handler: PaymentCompletionHandler = {[weak self] (response) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if (view.presentedViewController == nil) {
                    self?.responseReviewing(response, flutterResult: flutterResult)
                    additional()
                }
            }
        }
        return handler
    }

    private func responseReviewing(_ response: Result<PaymentStatusResponse, Error>,
                                   flutterResult: FlutterResult) {
        var map = Dictionary<String, Any>()
        switch response {
        case .success(let result):
            let success = result.status != .cancelled
            map["success"] = success
            map["isError"] = false
            map["message"] = result.status.rawValue
        case .failure(let result):
            map["success"] = false
            map["isError"] = true
            map["message"] = result.localizedDescription.split(separator: "(").last?.split(separator: ".").first
        }
        
        flutterResult(Utils.prepareJson(map))
        awaitingResult = false
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
