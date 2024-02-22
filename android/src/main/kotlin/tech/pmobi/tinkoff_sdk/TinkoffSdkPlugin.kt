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

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.fragment.app.FragmentActivity
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.PluginRegistry
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONException
import org.json.JSONObject
import ru.tinkoff.acquiring.sdk.AcquiringSdk
import ru.tinkoff.acquiring.sdk.TinkoffAcquiring
import ru.tinkoff.acquiring.sdk.models.enums.CardStatus
import ru.tinkoff.acquiring.sdk.models.enums.CheckType
import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions
import ru.tinkoff.acquiring.sdk.redesign.mainform.MainFormLauncher
import ru.tinkoff.acquiring.sdk.responses.GetCardListResponse
import ru.tinkoff.acquiring.sdk.utils.Money

class TinkoffSdkPlugin : MethodCallHandler, FlutterPlugin, ActivityAware,
    io.flutter.plugin.common.PluginRegistry.ActivityResultListener {
    private var methodChannel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private var tinkoffAcquiring: TinkoffAcquiring? = null
    private var parser: TinkoffSdkParser = TinkoffSdkParser()
    private lateinit var context: Context


    private var act: Activity? = null

//    private val byMainFormPayment = registerForActivityResult(MainFormLauncher.Contract) { result ->
//        when (result) {
//            is MainFormLauncher.Canceled -> toast("payment canceled")
//            is MainFormLauncher.Error ->  toast(result.error.message ?: getString(ru.tinkoff.acquiring.sdk.R.string.acq_banklist_title))
//            is MainFormLauncher.Success ->  toast("payment Success-  paymentId:${result.paymentId}")
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
            "showQrScreen" -> handleShowQrScreen(call)
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
            tinkoffAcquiring = TinkoffAcquiring(
                context,
                terminalKey!!, publicKey!!
            )
            result!!.success(true)
        } catch (e: Exception) {
            result!!.success(false)
        }
        result = null
    }

    private fun handleCardList(call: MethodCall) {
        try {
//            val request = tinkoffAcquiring!!.sdk.getCardList { }
//            val thread = Thread {
//                request.execute(
//                    { response: GetCardListResponse ->
//                        this.runOnUiThread {
//                            val cards =
//                                response.cards
//                            val cardsList: ArrayList<Any?> =
//                                ArrayList<Any?>()
//                            for ((pan, cardId, expDate, status) in cards) {
//                                if (status == CardStatus.ACTIVE) {
//                                    val json = JSONObject()
//                                    try {
//                                        json.put("cardId", cardId)
//                                        json.put("pan", pan)
//                                        json.put("expDate", expDate)
//                                        cardsList.add(json.toString())
//                                    } catch (ex: JSONException) {
//                                        ex.printStackTrace()
//                                    }
//                                }
//                            }
//                            result!!.success(cardsList)
//                            result = null
//                        }
//                    }
//                ) { _: Exception? ->
//                    this.runOnUiThread {
//                        result!!.success(ArrayList<Any?>())
//                        result = null
//                    }
//                }
//            }
//            thread.start()
        } catch (e: Exception) {
            e.printStackTrace()
            result!!.success(ArrayList<Any?>())
            result = null
        }
    }

    private fun handleOpenPaymentScreen(call: MethodCall) {
        try {
            val arguments = call.arguments as Map<String?, Any?>
            val paymentOptions = parser.createPaymentOptions(arguments)
            val data = MainFormLauncher.StartData(paymentOptions)

            val intent = MainFormLauncher.Contract.createIntent(context, MainFormLauncher.StartData(paymentOptions))
            act?.startActivityForResult(intent, 71)
//            result!!.success(true)
            result = null
        } catch (e: Exception) {
            Log.e(TAG, e.message!!, e)
            result!!.error("Error opening payment screen", e.message, null)
            result = null
        }
    }

    private fun handleAttachCardScreen(call: MethodCall) {
        try {
            val arguments = call.arguments as Map<String?, Any?>
            val options = parser.createSavedCardOptions(arguments)

//            tinkoffAcquiring.openSavedCardsScreen(
//                    (FragmentActivity) activity,
//                    options,
//                    ATTACH_CARD_REQUEST_CODE
//            );
        } catch (e: Exception) {
            result!!.error("Error opening AttachCardScreen", e.message, null)
            result = null
        }
    }

    private fun handleShowQrScreen(call: MethodCall) {
        //TODO: implement method
        result!!.notImplemented()
    }

    private fun handleStartCharge(call: MethodCall) {
        //TODO: implement method
        result!!.notImplemented()
    }

    companion object {
        private const val TAG = "tinkoff_sdk"
        private const val PAYMENT_SUCCESSFULL = 10

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
        act = null;
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        act = null;
    }

//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        return false
//    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PAYMENT_SUCCESSFULL) {
            if (resultCode == Activity.RESULT_OK) {
                result!!.success(true)
            }
            result = null
        }
        return true
    }
}