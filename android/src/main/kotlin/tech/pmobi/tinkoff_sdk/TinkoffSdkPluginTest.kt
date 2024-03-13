package tech.pmobi.tinkoff_sdk

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import tech.pmobi.tinkoff_sdk.TinkoffSdkPlugin

//package tech.pmobi.tinkoff_sdk
//
//
//import android.app.Activity
//import android.content.Context
//import androidx.activity.result.ActivityResultCallback
//import androidx.activity.result.contract.ActivityResultContracts
//import androidx.fragment.app.FragmentActivity
//import io.flutter.Log
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.embedding.engine.plugins.FlutterPlugin
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler
//import ru.tinkoff.acquiring.sdk.AcquiringSdk
//import ru.tinkoff.acquiring.sdk.TinkoffAcquiring
//import ru.tinkoff.acquiring.sdk.models.enums.CheckType
//import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions
//import ru.tinkoff.acquiring.sdk.payment.PaymentByCardProcess
//import ru.tinkoff.acquiring.sdk.redesign.mainform.MainFormLauncher
//import ru.tinkoff.acquiring.sdk.threeds.ThreeDsHelper
//import ru.tinkoff.acquiring.sdk.utils.Money
//
//class TinkoffSdkPlugin : FragmentActivity() {
//    private val tag = "tinkoff_sdk"
//
//    private var methodChannel: MethodChannel? = null
//    private var result: MethodChannel.Result? = null
//    private var tinkoffAcquiring: TinkoffAcquiring? = null
//    private var parser: TinkoffSdkParser = TinkoffSdkParser()
//
//    private val byMainFormPayment = registerForActivityResult(MainFormLauncher.Contract) { result ->
//        when (result) {
//            is MainFormLauncher.Canceled -> Log.d(tag, "payment canceled")
//            is MainFormLauncher.Error ->  Log.d(tag, result.error.message ?: getString(ru.tinkoff.acquiring.sdk.R.string.acq_banklist_title))
//            is MainFormLauncher.Success ->  Log.d(tag, "payment Success-  paymentId:${result.paymentId}")
//        }
//    }
//
//    public fun onMethodCall(call: MethodCall, result: MethodChannel.Result, context: Context) {
//        this.result = result
//        when (call.method) {
//            "activate" -> handleActivate(call, context)
//            "openPaymentScreen" -> handleOpenPaymentScreen(call)
//            else -> result.notImplemented()
//        }
//    }
//
//    private fun handleActivate(call: MethodCall, context: Context) {
//        try {
//            val arguments = call.arguments as Map<String, Any>
//            // Get activation parameters.
//            val terminalKey = arguments["terminalKey"] as String?
//            val publicKey = arguments["publicKey"] as String?
//            val isDeveloperMode = arguments["isDeveloperMode"] as Boolean? ?: false
//            val isDebug = arguments["isDebug"] as Boolean? ?: false
//            AcquiringSdk.isDeveloperMode = false
//            AcquiringSdk.isDebug = false
//            tinkoffAcquiring = TinkoffAcquiring(
//                context,
//                terminalKey!!,
//                publicKey!!,
//            )
//
//            result!!.success(true)
//        } catch (e: Exception) {
//            result!!.error("Error activating Tinkoff SDK", e.message, null)
//        }
//        result = null
//    }
//
//    private fun handleOpenPaymentScreen(call: MethodCall) {
//        try {
//            val arguments = call.arguments as Map<String?, Any?>
//            val paymentOptions = parser.createPaymentOptions(arguments)
//
//            byMainFormPayment.launch(MainFormLauncher.StartData(paymentOptions))
//        } catch (e: Exception) {
//            Log.e(tag, e.message!!, e)
//            result!!.error("Error opening payment screen", e.message, null)
//            result = null
//        }
//    }
//
////    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//        methodChannel = MethodChannel(binding.binaryMessenger, tag)
//        methodChannel!!.setMethodCallHandler(this)
////    }
////
////    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
////        methodChannel!!.setMethodCallHandler(null)
////        methodChannel = null
////    }
//}
//
//class TinkoffSDK : FlutterPlugin {
//    private var plugin: TinkoffSdkPlugin? = null
//
//    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//        plugin = TinkoffSdkPlugin()
//        MethodChannel(binding.binaryMessenger, "tinkoff_sdk")
//            .setMethodCallHandler {call, result -> plugin!!.onMethodCall(call, result)}
//    }
//
//    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//        MethodChannel(binding.binaryMessenger, "tinkoff_sdk")
//            .setMethodCallHandler { _, _ -> null}
//    }
//
//}