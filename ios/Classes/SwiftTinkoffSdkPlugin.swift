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

import Flutter
import UIKit

import TinkoffASDKUI
import TinkoffASDKCore
import ThreeDSWrapper

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
        case "showStaticQrScreen":
            handleShowStaticQrScreen(call, result: result)
            break
        case "showDynamicQrScreen":
            handleShowDynamicQrScreen(call, result: result)
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
        let publicKey = args!["publicKey"] as! String
        let isDeveloperMode = args!["isDeveloperMode"] as! Bool
        let logging = args!["logging"] as! Bool
        
        let credential = AcquiringSdkCredential(
            terminalKey: terminalKey,
            publicKey: publicKey
        )
        
        let coreSDKconfiguration = AcquiringSdkConfiguration(
            credential: credential,
            server: isDeveloperMode
                ? AcquiringSdkEnvironment.test
                : AcquiringSdkEnvironment.prod,
            logger: logging ? Logger() : nil
        )

        let uiSDKConfiguration = UISDKConfiguration()

        do {
            self.acquiring = try AcquiringUISDK(
                coreSDKConfiguration: coreSDKconfiguration,
                uiSDKConfiguration: uiSDKConfiguration
            )
            result(true)
        } catch {
            result(false)
        }
        awaitingResult = false
    }
    
    private func handleCardList(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        let customerKey = (args!["customerOptions"] as! Dictionary<String, Any>)["customerKey"] as! String
        
        let view = Utils.getView()
        acquiring.presentCardList(
            on: view,
            customerKey: customerKey,
            addCardOptions: AddCardOptions(attachCardData: AdditionalData.empty())
        )
    }
    
    private func handleOpenPaymentScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let orderOptionsArgs = args!["orderOptions"] as! Dictionary<String, Any>
        let orderOptions = Utils.parseOrderOptions(args: orderOptionsArgs, ffdVersion: args!["ffdVersion"] as! String)
        
        let customerOptions = Utils.parseCustomerOptions(args: args!["customerOptions"] as? Dictionary<String, Any>)
        
        let view = Utils.getView()
        let paymentFlow = PaymentFlow.full(
            paymentOptions: PaymentOptions(
                orderOptions: orderOptions,
                customerOptions: customerOptions
            )
        )
        let viewConfiguration = MainFormUIConfiguration.init(orderDescription: orderOptions.description)
        
        self.acquiring.presentMainForm(
            on: view,
            paymentFlow: paymentFlow,
            configuration: viewConfiguration,
            completion: setPaymentHandler(view, flutterResult: result)
        )
    }
    
    private func handleAttachCardScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        let customerOptionsArgs = args!["customerOptions"] as? Dictionary<String, Any>
        let customerKey = customerOptionsArgs?["customerKey"] as! String
        
        let controller = Utils.getView()
        self.acquiring.presentAddCard(
            on: controller,
            customerKey: customerKey,
            addCardOptions: AddCardOptions(attachCardData: AdditionalData.empty())
        )

        checkForDismiss(controller, result: result)
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
    
    private func handleShowStaticQrScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let view = Utils.getView()
        self.acquiring.presentStaticSBPQR(on: view)
        awaitingResult = false
    }
    
    private func handleShowDynamicQrScreen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        let paymentFlow = args?["paymentFlow"] as! String
        let orderOptions = args?["orderOptions"] == nil ? nil : Utils.parseOrderOptions(args: args?["orderOptions"] as! Dictionary<String, Any>, ffdVersion: args?["ffdVersion"] as! String)
        let customerOptions = Utils.parseCustomerOptions(args: args?["customerOptions"] as? Dictionary<String, Any>)
        let paymentId = args?["paymentId"] as? String
        let amount = args?["amount"] as? Int64
        let orderId = args?["orderId"] as? String
        
        let view = Utils.getView()
        
        self.acquiring.presentDynamicSBPQR(
            on: view,
            paymentFlow: Utils.parsePaymentFlow(
                paymentFlow: paymentFlow,
                orderOptions: orderOptions,
                customerOptions: customerOptions,
                paymentId: paymentId,
                amount: amount,
                orderId: orderId
            ),
            completion: setPaymentHandler(view, flutterResult: result)
        )
        
        awaitingResult = false
    }
    
    private func handleStartCharge(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //TODO: implement method
        result(FlutterMethodNotImplemented)
        awaitingResult = false
    }
    
    private func setPaymentHandler(_ view: UIViewController, flutterResult: @escaping FlutterResult) -> PaymentResultCompletion {
        return setPaymentHandler(view, flutterResult: flutterResult) {}
    }
    
    private func setPaymentHandler(_ view: UIViewController, flutterResult: @escaping FlutterResult, additional: @escaping () -> Void) -> PaymentResultCompletion {
        let handler: PaymentResultCompletion = {[weak self] (response) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if (view.presentedViewController == nil) {
                    self?.responseReviewing(response, flutterResult: flutterResult)
                    additional()
                }
            }

        }
        return handler
    }

    private func responseReviewing(_ response: PaymentResult,flutterResult: FlutterResult) {
        var map = Dictionary<String, Any>()
        switch response {
        case .succeeded(let result):
            let success = result.paymentStatus != .cancelled
            map["success"] = success
            map["isError"] = false
            map["message"] = result.paymentStatus.rawValue
        case .failed(let result):
            map["success"] = false
            map["isError"] = true
            map["message"] = result.localizedDescription.split(separator: "(").last?.split(separator: ".").first
        case .cancelled(let result):
            let success = result?.paymentStatus == .cancelled
            map["success"] = success
            map["isError"] = false
            map["message"] = result?.paymentStatus.rawValue ?? "Cancelled"
        }
        
        flutterResult(Utils.prepareJson(map))
        awaitingResult = false
    }
}

extension SwiftTinkoffSdkPlugin: ICardScannerDelegate {
    public func cardScanButtonDidPressed(on viewController: UIViewController, completion: @escaping TinkoffASDKUI.CardScannerCompletion) {
    }
    
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
    
    public func presentAlertView(_ title: String?, message: String?, dismissCompletion: (() -> Void)?) -> UIViewController? {
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            dismissCompletion?()
        }))
        
        return alertView
    }

    
}
