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

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.widget.Toast
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.PluginRegistry
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONObject
import ru.tinkoff.acquiring.sdk.AcquiringSdk
import ru.tinkoff.acquiring.sdk.TinkoffAcquiring
import ru.tinkoff.acquiring.sdk.models.options.CustomerOptions
import ru.tinkoff.acquiring.sdk.models.options.FeaturesOptions
import ru.tinkoff.acquiring.sdk.redesign.cards.attach.AttachCardLauncher
import ru.tinkoff.acquiring.sdk.redesign.cards.list.SavedCardsLauncher
import ru.tinkoff.acquiring.sdk.redesign.mainform.MainFormLauncher

class TinkoffSdkPlugin :
        MethodCallHandler,
        FlutterPlugin,
        ActivityAware,
        io.flutter.plugin.common.PluginRegistry.ActivityResultListener {
    private var methodChannel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private var tinkoffAcquiring: TinkoffAcquiring? = null
    private var parser: TinkoffSdkParser = TinkoffSdkParser()
    private lateinit var context: Context

    private var act: Activity? = null

    //    private val byMainFormPayment = registerForActivityResult(MainFormLauncher.Contract) {
    // result ->
    //        when (result) {
    //            is MainFormLauncher.Canceled -> toast("payment canceled")
    //            is MainFormLauncher.Error ->  toast(result.error.message ?:
    // getString(ru.tinkoff.acquiring.sdk.R.string.acq_banklist_title))
    //            is MainFormLauncher.Success ->  toast("payment Success-
    // paymentId:${result.paymentId}")
    //        }
    //    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (this.result != null) return
        this.result = result
        when (call.method) {
            "activate" -> handleActivate(call)
            "cardList" -> handleCardList(call)
            "openPaymentScreen" -> handleOpenPaymentScreen(call)
            "attachCardScreen" -> handleAttachCardScreen(call)
            "showStaticQrScreen" -> handleShowStaticQrScreen(call)
            "showDynamicQrScreen" -> handleShowDynamicQrScreen(call)
            "startCharge" -> handleStartCharge(call)
            else -> result.notImplemented()
        }
    }

    private fun handleActivate(call: MethodCall) {
        try {
            val arguments = call.arguments as Map<String, Any>
            // Get activation parameters.
            val terminalKey = arguments["terminalKey"] as String?
            val publicKey = arguments["publicKey"] as String?
            val isDeveloperMode = arguments["isDeveloperMode"] as Boolean? ?: false
            val isDebug = arguments["isDebug"] as Boolean? ?: false
            AcquiringSdk.isDeveloperMode = isDeveloperMode
            AcquiringSdk.isDebug = isDebug
            tinkoffAcquiring = TinkoffAcquiring(context, terminalKey!!, publicKey!!)
            result!!.success(true)
        } catch (e: Exception) {
            result!!.success(false)
        }
        result = null
    }

    private fun handleCardList(call: MethodCall) {
        try {
            val arguments = parser.createCardOptions(call.arguments as Map<String, Any>)

            val options =
                    tinkoffAcquiring!!.savedCardsOptions {
                        setTerminalParams(
                                arguments["terminalKey"] as String,
                                arguments["publicKey"] as String
                        )
                        customerOptions {
                            customerKey = (arguments["customer"] as CustomerOptions).customerKey
                            checkType = (arguments["customer"] as CustomerOptions).checkType
                            email = (arguments["customer"] as CustomerOptions).email
                        }
                        featuresOptions {
                            darkThemeMode = (arguments["features"] as FeaturesOptions).darkThemeMode
                            useSecureKeyboard =
                                    (arguments["features"] as FeaturesOptions).useSecureKeyboard
                            handleCardListErrorInSdk =
                                    (arguments["features"] as FeaturesOptions)
                                            .handleCardListErrorInSdk
                            fpsEnabled = (arguments["features"] as FeaturesOptions).fpsEnabled
                            tinkoffPayEnabled =
                                    (arguments["features"] as FeaturesOptions).tinkoffPayEnabled
                            yandexPayEnabled =
                                    (arguments["features"] as FeaturesOptions).yandexPayEnabled
                            userCanSelectCard =
                                    (arguments["features"] as FeaturesOptions).userCanSelectCard
                            showOnlyRecurrentCards =
                                    (arguments["features"] as FeaturesOptions)
                                            .showOnlyRecurrentCards
                            handleErrorsInSdk =
                                    (arguments["features"] as FeaturesOptions).handleErrorsInSdk
                            emailRequired = (arguments["features"] as FeaturesOptions).emailRequired
                            duplicateEmailToReceipt =
                                    (arguments["features"] as FeaturesOptions)
                                            .duplicateEmailToReceipt
                            validateExpiryDate =
                                    (arguments["features"] as FeaturesOptions).validateExpiryDate
                        }
                    }
            val intent = SavedCardsLauncher.Contract.createIntent(context, options)
            act?.startActivityForResult(intent, SAVED_CARDS_SCREEN)
        } catch (e: Exception) {
            Log.e(TAG, e.message!!, e)
            result!!.error("Error opening saved cards screen", e.message, null)
            result = null
        }
    }

    private fun handleOpenPaymentScreen(call: MethodCall) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val paymentOptions = parser.createPaymentOptions(arguments)

            val intent =
                    MainFormLauncher.Contract.createIntent(
                            context,
                            MainFormLauncher.StartData(paymentOptions)
                    )
            act?.startActivityForResult(intent, PAYMENT_SCREEN)
        } catch (e: Exception) {
            Log.e(TAG, e.message!!, e)
            result!!.error("Error opening payment screen", e.message, null)
            result = null
        }
    }

    private fun handleAttachCardScreen(call: MethodCall) {
        try {
            val arguments = parser.createCardOptions(call.arguments as Map<String, Any>)

            val options =
                    tinkoffAcquiring!!.attachCardOptions {
                        setTerminalParams(
                                arguments["terminalKey"] as String,
                                arguments["publicKey"] as String
                        )
                        customerOptions {
                            customerKey = (arguments["customer"] as CustomerOptions).customerKey
                            checkType = (arguments["customer"] as CustomerOptions).checkType
                            email = (arguments["customer"] as CustomerOptions).email
                        }
                        featuresOptions {
                            darkThemeMode = (arguments["features"] as FeaturesOptions).darkThemeMode
                            useSecureKeyboard =
                                    (arguments["features"] as FeaturesOptions).useSecureKeyboard
                            handleCardListErrorInSdk =
                                    (arguments["features"] as FeaturesOptions)
                                            .handleCardListErrorInSdk
                            fpsEnabled = (arguments["features"] as FeaturesOptions).fpsEnabled
                            tinkoffPayEnabled =
                                    (arguments["features"] as FeaturesOptions).tinkoffPayEnabled
                            yandexPayEnabled =
                                    (arguments["features"] as FeaturesOptions).yandexPayEnabled
                            userCanSelectCard =
                                    (arguments["features"] as FeaturesOptions).userCanSelectCard
                            showOnlyRecurrentCards =
                                    (arguments["features"] as FeaturesOptions)
                                            .showOnlyRecurrentCards
                            handleErrorsInSdk =
                                    (arguments["features"] as FeaturesOptions).handleErrorsInSdk
                            emailRequired = (arguments["features"] as FeaturesOptions).emailRequired
                            duplicateEmailToReceipt =
                                    (arguments["features"] as FeaturesOptions)
                                            .duplicateEmailToReceipt
                            validateExpiryDate =
                                    (arguments["features"] as FeaturesOptions).validateExpiryDate
                        }
                    }
            val intent = AttachCardLauncher.Contract.createIntent(context, options = options)
            act?.startActivityForResult(intent, ATTACH_CARD_SCREEN)
        } catch (e: Exception) {
            result!!.error("Error opening AttachCardScreen", e.message, null)
            result = null
        }
    }

    private fun handleShowStaticQrScreen(call: MethodCall) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val featuresOptions =
                    parser.parseFeatureOptions(arguments["featuresOptions"] as Map<String, Any>)
            tinkoffAcquiring!!.openStaticQrScreen(
                    activity = act!!,
                    featuresOptions = featuresOptions,
                    requestCode = STATIC_QR_CODE_SCREEN,
            )
        } catch (e: Exception) {
            Log.e(TAG, e.message!!, e)
            result!!.error("Error showing static QR code", e.message, null)
            result = null
        }
    }

    private fun handleShowDynamicQrScreen(call: MethodCall) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val paymentOptions = parser.createPaymentOptions(arguments)

            tinkoffAcquiring!!.openDynamicQrScreen(
                    activity = act!!,
                    options = paymentOptions,
                    requestCode = DYNAMIC_QR_CODE_SCREEN
            )
        } catch (e: Exception) {
            Log.e(TAG, e.message!!, e)
            result!!.error("Error showing dynamic QR code", e.message, null)
            result = null
        }
    }

    private fun handleStartCharge(call: MethodCall) {
        // TODO: implement method
        result!!.notImplemented()
    }

    companion object {
        private const val TAG = "tinkoff_sdk"
        private const val PAYMENT_SCREEN = 10
        private const val ATTACH_CARD_SCREEN = 11
        private const val STATIC_QR_CODE_SCREEN = 12
        private const val DYNAMIC_QR_CODE_SCREEN = 13
        private const val SAVED_CARDS_SCREEN = 14

        fun Activity.toast(message: String) = runOnUiThread {
            Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, TAG)
        methodChannel!!.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel!!.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        act = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        act = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK) {
            val json =
                    JSONObject(mapOf("success" to true, "isError" to false, "message" to "Success"))
                            .toString()
            result!!.success(json)
        } else if (resultCode == Activity.RESULT_CANCELED) {
            val json =
                    JSONObject(
                                    mapOf(
                                            "success" to false,
                                            "isError" to false,
                                            "message" to "Cancelled"
                                    )
                            )
                            .toString()
            result!!.success(json)
        }
        result = null
        return true
    }
}
