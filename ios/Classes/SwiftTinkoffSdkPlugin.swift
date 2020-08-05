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
            break
        case "attachCardScreen":
            handleAttachCardScreen(call, result: result);
            break
        case "showQrScreen":
            handleShowQrScreen(call, result: result);
            break
        case "openNativePayment":
            handleOpenNativePayment(call, result: result);
            break
        case "startCharge":
            handleStartCharge(call, result: result);
            break
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
        
        var paymentData = PaymentInitData(
            amount: coins,
            orderId: orderId,
            customerKey: customerKey
        )
        paymentData.savingAsParentPayment = reccurentPayment
        
        let viewConfiguration = Utils.getViewConfiguration(
            title: title,
            description: description,
            amount: coins,
            enableSPB: fpsEnabled,
            email: email
        )
        
        if cameraCardScannerEnabled {
            viewConfiguration.scaner = self
        }
        
        let view = Utils.getView();
        
        self.acquiring.presentPaymentView(
            on: view,
            paymentData: paymentData,
            configuration: viewConfiguration,
            completionHandler: setPaymentHandler(flutterResult: result) {
                view.dismiss(animated: true, completion: nil)
            }!
        )
                
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

        cardListViewConfigration.localizableInfo = Utils.getLanguage()
        
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
        //TODO: implement method
        result(FlutterMethodNotImplemented)
    }
    
    private func handleOpenNativePayment(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //TODO: implement method
        result(FlutterMethodNotImplemented)
    }
    
    private func handleStartCharge(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //TODO: implement method
        result(FlutterMethodNotImplemented)
    }
    
    private func setPaymentHandler(flutterResult: @escaping FlutterResult) -> PaymentCompletionHandler? {
        let handler: PaymentCompletionHandler? = {[weak self] (response) in self?.responseReviewing(response, flutterResult: flutterResult)}
        return handler
    }
    
    private func setPaymentHandler(flutterResult: @escaping FlutterResult, additional: @escaping () -> Void) -> PaymentCompletionHandler? {
        let handler: PaymentCompletionHandler? = {
            [weak self] (response) in self?.responseReviewing(response, flutterResult: flutterResult)
            additional()
        }
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
