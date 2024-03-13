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

import TinkoffASDKUI
import TinkoffASDKCore

class Utils {
    private static var language: String!
    private static let amountFormatter = NumberFormatter()
    
    static func formatAmount(_ value: NSDecimalNumber, fractionDigits: Int = 2, currency: String = "₽") -> String {
        amountFormatter.usesGroupingSeparator = true
        amountFormatter.groupingSize = 3
        amountFormatter.groupingSeparator = " "
        amountFormatter.alwaysShowsDecimalSeparator = false
        amountFormatter.decimalSeparator = ","
        amountFormatter.minimumFractionDigits = 0
        amountFormatter.maximumFractionDigits = fractionDigits
        
        return "\(amountFormatter.string(from: value) ?? "\(value)") \(currency)"
    }
    
    static func getView(_ navigator: Bool = false) -> UIViewController {
        var topController: UIViewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.rootViewController!
        
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        
        if navigator {
            let view = UINavigationController()
            view.navigationBar.backgroundColor = UIColor.white
            view.isNavigationBarHidden = true
            view.addChild(UIViewController())
            topController.present(view, animated: true, completion: nil)
            return view
        } else {
            return topController
        }
    }
    
    static func prepareJson(_ dictionary: Dictionary<String, Any>) -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        let json = String(data: jsonData!, encoding: .utf8)
        return json
    }
    
    static func parseTaxation(_ taxation: String?) -> Taxation {
        switch (taxation) {
        case "usn_income":
            return Taxation.usnIncome
        case "usn_income_outcome":
            return Taxation.usnIncomeOutcome
        case "patent":
            return Taxation.patent
        case "envd":
            return Taxation.envd
        case "esn":
            return Taxation.esn
        case "osn":
            return Taxation.osn
        default:
            return Taxation.osn
        }
    }
    
    static func parseTax(_ tax: String) -> Tax {
        switch (tax) {
        case "non":
            return Tax.none
        case "vat0":
            return Tax.vat0
        case "vat10":
            return Tax.vat10
        case "vat18":
            return Tax.vat18
        case "vat20":
            return Tax.vat20
        case "vat110":
            return Tax.vat110
        case "vat118":
            return Tax.vat118
        case "vat120":
            return Tax.vat120
        default:
            return Tax.none
        }
    }
    
    static func parsePaymentObject(paymentObject: String?) -> PaymentObject? {
        switch (paymentObject) {
            case "excise": return PaymentObject.excise
            case "job": return PaymentObject.job
            case "service": return PaymentObject.service
            case "gamblingBet": return PaymentObject.gamblingBet
            case "gamblingPrize": return PaymentObject.gamblingPrize
            case "lottery": return PaymentObject.lottery
            case "lotteryPrize": return PaymentObject.lotteryPrize
            case "intellectualActivity": return PaymentObject.intellectualActivity
            case "payment": return PaymentObject.payment
            case "agentCommission": return PaymentObject.agentCommission
            case "composite": return PaymentObject.composite
            default: return nil
        }
    }
    
    static func parsePaymentMethod(paymentMethod: String?) -> PaymentMethod? {
        switch (paymentMethod) {
            case "fullPrepayment": return PaymentMethod.fullPrepayment
            case "prepayment": return PaymentMethod.prepayment
            case "advance": return PaymentMethod.advance
            case "fullPayment": return PaymentMethod.fullPayment
            case "partialPayment": return PaymentMethod.partialPayment
            case "credit": return PaymentMethod.credit
            case "creditPayment": return PaymentMethod.creditPayment
            default: return nil
        }
    }
    
    static func parseAgentSign(agentSign: String) -> AgentSign {
        switch (agentSign) {
            case "bankPayingAgent": return AgentSign.bankPayingAgent
            case "bankPayingSubagent": return AgentSign.bankPayingSubagent
            case "payingAgent": return AgentSign.payingAgent
            case "payingSubagent": return AgentSign.payingSubagent
            case "attorney": return AgentSign.attorney
            case "commissionAgent": return AgentSign.commissionAgent
            case "another": return AgentSign.another
            default: return AgentSign.another
        }
    }
    
    static func parsePaymentFlow(paymentFlow: String, orderOptions: OrderOptions?, customerOptions: CustomerOptions?, paymentId: String?, amount: Int64?, orderId: String?) -> PaymentFlow {
        if (paymentFlow == "full") {
            return PaymentFlow.full(
                paymentOptions: PaymentOptions(
                    orderOptions: orderOptions!,
                    customerOptions: customerOptions
                )
            )
        } else {
            return PaymentFlow.finish(
                paymentOptions: FinishPaymentOptions(
                    paymentId: paymentId!,
                    amount: amount!,
                    orderId: orderId!,
                    customerOptions: customerOptions
                )
            )
        }
    }
    
    static func parseSupplierInfo(args: Dictionary<String, Any>?) -> SupplierInfo? {
        if (args == nil) {
            return nil
        }
        
        return SupplierInfo(
            phones: args!["phones"] as? Array<String>,
            name: args!["name"] as? String,
            inn: args!["inn"] as? String
        )
    }
    
    static func parseAgentData(args: Dictionary<String, Any>?) -> AgentData? {
        if (args == nil) {
            return nil
        }
        
        return AgentData(
            agentSign: parseAgentSign(agentSign: args!["agentSign"] as! String),
            operationName: args!["operationName"] as? String,
            phones: args!["phones"] as? Array<String>,
            receiverPhones: args!["receiverPhones"] as? Array<String>,
            transferPhones: args!["transferPhones"] as? Array<String>,
            operatorName: args!["operatorName"] as? String,
            operatorAddress: args!["operatorAddress"] as? String,
            operatorInn: args!["operatorInn"] as? String
        )
    }
    
    static func parseOrderOptions(args: Dictionary<String, Any>) -> OrderOptions {
        let orderId = args["orderId"] as! String
        let amount = args["amount"] as! Int64
        let description = args["description"] as? String
        let payType = parsePayType(payType: args["payType"] as? String)
        let receipt = args["receipt"] == nil ? nil : parseReceipt(receiptArgs: args["receipt"] as! Dictionary<String, Any>)
        let shops = (args["shops"] as? Array<Dictionary<String, Any>>)?.map({
            parseShop(args: $0)
        })
        let receipts = (args["receipts"] as? Array<Dictionary<String, Any>>)?.map({parseReceipt(receiptArgs: $0)})
        let savingAsParentPayment = args["recurrentPayment"] as? Bool ?? false
        
        return OrderOptions(
            orderId: orderId,
            amount: amount,
            description: description,
            payType: payType,
            receipt: receipt,
            shops: shops,
            receipts: receipts,
            savingAsParentPayment: savingAsParentPayment
        )
    }
    
    static func parsePayType(payType: String?) -> PayType? {
        switch (payType) {
            case "oneStage": return PayType.oneStage
            case "twoStage": return PayType.twoStage
            default: return nil
        }
    }
    
    static func parseCustomerOptions(args: Dictionary<String, Any>) -> CustomerOptions {
        let customerKey = args["customerKey"] as! String
        let email = args["email"] as? String
        
        return CustomerOptions(
            customerKey: customerKey,
            email: email
        )
    }
    
    static func parseReceipt(receiptArgs: Dictionary<String, Any>) -> Receipt {
        let shopCode = receiptArgs["shopCode"] as? String
        let email = receiptArgs["email"] as? String
        let phone = receiptArgs["phone"] as? String
        let taxation = Utils.parseTaxation(receiptArgs["taxation"] as? String)
        let items = (receiptArgs["items"] as? Array<Dictionary<String, Any>>)?.map({ parseItem(args: $0) })
        let agentData = Utils.parseAgentData(args: receiptArgs["agentData"] as? Dictionary<String, Any>)
        let supplierInfo = Utils.parseSupplierInfo(args: receiptArgs["supplierInfo"] as? Dictionary<String, Any>)
        let customer = receiptArgs["customer"] as? String
        let customerInn = receiptArgs["customerInn"] as? String
        
        return Receipt(
            shopCode: shopCode,
            email: email,
            taxation: taxation,
            phone: phone,
            items: items,
            agentData: agentData,
            supplierInfo: supplierInfo,
            customer: customer,
            customerInn: customerInn
        )
    }
    
    static func parseItem(args: Dictionary<String, Any>) -> Item {
        return Item(
            amount: args["amount"] as! Int64,
            price: args["price"] as! Int64,
            name: args["name"] as! String,
            tax: Utils.parseTax(args["tax"] as! String),
            quantity: args["quantity"] as! Double,
            paymentObject: Utils.parsePaymentObject(paymentObject: args["paymentObject"] as? String),
            paymentMethod: Utils.parsePaymentMethod(paymentMethod: args["paymentMethod"] as? String),
            ean13: args["ean13"] as? String,
            shopCode: args["shopCode"] as? String,
            measurementUnit: args["measurementUnit"] as? String,
            supplierInfo: Utils.parseSupplierInfo(args: args["supplierInfo"] as? Dictionary<String, Any>),
            agentData: Utils.parseAgentData(args: args["agentData"] as? Dictionary<String, Any>)
        )
    }
    
    static func parseShop(args: Dictionary<String, Any>) -> Shop {
        return Shop(
            shopCode: args["shopCode"] as? String,
            name: args["name"] as? String,
            amount: args["amount"] as? Int64,
            fee: args["fee"] as? String
        )
    }
}
