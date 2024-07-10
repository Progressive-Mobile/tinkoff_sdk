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
package tech.pmobi.tinkoff_sdk

import java.util.ArrayList
import ru.tinkoff.acquiring.sdk.models.AgentData
import ru.tinkoff.acquiring.sdk.models.ClientInfo
import ru.tinkoff.acquiring.sdk.models.DarkThemeMode
import ru.tinkoff.acquiring.sdk.models.Item
import ru.tinkoff.acquiring.sdk.models.Item105
import ru.tinkoff.acquiring.sdk.models.Item12
import ru.tinkoff.acquiring.sdk.models.MarkCode
import ru.tinkoff.acquiring.sdk.models.MarkQuantity
import ru.tinkoff.acquiring.sdk.models.Receipt
import ru.tinkoff.acquiring.sdk.models.SectoralItemProps
import ru.tinkoff.acquiring.sdk.models.Shop
import ru.tinkoff.acquiring.sdk.models.SupplierInfo
import ru.tinkoff.acquiring.sdk.models.enums.AgentSign
import ru.tinkoff.acquiring.sdk.models.enums.MarkCodeType
import ru.tinkoff.acquiring.sdk.models.enums.PaymentMethod
import ru.tinkoff.acquiring.sdk.models.enums.PaymentObject105
import ru.tinkoff.acquiring.sdk.models.enums.PaymentObject12
import ru.tinkoff.acquiring.sdk.models.enums.Tax
import ru.tinkoff.acquiring.sdk.models.enums.Taxation
import ru.tinkoff.acquiring.sdk.models.options.CustomerOptions
import ru.tinkoff.acquiring.sdk.models.options.FeaturesOptions
import ru.tinkoff.acquiring.sdk.models.options.OrderOptions
import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions
import ru.tinkoff.acquiring.sdk.utils.Money.Companion.ofCoins
import ru.tinkoff.acquiring.sdk.utils.builders.ReceiptBuilder

class TinkoffSdkParser() {
    fun createCardOptions(arguments: Map<String, Any>): Map<String, Any> {
        val terminalKey = arguments["terminalKey"] as String
        val publicKey = arguments["publicKey"] as String
        val customerOptions = parseCustomerOptions(arguments["customerOptions"] as Map<String, Any>)
        val featuresOptions = parseFeatureOptions(arguments["featuresOptions"] as Map<String, Any>)

        return mapOf(
                "terminalKey" to terminalKey,
                "publicKey" to publicKey,
                "customer" to customerOptions,
                "features" to featuresOptions,
        )
    }

    fun createPaymentOptions(arguments: Map<String, Any>): PaymentOptions {
        val terminalKey = arguments["terminalKey"] as String
        val publicKey = arguments["publicKey"] as String

        val paymentsOptions =
                PaymentOptions().setOptions { setTerminalParams(terminalKey, publicKey) }

        val ffdVersion = arguments["ffdVersion"] as String?

        val orderOptions =
                parseOrderOptions(
                        arguments = arguments["orderOptions"] as Map<String, Any>,
                        ffdVersion = ffdVersion
                )
        paymentsOptions.order = orderOptions
        paymentsOptions.paymentId = (arguments["paymentId"] as String?)?.toLongOrNull()

        var receipt: Receipt? = null
        if (arguments["receipt"] != null && ffdVersion != null) {
            receipt =
                    parseReceipt(
                            arguments = arguments["receipt"] as Map<String, Any>,
                            ffdVersion = ffdVersion
                    )

            paymentsOptions.order.receipt = receipt
        }

        val customerOptions =
                parseCustomerOptions(arguments = arguments["customerOptions"] as Map<String, Any>)
        val featuresOptions =
                if (arguments["featuresOptions"] != null)
                        parseFeatureOptions(
                                arguments = arguments["featuresOptions"] as Map<String, Any>
                        )
                else null

        paymentsOptions.customer = customerOptions
        paymentsOptions.features = featuresOptions ?: FeaturesOptions()

        return paymentsOptions
    }

    private fun parseOrderOptions(arguments: Map<String, Any>, ffdVersion: String?): OrderOptions {
        val orderOptions = OrderOptions()
        orderOptions.orderId = arguments["orderId"] as String
        orderOptions.amount = ofCoins((arguments["amount"] as Int).toLong())
        orderOptions.recurrentPayment = arguments["recurrentPayment"] as Boolean
        orderOptions.description = arguments["description"] as String?
        if (ffdVersion != null) {
            orderOptions.receipt =
                    if (arguments["receipt"] == null) null
                    else
                            parseReceipt(
                                    arguments = arguments["receipt"] as Map<String, Any>,
                                    ffdVersion = ffdVersion
                            )
            orderOptions.receipts =
                    (arguments["receipts"] as List<Map<String, Any>>?)
                            ?.map { parseReceipt(it, ffdVersion) }
                            ?.toList()
            orderOptions.items =
                    if (arguments["items"] == null) null
                    else
                            (arguments["items"] as List<Map<String, Any>>)
                                    .map { parseItem(it, ffdVersion) }
                                    .toMutableList()
        }
        orderOptions.shops =
                (arguments["shops"] as List<Map<String, Any>>?)?.map { parseShop(it) }?.toList()
        orderOptions.successURL = arguments["successURL"] as String?
        orderOptions.failURL = arguments["failURL"] as String?
        orderOptions.clientInfo =
                if (arguments["clientInfo"] == null) null
                else parseClientInfo(arguments["clientInfo"] as Map<String, Any>)
        orderOptions.additionalData = arguments["additionalData"] as Map<String, String>?

        return orderOptions
    }

    private fun parseCustomerOptions(arguments: Map<String, Any>): CustomerOptions {
        val customerOptions = CustomerOptions()
        customerOptions.customerKey = arguments["customerKey"] as String
        customerOptions.checkType = arguments["checkType"] as String
        customerOptions.email = arguments["email"] as String?
        customerOptions.data = arguments["data"] as Map<String, String>?
        return customerOptions
    }

    fun parseFeatureOptions(arguments: Map<String, Any>): FeaturesOptions {
        val featuresOptions = FeaturesOptions()

        featuresOptions.darkThemeMode =
                when (arguments["darkThemeMode"] as String?) {
                    "ENABLED" -> DarkThemeMode.ENABLED
                    "DISABLED" -> DarkThemeMode.DISABLED
                    "AUTO" -> DarkThemeMode.AUTO
                    else -> DarkThemeMode.AUTO
                }
        featuresOptions.useSecureKeyboard = arguments["useSecureKeyboard"] as Boolean
        featuresOptions.duplicateEmailToReceipt = arguments["duplicateEmailToReceipt"] as Boolean

        return featuresOptions
    }

    private fun parseReceipt(arguments: Map<String, Any>, ffdVersion: String): Receipt {
        val receipt: Receipt?
        val taxation = parseTaxation(arguments["taxation"] as String)
        if (ffdVersion == "105") {
            receipt = ReceiptBuilder.ReceiptBuilder105(taxation).build()
            receipt.email = arguments["email"] as String?
            receipt.phone = arguments["phone"] as String?
            receipt.items =
                    (arguments["items"] as List<Map<String, Any>>)
                            .map { parseItem(arguments = it, ffdVersion = ffdVersion) as Item105 }
                            .toMutableList()
        } else {
            receipt =
                    ReceiptBuilder.ReceiptBuilder12(
                                    taxation = taxation,
                                    clientInfo =
                                            parseClientInfo(
                                                    arguments["clientInfo"] as Map<String, Any>
                                            )
                            )
                            .build()
            receipt.email = arguments["email"] as String?
            receipt.phone = arguments["phone"] as String?
            receipt.items =
                    (arguments["items"] as List<Map<String, Any>>)
                            .map { parseItem(arguments = it, ffdVersion = ffdVersion) as Item12 }
                            .toMutableList()
        }

        return receipt
    }

    private fun parseItem(arguments: Map<String, Any>, ffdVersion: String): Item {
        if (ffdVersion == "105") {
            return Item105(
                    name = arguments["name"] as String,
                    price = (arguments["price"] as Int).toLong(),
                    quantity = arguments["quantity"] as Double,
                    amount = (arguments["amount"] as Int).toLong(),
                    tax = parseTax(arguments["tax"] as String),
                    ean13 = arguments["ean13"] as String?,
                    shopCode = arguments["shopCode"] as String?,
                    paymentMethod = parsePaymentMethod(arguments["paymentMethod"] as String?),
                    paymentObject = parsePaymentObject105(arguments["paymentObject"] as String?),
                    agentData = parseAgentData(arguments["agentData"] as Map<String, Any>?),
            )
        } else {
            return Item12(
                    price = (arguments["price"] as Int).toLong(),
                    quantity = arguments["quantity"] as Double,
                    name = arguments["name"] as String?,
                    amount = (arguments["amount"] as Int?)?.toLong(),
                    tax = parseTax(arguments["tax"] as String),
                    paymentMethod = parsePaymentMethod(arguments["paymentMethod"] as String?),
                    paymentObject = parsePaymentObject12(arguments["paymentObject"] as String?),
                    agentData = parseAgentData(arguments["agentData"] as Map<String, Any>?),
                    supplierInfo =
                            parseSupplierInfo(arguments["supplierInfo"] as Map<String, Any>?),
                    userData = arguments["userData"] as String?,
                    excise = arguments["excise"] as Double?,
                    countryCode = arguments["countryCode"] as String?,
                    declarationNumber = arguments["declarationNumber"] as String?,
                    measurementUnit = arguments["measurementUnit"] as String,
                    markProcessingMode = arguments["markProcessingMode"] as String?,
                    markCode = parseMarkCode(arguments["markCode"] as Map<String, Any>?),
                    markQuantity =
                            parseMarkQuantity(arguments["markQuantity"] as Map<String, Any>?),
                    sectoralItemProps =
                            (arguments["sectoralItemProps"] as Array<Map<String, Any>>?)
                                    ?.map { parseSectoralItemProps(it) }
                                    ?.toList(),
            )
        }
    }

    private fun parseTaxation(taxation: String?): Taxation {
        return when (taxation) {
            "usn_income" -> Taxation.USN_INCOME
            "usn_income_outcome" -> Taxation.USN_INCOME_OUTCOME
            "patent" -> Taxation.PATENT
            "envd" -> Taxation.ENVD
            "esn" -> Taxation.ESN
            "osn" -> Taxation.OSN
            else -> Taxation.OSN
        }
    }

    private fun parseTax(tax: String): Tax {
        return when (tax) {
            "vat0" -> Tax.VAT_0
            "vat10" -> Tax.VAT_10
            "vat18" -> Tax.VAT_18
            "vat20" -> Tax.VAT_20
            "vat110" -> Tax.VAT_110
            "vat118" -> Tax.VAT_118
            "vat120" -> Tax.VAT_120
            "none" -> Tax.NONE
            else -> Tax.NONE
        }
    }

    private fun parsePaymentMethod(paymentMethod: String?): PaymentMethod? {
        return when (paymentMethod) {
            "fullPrepayment" -> PaymentMethod.FULL_PREPAYMENT
            "prepayment" -> PaymentMethod.PREPAYMENT
            "advance" -> PaymentMethod.ADVANCE
            "fullPayment" -> PaymentMethod.FULL_PAYMENT
            "partialPayment" -> PaymentMethod.PARTIAL_PAYMENT
            "credit" -> PaymentMethod.CREDIT
            "creditPayment" -> PaymentMethod.CREDIT_PAYMENT
            else -> null
        }
    }

    private fun parsePaymentObject105(paymentObject: String?): PaymentObject105? {
        return when (paymentObject) {
            "excise" -> PaymentObject105.EXCISE
            "job" -> PaymentObject105.JOB
            "service" -> PaymentObject105.SERVICE
            "gamblingBet" -> PaymentObject105.GAMBLING_BET
            "gamblingPrize" -> PaymentObject105.GAMBLING_PRIZE
            "lottery" -> PaymentObject105.LOTTERY
            "lotteryPrize" -> PaymentObject105.LOTTERY_PRIZE
            "intellectualActivity" -> PaymentObject105.INTELLECTUAL_ACTIVITY
            "payment" -> PaymentObject105.PAYMENT
            "agentCommission" -> PaymentObject105.AGENT_COMMISSION
            "composite" -> PaymentObject105.COMPOSITE
            "another" -> PaymentObject105.ANOTHER
            else -> null
        }
    }

    private fun parsePaymentObject12(paymentObject: String?): PaymentObject12? {
        return when (paymentObject) {
            "excise" -> PaymentObject12.EXCISE
            "job" -> PaymentObject12.JOB
            "service" -> PaymentObject12.SERVICE
            "gamblingBet" -> PaymentObject12.GAMBLING_BET
            "gamblingPrize" -> PaymentObject12.GAMBLING_PRIZE
            "lottery" -> PaymentObject12.LOTTERY
            "lotteryPrize" -> PaymentObject12.LOTTERY_PRIZE
            "intellectualActivity" -> PaymentObject12.INTELLECTUAL_ACTIVITY
            "payment" -> PaymentObject12.PAYMENT
            "agentCommission" -> PaymentObject12.AGENT_COMMISSION
            "composite" -> PaymentObject12.COMPOSITE
            "another" -> PaymentObject12.ANOTHER
            "commodity" -> PaymentObject12.COMMODITY
            "contribution" -> PaymentObject12.CONTRIBUTION
            "propertyRights" -> PaymentObject12.PROPERTY_RIGHTS
            "unrealization" -> PaymentObject12.UNREALIZATION
            "taxReduction" -> PaymentObject12.TAX_REDUCTION
            "tradeFee" -> PaymentObject12.TRADE_FEE
            "resortTax" -> PaymentObject12.RESORT_TAX
            "pledge" -> PaymentObject12.PLEDGE
            "incomeDecrease" -> PaymentObject12.INCOME_DECREASE
            "iePensionInsuranceWithoutPayments" ->
                    PaymentObject12.IE_PENSION_INSURANCE_WITHOUT_PAYMENTS
            "iePensionInsuranceWithPayments" -> PaymentObject12.IE_PENSION_INSURANCE_WITH_PAYMENTS
            "ieMedicalInsuranceWithoutPayments" ->
                    PaymentObject12.IE_MEDICAL_INSURANCE_WITHOUT_PAYMENTS
            "ieMedicalInsuranceWithPayments" -> PaymentObject12.IE_MEDICAL_INSURANCE_WITH_PAYMENTS
            "socialInsurance" -> PaymentObject12.SOCIAL_INSURANCE
            "casinoChips" -> PaymentObject12.CASINO_CHIPS
            "agentPayment" -> PaymentObject12.AGENT_PAYMENT
            "excisableGoodsWithoutMarkingCode" ->
                    PaymentObject12.EXCISABLE_GOODS_WITHOUT_MARKING_CODE
            "excisableGoodsWithMarkingCode" -> PaymentObject12.EXCISABLE_GOODS_WITH_MARKING_CODE
            "goodsWithoutMarkingCode" -> PaymentObject12.GOODS_WITHOUT_MARKING_CODE
            "goodsWithMarkingCode" -> PaymentObject12.GOODS_WITH_MARKING_CODE
            else -> null
        }
    }

    private fun parseShop(arguments: Map<String, Any>): Shop {
        return Shop(
                shopCode = arguments["shopCode"] as String,
                name = arguments["name"] as String,
                amount = (arguments["amount"] as Double).toLong(),
                fee = arguments["fee"] as String?
        )
    }

    private fun parseClientInfo(arguments: Map<String, Any>): ClientInfo {
        return ClientInfo(
                arguments["birthdate"] as String?,
                arguments["citizenship"] as String?,
                arguments["documentCode"] as String?,
                arguments["documentData"] as String?,
                arguments["address"] as String?
        )
    }

    private fun parseAgentData(arguments: Map<String, Any>?): AgentData? {
        if (arguments == null) {
            return null
        }

        val agentData = AgentData()
        agentData.agentSign = parseAgentSign(arguments["agentSign"] as String?)
        agentData.operationName = arguments["operationName"] as String?
        agentData.phones = (arguments["phones"] as ArrayList<String>?)?.toTypedArray()
        agentData.receiverPhones =
                (arguments["receiverPhones"] as ArrayList<String>?)?.toTypedArray()
        agentData.transferPhones =
                (arguments["transferPhones"] as ArrayList<String>?)?.toTypedArray()
        agentData.operatorName = arguments["operatorName"] as String?
        agentData.operatorAddress = arguments["operatorAddress"] as String?
        agentData.operatorInn = arguments["operatorInn"] as String?
        return agentData
    }

    private fun parseAgentSign(agentSign: String?): AgentSign? {
        return when (agentSign) {
            "bankPayingAgent" -> AgentSign.BANK_PAYING_AGENT
            "bankPayingSubagent" -> AgentSign.BANK_PAYING_SUBAGENT
            "payingAgent" -> AgentSign.PAYING_AGENT
            "payingSubagent" -> AgentSign.PAYING_SUBAGENT
            "attorney" -> AgentSign.ATTORNEY
            "commissionAgent" -> AgentSign.COMMISSION_AGENT
            "another" -> AgentSign.ANOTHER
            else -> null
        }
    }

    private fun parseSupplierInfo(arguments: Map<String, Any>?): SupplierInfo? {
        if (arguments == null) {
            return null
        }

        val supplierInfo = SupplierInfo()
        supplierInfo.phones = arguments["phones"] as Array<String>?
        supplierInfo.name = arguments["name"] as String?
        supplierInfo.inn = arguments["inn"] as String?
        return supplierInfo
    }

    private fun parseMarkCode(arguments: Map<String, Any>?): MarkCode? {
        if (arguments == null) {
            return null
        }

        return MarkCode(
                markCodeType = parseMarkCodeType(arguments["markCodeType"] as String)!!,
                value = arguments["value"] as String
        )
    }

    private fun parseMarkCodeType(markCodeType: String): MarkCodeType? {
        return when (markCodeType) {
            "unknown" -> MarkCodeType.UNKNOWN
            "ean8" -> MarkCodeType.EAN8
            "ean13" -> MarkCodeType.EAN13
            "itf14" -> MarkCodeType.ITF14
            "gs10" -> MarkCodeType.GS10
            "gs1m" -> MarkCodeType.GS1M
            "short" -> MarkCodeType.SHORT
            "fur" -> MarkCodeType.FUR
            "egais20" -> MarkCodeType.EGAIS20
            "egais30" -> MarkCodeType.EGAIS30
            else -> null
        }
    }

    private fun parseMarkQuantity(arguments: Map<String, Any>?): MarkQuantity? {
        if (arguments == null) {
            return null
        }

        val markQuantity = MarkQuantity()
        markQuantity.numerator = arguments["numerator"] as Int?
        markQuantity.denominator = arguments["denominator"] as Int?
        return markQuantity
    }

    private fun parseSectoralItemProps(arguments: Map<String, Any>): SectoralItemProps {
        return SectoralItemProps(
                federalId = arguments["federalId"] as String,
                date = arguments["date"] as String,
                number = arguments["number"] as String,
                value = arguments["value"] as String
        )
    }
}
