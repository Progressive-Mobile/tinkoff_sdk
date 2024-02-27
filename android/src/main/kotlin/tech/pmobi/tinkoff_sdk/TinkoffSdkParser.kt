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
package tech.pmobi.tinkoff_sdk

import android.os.Parcel
import ru.tinkoff.acquiring.sdk.cardscanners.CameraCardScanner
import ru.tinkoff.acquiring.sdk.models.ClientInfo
import ru.tinkoff.acquiring.sdk.models.DarkThemeMode
import ru.tinkoff.acquiring.sdk.models.Item
import ru.tinkoff.acquiring.sdk.models.Item105
import ru.tinkoff.acquiring.sdk.models.Item12
import ru.tinkoff.acquiring.sdk.models.Receipt
import ru.tinkoff.acquiring.sdk.models.Shop
import ru.tinkoff.acquiring.sdk.models.enums.PaymentMethod
import ru.tinkoff.acquiring.sdk.models.enums.PaymentObject105
import ru.tinkoff.acquiring.sdk.models.enums.PaymentObject12
import ru.tinkoff.acquiring.sdk.models.enums.Tax
import ru.tinkoff.acquiring.sdk.models.enums.Taxation
import ru.tinkoff.acquiring.sdk.models.options.CustomerOptions
import ru.tinkoff.acquiring.sdk.models.options.FeaturesOptions
import ru.tinkoff.acquiring.sdk.models.options.OrderOptions
import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions
import ru.tinkoff.acquiring.sdk.models.options.screen.SavedCardsOptions
import ru.tinkoff.acquiring.sdk.utils.Money.Companion.ofCoins
import ru.tinkoff.acquiring.sdk.utils.builders.ReceiptBuilder

class TinkoffSdkParser() {
    fun createSavedCardOptions(arguments: Map<String?, Any?>): SavedCardsOptions {
        val options = SavedCardsOptions.createFromParcel(Parcel.obtain());
        val customer = parseCustomerOptions(arguments["customerOptions"] as Map<String, Any>)
        options.customer = customer
        val featuresOptionsArguments = arguments["featuresOptions"] as Map<String, Any>?
        if (featuresOptionsArguments != null) {
            val features = parseFeatureOptions(featuresOptionsArguments)
            options.features = features
        }
        return options
    }

    fun createPaymentOptions(arguments: Map<String?, Any?>): PaymentOptions {
        val terminalKey = arguments["terminalKey"] as String
        val publicKey = arguments["publicKey"] as String

        val paymentsOptions = PaymentOptions().setOptions {
            setTerminalParams(terminalKey, publicKey)
        }

        val ffdVersion = arguments["ffdVersion"] as String?
        var receipt: Receipt? = null
        if (arguments["receipt"] != null && ffdVersion != null) {
            receipt = parseReceipt(
                arguments = arguments["receipt"] as Map<String, Any>,
                ffdVersion = ffdVersion
            )

            val orderOptions = parseOrderOptions(
                arguments = arguments["orderOptions"] as Map<String, Any>,
                ffdVersion = ffdVersion
            )

            paymentsOptions.order = orderOptions
            paymentsOptions.order.receipt = receipt
        }

        val customerOptions = parseCustomerOptions(
            arguments = arguments["customerOptions"] as Map<String, Any>
        )
        val featuresOptions = parseFeatureOptions(
            arguments = arguments["featuresOptions"] as Map<String, Any>
        )

        paymentsOptions.customer = customerOptions
        paymentsOptions.features = featuresOptions

        return paymentsOptions
    }

    private fun parseOrderOptions(arguments: Map<String, Any>, ffdVersion: String): OrderOptions {
        val orderOptions = OrderOptions()
        orderOptions.orderId = arguments["orderId"] as String
        orderOptions.amount = ofCoins((arguments["amount"] as Int).toLong())
        orderOptions.recurrentPayment = arguments["recurrentPayment"] as Boolean
        orderOptions.title = arguments["title"] as String?
        orderOptions.description = arguments["description"] as String?
        orderOptions.receipt = if (arguments["receipt"] == null) null else parseReceipt(
            arguments = arguments["receipt"] as Map<String, Any>,
            ffdVersion = ffdVersion
        )
        orderOptions.shops = if (arguments["shops"] == null) null else
                (arguments["shops"] as List<Map<String, Any>>).map {
                    parseShop(it)
                }.toList()
        orderOptions.receipts = if (arguments["receipts"] == null) null else
                (arguments["receipts"] as List<Map<String, Any>>).map {
                    parseReceipt(it, ffdVersion)
                }.toList()
        orderOptions.successURL = arguments["successURL"] as String?
        orderOptions.failURL = arguments["failURL"] as String?
        orderOptions.clientInfo = if (arguments["clientInfo"] == null) null else
            parseClientInfo(arguments["clientInfo"] as Map<String, Any>)
        orderOptions.items = if (arguments["items"] == null) null else
            (arguments["items"] as List<Map<String, Any>>).map { parseItem(it, ffdVersion) }.toMutableList()
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

    private fun parseFeatureOptions(arguments: Map<String, Any>): FeaturesOptions {
        val fpsEnabled = arguments["fpsEnabled"] as Boolean
        val useSecureKeyboard = arguments["useSecureKeyboard"] as Boolean
        val handleCardListErrorInSdk = arguments["handleCardListErrorInSdk"] as Boolean
        val enableCameraCardScanner = arguments["enableCameraCardScanner"] as Boolean
        val darkMode: DarkThemeMode = when (arguments["darkThemeMode"] as String?) {
            "ENABLED" -> DarkThemeMode.ENABLED
            "DISABLED" -> DarkThemeMode.DISABLED
            "AUTO" -> DarkThemeMode.AUTO
            else -> DarkThemeMode.AUTO
        }
        val featuresOptions = FeaturesOptions()
        featuresOptions.fpsEnabled = fpsEnabled
        featuresOptions.useSecureKeyboard = useSecureKeyboard
        featuresOptions.handleCardListErrorInSdk = handleCardListErrorInSdk
        featuresOptions.duplicateEmailToReceipt = true
        featuresOptions.darkThemeMode = darkMode
        return featuresOptions
    }

    private fun parseReceipt(arguments: Map<String, Any>, ffdVersion: String): Receipt {
        var receipt: Receipt?
        val taxation = parseTaxation(arguments["taxation"] as String)
        if (ffdVersion == "105") {
            receipt = ReceiptBuilder.ReceiptBuilder105(taxation).build()
            receipt.email = arguments["email"] as String?
            receipt.phone = arguments["phone"] as String?
            receipt.items = (arguments["items"] as List<Map<String, Any>>).map {
                parseItem(arguments = it, ffdVersion = ffdVersion) as Item105
            }.toMutableList()
        } else {
            receipt = ReceiptBuilder.ReceiptBuilder12(
                taxation = taxation,
                clientInfo = parseClientInfo(arguments["clientInfo"] as Map<String, Any>)
            ).build()
            receipt.email = arguments["email"] as String?
            receipt.phone = arguments["phone"] as String?
            receipt.items = (arguments["items"] as List<Map<String, Any>>).map {
                parseItem(arguments = it, ffdVersion = ffdVersion) as Item12
            }.toMutableList()
        }

        return receipt
    }

    private fun parseItem(arguments: Map<String, Any>, ffdVersion: String): Item {
        if (ffdVersion == "105") {
            return Item105(
                name = arguments["name"] as String,
                price = (arguments["price"] as Double).toLong(),
                quantity = arguments["quantity"] as Double,
                amount = (arguments["amount"] as Double).toLong(),
                tax = parseTax(arguments["tax"] as String),
                ean13 = arguments["ean13"] as String?,
                shopCode = arguments["shopCode"] as String?,
                paymentMethod = parsePaymentMethod(arguments["paymentMethod"] as String?),
                paymentObject = parsePaymentObject105(arguments["paymentObject"] as String?),
            )
        } else {
            return Item12(
                price = (arguments["price"] as Double).toLong(),
                quantity = arguments["quantity"] as Double,
                name = arguments["name"] as String?,
                amount = (arguments["amount"] as Double).toLong(),
                tax = parseTax(arguments["tax"] as String?),
                paymentMethod = parsePaymentMethod(arguments["paymentMethod"] as String?),
                paymentObject = parsePaymentObject12(arguments["paymentObject"] as String?),
                null,
                null,
                null,
                null,
                null,
                null,
                "piece",
                null,
                null,
                null,
                null,
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

    private fun parseTax(tax: String?): Tax {
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
            "iePensionInsuranceWithoutPayments" -> PaymentObject12.IE_PENSION_INSURANCE_WITHOUT_PAYMENTS
            "iePensionInsuranceWithPayments" -> PaymentObject12.IE_PENSION_INSURANCE_WITH_PAYMENTS
            "ieMedicalInsuranceWithoutPayments" -> PaymentObject12.IE_MEDICAL_INSURANCE_WITHOUT_PAYMENTS
            "ieMedicalInsuranceWithPayments" -> PaymentObject12.IE_MEDICAL_INSURANCE_WITH_PAYMENTS
            "socialInsurance" -> PaymentObject12.SOCIAL_INSURANCE
            "casinoChips" -> PaymentObject12.CASINO_CHIPS
            "agentPayment" -> PaymentObject12.AGENT_PAYMENT
            "excisableGoodsWithoutMarkingCode" -> PaymentObject12.EXCISABLE_GOODS_WITHOUT_MARKING_CODE
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
}
