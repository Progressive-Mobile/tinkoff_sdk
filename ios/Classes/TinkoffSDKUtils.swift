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

import TinkoffASDKCore
import TinkoffASDKUI

class Utils {
    private static var language: String!
    private static let amountFormatter = NumberFormatter()
    
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
        case "none":
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
    
    static func parsePaymentObject105(paymentObject: String?) -> PaymentObject_v1_05 {
        switch (paymentObject) {
            case "excise": return PaymentObject_v1_05.excise
            case "job": return PaymentObject_v1_05.job
            case "service": return PaymentObject_v1_05.service
            case "gamblingBet": return PaymentObject_v1_05.gamblingBet
            case "gamblingPrize": return PaymentObject_v1_05.gamblingPrize
            case "lottery": return PaymentObject_v1_05.lottery
            case "lotteryPrize": return PaymentObject_v1_05.lotteryPrize
            case "intellectualActivity": return PaymentObject_v1_05.intellectualActivity
            case "payment": return PaymentObject_v1_05.payment
            case "agentCommission": return PaymentObject_v1_05.agentCommission
            case "composite": return PaymentObject_v1_05.composite
            case "another": return PaymentObject_v1_05.another
            default: return PaymentObject_v1_05.another
        }
    }
    
    static func parsePaymentObject12(paymentObject: String?) -> PaymentObject_v1_2 {
        switch (paymentObject) {
            case "commodity": return PaymentObject_v1_2.commodity
            case "excise": return PaymentObject_v1_2.excise
            case "job": return PaymentObject_v1_2.job
            case "service": return PaymentObject_v1_2.service
            case "gamblingBet": return PaymentObject_v1_2.gamblingBet
            case "gamblingPrize": return PaymentObject_v1_2.gamblingPrize
            case "lottery": return PaymentObject_v1_2.lottery
            case "lotteryPrize": return PaymentObject_v1_2.lotteryPrize
            case "intellectualActivity": return PaymentObject_v1_2.intellectualActivity
            case "payment": return PaymentObject_v1_2.payment
            case "agentCommission": return PaymentObject_v1_2.agentCommission
            case "contribution": return PaymentObject_v1_2.contribution
            case "propertyRights": return PaymentObject_v1_2.propertyRights
            case "unrealization": return PaymentObject_v1_2.unrealization
            case "taxReduction": return PaymentObject_v1_2.taxReduction
            case "tradeFee": return PaymentObject_v1_2.tradeFee
            case "resortTax": return PaymentObject_v1_2.resortTax
            case "pledge": return PaymentObject_v1_2.pledge
            case "incomeDecrease": return PaymentObject_v1_2.incomeDecrease
            case "iePensionInsuranceWithoutPayments": return PaymentObject_v1_2.iePensionInsuranceWithoutPayments
            case "iePensionInsuranceWithPayments": return PaymentObject_v1_2.iePensionInsuranceWithPayments
            case "ieMedicalInsuranceWithoutPayments": return PaymentObject_v1_2.ieMedicalInsuranceWithoutPayments
            case "ieMedicalInsuranceWithPayments": return PaymentObject_v1_2.ieMedicalInsuranceWithPayments
            case "socialInsurance": return PaymentObject_v1_2.socialInsurance
            case "casinoChips": return PaymentObject_v1_2.casinoChips
            case "agentPayment": return PaymentObject_v1_2.agentPayment
            case "excisableGoodsWithoutMarkingCode": return PaymentObject_v1_2.excisableGoodsWithoutMarkingCode
            case "excisableGoodsWithMarkingCode": return PaymentObject_v1_2.excisableGoodsWithMarkingCode
            case "goodsWithoutMarkingCode": return PaymentObject_v1_2.goodsWithoutMarkingCode
            case "goodsWithMarkingCode": return PaymentObject_v1_2.goodsWithMarkingCode
            case "another": return PaymentObject_v1_2.another
            default: return PaymentObject_v1_2.another
        }
    }
    
    static func parsePaymentMethod(paymentMethod: String?) -> PaymentMethod {
        switch (paymentMethod) {
            case "fullPrepayment": return PaymentMethod.fullPrepayment
            case "prepayment": return PaymentMethod.prepayment
            case "advance": return PaymentMethod.advance
            case "fullPayment": return PaymentMethod.fullPayment
            case "partialPayment": return PaymentMethod.partialPayment
            case "credit": return PaymentMethod.credit
            case "creditPayment": return PaymentMethod.creditPayment
            default: return PaymentMethod.fullPrepayment
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
    
    static func parsePaymentFlow(
        paymentFlow: String,
        orderOptions: OrderOptions?,
        customerOptions: CustomerOptions?,
        paymentId: String?,
        amount: Int64?,
        orderId: String?
    ) -> PaymentFlow {
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
    
    static func parseOrderOptions(args: Dictionary<String, Any>, ffdVersion: String) -> OrderOptions {
        let receipt = args["receipt"] == nil ? nil : ffdVersion == "105" ? parseReceipt105(receiptArgs: args["receipt"] as! Dictionary<String, Any>) : parseReceipt12(receiptArgs: args["receipt"] as! Dictionary<String, Any>)
        
        let orderId = args["orderId"] as! String
        let amount = args["amount"] as! Int64
        let description = args["description"] as? String
        let payType = parsePayType(payType: args["payType"] as? String)
        let shops = (args["shops"] as? Array<Dictionary<String, Any>>)?.map({
            parseShop(args: $0)
        })
        let receipts = (args["receipts"] as? Array<Dictionary<String, Any>>)?.map({
            ffdVersion == "105" ? parseReceipt105(receiptArgs: $0) :parseReceipt12(receiptArgs: $0)
        })
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
    
    static func parseCustomerOptions(args: Dictionary<String, Any>?) -> CustomerOptions? {
        if (args == nil) {
            return nil
        }
        let customerKey = args!["customerKey"] as! String
        let email = args!["email"] as? String
        
        return CustomerOptions(
            customerKey: customerKey,
            email: email
        )
    }
    
    static func parseReceipt105(receiptArgs: Dictionary<String, Any>) -> Receipt {
        let email = receiptArgs["email"] as? String
        let phone = receiptArgs["phone"] as? String
        let taxation = Utils.parseTaxation(receiptArgs["taxation"] as? String)
        let items = (receiptArgs["items"] as! Array<Dictionary<String, Any>>).map({ parseItem105(args: $0) })
        let shopCode = receiptArgs["shopCode"] as? String
        let agentData = Utils.parseAgentData(args: receiptArgs["agentData"] as? Dictionary<String, Any>)
        let supplierInfo = Utils.parseSupplierInfo(args: receiptArgs["supplierInfo"] as? Dictionary<String, Any>)
        
        return Receipt.version1_05(
            try! ReceiptFdv1_05(
                shopCode: shopCode,
                email: email,
                taxation: taxation,
                phone: phone,
                items: items,
                agentData: agentData,
                supplierInfo: supplierInfo
            )
        )
        
    }
    
    static func parseReceipt12(receiptArgs: Dictionary<String, Any>) -> Receipt {
        let clientInfo = parseClientInfo(args: receiptArgs["clientInfo"] as? Dictionary<String, Any>)
        let email = receiptArgs["email"] as? String
        let phone = receiptArgs["phone"] as? String
        let taxation = Utils.parseTaxation(receiptArgs["taxation"] as? String)
        let items = (receiptArgs["items"] as! Array<Dictionary<String, Any>>).map({ parseItem12(args: $0) })
        let customer = receiptArgs["customer"] as? String
        let customerInn = receiptArgs["customerInn"] as? String
        
        return Receipt.version1_2(
            try! ReceiptFdv1_2(
                email: email,
                taxation: taxation,
                phone: phone,
                items: items,
                customer: customer,
                customerInn: customerInn,
                clientInfo: clientInfo,
                operatingCheckProps: parseOperatingCheckProps(args: receiptArgs["operatingCheckProps"] as? Dictionary<String, Any>),
                sectoralCheckProps: parseSectoralCheckProps(args: receiptArgs["sectoralCheckProps"] as? Dictionary<String, Any>),
                additionalCheckProps: receiptArgs["additionalCheckProps"] as? String
                
            )
        )
    }
    
    static func parseItem105(args: Dictionary<String, Any>) -> Item_v1_05 {
        return Item_v1_05(
            amount: args["amount"] as! Int64,
            price: args["price"] as! Int64,
            name: args["name"] as! String,
            tax: Utils.parseTax(args["tax"] as! String),
            quantity: args["quantity"] as! Double,
            paymentObject: Utils.parsePaymentObject105(paymentObject: args["paymentObject"] as? String),
            paymentMethod: Utils.parsePaymentMethod(paymentMethod: args["paymentMethod"] as? String),
            ean13: args["ean13"] as? String,
            shopCode: args["shopCode"] as? String,
            supplierInfo: Utils.parseSupplierInfo(args: args["supplierInfo"] as? Dictionary<String, Any>),
            agentData: Utils.parseAgentData(args: args["agentData"] as? Dictionary<String, Any>)
        )
    }
    
    static func parseItem12(args: Dictionary<String, Any>) -> Item_v1_2 {
        return Item_v1_2(
            amount: args["amount"] as! Int64,
            price: args["price"] as! Int64,
            name: args["name"] as! String,
            tax: Utils.parseTax(args["tax"] as! String),
            quantity: args["quantity"] as! Double,
            paymentObject: parsePaymentObject12(paymentObject: args["paymentObject"] as? String),
            paymentMethod: parsePaymentMethod(paymentMethod: args["paymentMethod"] as? String),
            supplierInfo: Utils.parseSupplierInfo(args: args["supplierInfo"] as? Dictionary<String, Any>),
            agentData: parseAgentData(args: args["agentData"] as? Dictionary<String, Any>),
            countryCode: args["countryCode"] as? String,
            declarationNumber: args["declarationNumber"] as? String,
            measurementUnit: args["measurementUnit"] as! String,
            markProcessingMode: args["markProcessingMode"] as! String,
            markCode: parseMarkCode(args: args["markCode"] as? Dictionary<String, Any>),
            markQuantity: parseMarkQuantity(args: args["markQuantity"] as? Dictionary<String, Any>),
            sectoralItemProps: (args["sectoralItemProps"] as? Array<Dictionary<String, Any>>)?.map({ parseSectoralItemProps(args: $0) })
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
    
    static func parseClientInfo(args: Dictionary<String, Any>?) -> ClientInfo {
        let birthdate = args?["birthdate"] as? String
        let citizenship = args?["citizenship"] as? String
        let documentCode = args?["documentCode"] as? String
        let documentData = args?["documentData"] as? String
        let address = args?["address"] as? String
        
        return ClientInfo(
            birthdate: birthdate,
            citizenship: citizenship,
            documentCode: documentCode,
            documentData: documentData, 
            address: address
        )
    }
    
    static func parseMarkCode(args: Dictionary<String, Any>?) -> MarkCode {
        return MarkCode(
            markCodeType: args?["markCodeType"] as! String,
            value: args?["value"] as! String
        )
    }
    
    static func parseMarkQuantity(args: Dictionary<String, Any>?) -> MarkQuantity {
        return MarkQuantity(
            numerator: args?["numerator"] as? Int,
            denominator: args?["denominator"] as? Int
        )
    }
    
    static func parseSectoralCheckProps(args: Dictionary<String, Any>?) -> SectoralCheckProps? {
        if (args == nil) {
            return nil
        }
        
        return SectoralCheckProps(
            federalId: args?["federalId"] as! String,
            date: args?["date"] as! String,
            number: args?["number"] as! String,
            value: args?["value"] as! String
        )
    }
    
    static func parseSectoralItemProps(args: Dictionary<String, Any>) -> SectoralItemProps {
        return SectoralItemProps(
            federalId: args["federalId"] as! String,
            date: args["date"] as! String,
            number: args["number"] as! String,
            value: args["value"] as! String
        )
    }
    
    static func parseOperatingCheckProps(args: Dictionary<String, Any>?) -> OperatingCheckProps {
        return OperatingCheckProps(
            name: args?["name"] as! String,
            value: args?["value"] as! String,
            timestamp: args?["timestamp"] as! String
        )
    }
}
