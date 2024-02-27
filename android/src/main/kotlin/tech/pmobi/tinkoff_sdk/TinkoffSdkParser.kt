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
import ru.tinkoff.acquiring.sdk.localization.AsdkSource
import ru.tinkoff.acquiring.sdk.localization.Language
import ru.tinkoff.acquiring.sdk.models.ClientInfo
import ru.tinkoff.acquiring.sdk.models.DarkThemeMode
import ru.tinkoff.acquiring.sdk.models.Item
import ru.tinkoff.acquiring.sdk.models.Item105
import ru.tinkoff.acquiring.sdk.models.Item12
import ru.tinkoff.acquiring.sdk.models.Payments
import ru.tinkoff.acquiring.sdk.models.Receipt
import ru.tinkoff.acquiring.sdk.models.ReceiptFfd105
import ru.tinkoff.acquiring.sdk.models.enums.PaymentMethod
import ru.tinkoff.acquiring.sdk.models.enums.PaymentObject105
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
        var options = SavedCardsOptions.createFromParcel(Parcel.obtain());
        val customerOptionsArguments = arguments["customerOptions"] as Map<String, Any>
        val customer = parseCustomerOptions(customerOptionsArguments)
        options.customerOptions {
            customer
        }
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
        val orderOptions = parseOrderOptions(arguments["orderOptions"] as Map<String, Any>)
        val customerOptions = parseCustomerOptions(arguments["customerOptions"] as Map<String, Any>)
        val featuresOptions = parseFeatureOptions(arguments["featuresOptions"] as Map<String, Any>)
        var receipt: Receipt? = null
        if (arguments["receipt"] != null) {
            receipt = parseReceipt(arguments["receipt"] as Map<String, Any>)
        }

        val paymentsOptions = PaymentOptions().setOptions {
            setTerminalParams(terminalKey, publicKey)
        }
        paymentsOptions.order = orderOptions
        paymentsOptions.customer = customerOptions
        paymentsOptions.features = featuresOptions
        if (receipt != null) {
            paymentsOptions.order.receipt = receipt
        }

        return paymentsOptions
    }

    private fun parseReceipt(arguments: Map<String, Any>): Receipt {
        val receiptType = arguments["parseAs"] as String
        val phone = arguments["phone"] as String?
        val email = arguments["email"] as String?
        val taxationStr = arguments["taxation"] as String?
        val taxation = parseTaxation(taxationStr)
        val itemsArguments =
            arguments["items"] as ArrayList<Map<String, Any>>?
        val items =
            parseReceiptItems(itemsArguments, receiptType)
//        return Receipt(
////            null,
////            taxation,
////            email,
////            phone,
////            null,
////            null,
////            items,
////            null,
////            null,
////            null,
////            null,
////            null
//
//        )

        var receipt: Receipt? = null
        if (receiptType == "105") {
            receipt = ReceiptBuilder.ReceiptBuilder105(taxation).build()
            receipt.email = email
            receipt.phone = phone
            receipt.items = items as MutableList<Item105>
        } else {
            receipt = ReceiptBuilder.ReceiptBuilder12(taxation, clientInfo = ClientInfo()).build()
            receipt.email = email
            receipt.phone = phone
            receipt.items = items as MutableList<Item12>
        }
        return receipt
    }

    private fun parseReceiptItems(arguments: ArrayList<Map<String, Any>>?, receiptType: String): MutableList<Item> {
        val result: MutableList<Item> = ArrayList<Item>()
        for (i in arguments!!.indices) {
            val currentArguments = arguments[i]
            var item: Item? = null

            if (receiptType == "105") {
                item = parseItem105(currentArguments)
            } else {
                item = parseItem12(currentArguments)
            }
            result.add(item)
        }
        return result
    }

    private fun parseItem12(arguments: Map<String, Any>): Item {
        val price = (arguments["price"] as Double).toLong()
        val quantity = arguments["quantity"] as Double
        val name = arguments["name"] as String?
        val amount = (arguments["amount"] as Double).toLong()
        val tax = parseTax(arguments["tax"] as String?)


        return Item12(
            price = price,
            quantity = quantity,
            name = name,
            amount = amount,
            tax = tax,
            paymentMethod = PaymentMethod.FULL_PAYMENT,
            null,
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

    private fun parseItem105(arguments: Map<String, Any>): Item {
        val name = arguments["name"] as String
        val price = (arguments["price"] as Double).toLong()
        val quantity = arguments["quantity"] as Double
        val amount = (arguments["amount"] as Double).toLong()
        val tax = parseTax(arguments["tax"] as String)
        val ean13 = arguments["ean13"] as String?
        val shopCode = arguments["shopCode"] as String?
        val paymentMethod = parsePaymentMethod(arguments["paymentMethod"] as String?)
        val paymentObject = parsePaymentObject105(arguments["paymentObject"] as String?)

        return Item105(
            name,
            price,
            quantity,
            amount,
            tax,
            ean13,
            shopCode,
            paymentMethod,
            paymentObject,
        )

//        return Item12(
//            price = price,
//            quantity = quantity,
//            name = name,
//            amount = amount,
//            tax = tax,
//            paymentMethod = PaymentMethod.FULL_PAYMENT,
//            null,
//            null,
//            null,
//            null,
//            null,
//            null,
//            null,
//            "piece",
//            null,
//            null,
//            null,
//            null,
//        )
    }

    private fun parseOrderOptions(arguments: Map<String, Any>): OrderOptions {
        val orderOptions = OrderOptions()
        val orderId = arguments["orderId"] as String?
        val coins = (arguments["amount"] as Int).toLong()
        val reccurentPayment = arguments["reccurentPayment"] as Boolean?
        val title = arguments["title"] as String?
        val description = arguments["description"] as String?
        orderOptions.orderId = orderId!!
        orderOptions.recurrentPayment = reccurentPayment ?: false
        orderOptions.amount = ofCoins(coins)
        orderOptions.title = title
        orderOptions.description = description
        return orderOptions
    }

    private fun parseCustomerOptions(arguments: Map<String, Any>): CustomerOptions {
        val customerKey = arguments["customerKey"] as String?
        val email = arguments["email"] as String?
        val checkType = arguments["checkType"] as String?
        val customerOptions = CustomerOptions()
        customerOptions.customerKey = customerKey
        customerOptions.email = email
        customerOptions.checkType = checkType
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

    private fun parseLocalization(localization: String): Language {
        return when (localization) {
            "EN" -> Language.EN
            "RU" -> Language.RU
            else -> Language.RU
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
}
