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

package tech.pmobi.tinkoff_sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;

import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import ru.tinkoff.acquiring.sdk.AcquiringSdk;
import ru.tinkoff.acquiring.sdk.TinkoffAcquiring;
import ru.tinkoff.acquiring.sdk.localization.AsdkSource;
import ru.tinkoff.acquiring.sdk.localization.Language;
import ru.tinkoff.acquiring.sdk.models.DarkThemeMode;
import ru.tinkoff.acquiring.sdk.models.DefaultState;
import ru.tinkoff.acquiring.sdk.models.options.CustomerOptions;
import ru.tinkoff.acquiring.sdk.models.options.FeaturesOptions;
import ru.tinkoff.acquiring.sdk.models.options.OrderOptions;
import ru.tinkoff.acquiring.sdk.models.options.screen.AttachCardOptions;
import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions;
import ru.tinkoff.acquiring.sdk.utils.Money;

public class TinkoffSdkPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {
    private static final String TAG = "TinkoffSdkPlugin.java";

    private static final int PAYMENT_REQUEST_CODE = 1001;
    private static final int ATTACH_CARD_REQUEST_CODE = 1002;
    private static final int QR_REQUEST_CODE = 1003;
    private static final int REQUEST_CAMERA_CARD_SCAN = 4123;

    private Activity activity;
    private MethodChannel methodChannel;
    private Result result;

    private TinkoffAcquiring tinkoffAcquiring;
    private String activeLanguage;

    private PluginRegistry.ActivityResultListener activityResultListener = new PluginRegistry.ActivityResultListener() {
        @Override
        public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
            if (result != null) {
                if (requestCode == PAYMENT_REQUEST_CODE) {
                    result.success(resultCode == -1);
                    result = null;
                } else if (requestCode == ATTACH_CARD_REQUEST_CODE) {
                    result.success(resultCode == -1);
                    result = null;
                } else if (requestCode == QR_REQUEST_CODE) {
                    result.success(null);
                    result = null;
                }
            }
            return false;
        }
    };

    // Supporting FlutterEmbedding v1
    public static void registerWith(Registrar registrar) {
        final TinkoffSdkPlugin instance = new TinkoffSdkPlugin();
        registrar.addActivityResultListener(instance.activityResultListener);
        instance.activity = registrar.activity();
        instance.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (this.result != null) return;
        if (!(activity instanceof FragmentActivity)) {
            result.error(
            "no_fragment_activity",
            "plugin requires activity to be a FragmentActivity.",
            null);
            return;
        }

        this.result = result;

        switch (call.method) {
            case "activate":
                handleActivate(call);
                break;
            case "openPaymentScreen":
                handleOpenPaymentScreen(call);
                break;
            case "attachCardScreen":
                handleAttachCardScreen(call);
                break;
            case "showQrScreen":
                handleShowQrScreen(call);
                break;
            case "openNativePayment":
                handleOpenNativePayment(call);
                break;
            case "startCharge":
                handleStartCharge(call);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleActivate(MethodCall call) {
        try {
            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            // Get activation parameters.
            final String terminalKey = (String) arguments.get("terminalKey");
            final String password = (String) arguments.get("password");
            final String publicKey = (String) arguments.get("publicKey");
            final boolean isDeveloperMode = (boolean) arguments.get("isDeveloperMode");
            final boolean isDebug = (boolean) arguments.get("isDebug");
            final String language = (String) arguments.get("language");

            AcquiringSdk.AsdkLogger.setDeveloperMode(isDeveloperMode);
            AcquiringSdk.AsdkLogger.setDebug(isDebug);
            activeLanguage = language;

            tinkoffAcquiring = new TinkoffAcquiring(terminalKey, password, publicKey);
            result.success(true);
        } catch (Exception e) {
            result.success(false);
        }
        result = null;
    }

    private void handleOpenPaymentScreen(MethodCall call) {
        try {
            final PaymentOptions paymentOptions = new PaymentOptions();

            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;

            // Get payment parameters.
            @SuppressWarnings("unchecked")
            final Map<String, Object> orderOptionsArguments = (Map<String, Object>) arguments.get("orderOptions");
            final OrderOptions order = parseOrderOptions(orderOptionsArguments);
            paymentOptions.setOrder(order);

            @SuppressWarnings("unchecked")
            final Map<String, Object> customerOptionsArguments = (Map<String, Object>) arguments.get("customerOptions");
            final CustomerOptions customer = parseCustomerOptions(customerOptionsArguments);
            paymentOptions.setCustomer(customer);

            @SuppressWarnings("unchecked")
            final Map<String, Object> featuresOptionsArguments = (Map<String, Object>) arguments.get("featuresOptions");
            if (featuresOptionsArguments != null) {
                final FeaturesOptions features = parseFeatureOptions(featuresOptionsArguments);
                paymentOptions.setFeatures(features);
            }

            tinkoffAcquiring.openPaymentScreen(
                (FragmentActivity) activity,
                paymentOptions,
                PAYMENT_REQUEST_CODE,
                DefaultState.INSTANCE
            );

        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            result.error("Error opening payment screen", e.getMessage(), null);
            result = null;
        }
    }

    private void handleAttachCardScreen(MethodCall call) {
        try {
            final AttachCardOptions options = new AttachCardOptions();

            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;

            @SuppressWarnings("unchecked")
            final Map<String, Object> customerOptionsArguments = (Map<String, Object>) arguments.get("customerOptions");
            final CustomerOptions customer = parseCustomerOptions(customerOptionsArguments);
            options.setCustomer(customer);

            @SuppressWarnings("unchecked")
            final Map<String, Object> featuresOptionsArguments = (Map<String, Object>) arguments.get("featuresOptions");
            if (featuresOptionsArguments != null) {
                final FeaturesOptions features = parseFeatureOptions(featuresOptionsArguments);
                options.setFeatures(features);
            }

            tinkoffAcquiring.openAttachCardScreen(
                (FragmentActivity) activity,
                options,
                ATTACH_CARD_REQUEST_CODE
            );
        } catch (Exception e) {
            result.error("Error opening AttachCardScreen", e.getMessage(), null);
            result = null;
        }
    }

    private void handleShowQrScreen(MethodCall call) {
        //TODO: implement method
        result.notImplemented();
//        try {
//            tinkoffAcquiring.openStaticQrScreen(
//                (FragmentActivity) activity,
//                new AsdkSource(parseLocalization(activeLanguage)),
//                QR_REQUEST_CODE
//            );
//        } catch (Exception e) {
//            result.error("Error opening QRScreen", e.getMessage(), null);
//            result = null;
//        }
    }

    private void handleOpenNativePayment(MethodCall call) {
        //TODO: implement method
        result.notImplemented();
    }

    private void handleStartCharge(MethodCall call) {
        //TODO: implement method
        result.notImplemented();
    }

    private OrderOptions parseOrderOptions(Map<String, Object> arguments) {
        final OrderOptions orderOptions = new OrderOptions();

        final Integer orderId = (Integer) arguments.get("orderId");
        final long coins = (int) arguments.get("amount");
        final String title = (String) arguments.get("title");
        final String description = (String) arguments.get("description");
        final boolean reccurentPayment = (boolean) arguments.get("reccurentPayment");

        orderOptions.setOrderId(String.valueOf(orderId));
        orderOptions.setRecurrentPayment(reccurentPayment);
        orderOptions.setAmount(Money.Companion.ofCoins(coins));
        orderOptions.setTitle(title);
        orderOptions.setDescription(description);

        return orderOptions;
    }

    private CustomerOptions parseCustomerOptions(Map<String, Object> arguments) {
        final String customerKey = (String) arguments.get("customerKey");
        final String email = (String) arguments.get("email");
        final String checkType = (String) arguments.get("checkType");

        final CustomerOptions customerOptions = new CustomerOptions();
        customerOptions.setCustomerKey(customerKey);
        customerOptions.setEmail(email);
        customerOptions.setCheckType(checkType);

        return customerOptions;
    }

    private FeaturesOptions parseFeatureOptions(Map<String, Object> arguments) {
        final boolean fpsEnabled = (boolean) arguments.get("fpsEnabled");
        final boolean useSecureKeyboard = (boolean) arguments.get("useSecureKeyboard");
        final boolean handleCardListErrorInSdk = (boolean) arguments.get("handleCardListErrorInSdk");
        final boolean enableCameraCardScanner = (boolean) arguments.get("enableCameraCardScanner");
        final String darkThemeMode = (String) arguments.get("darkThemeMode");

        DarkThemeMode darkMode;
        switch (darkThemeMode) {
            case "ENABLED":
                darkMode = DarkThemeMode.ENABLED;
                break;
            case "DISABLED":
                darkMode = DarkThemeMode.DISABLED;
                break;
            case "AUTO":
            default:
                darkMode = DarkThemeMode.AUTO;
                break;
        }

        final FeaturesOptions featuresOptions = new FeaturesOptions();

        featuresOptions.setFpsEnabled(fpsEnabled);
        featuresOptions.setUseSecureKeyboard(useSecureKeyboard);
        featuresOptions.setLocalizationSource(new AsdkSource(parseLocalization(activeLanguage)));
        featuresOptions.setHandleCardListErrorInSdk(handleCardListErrorInSdk);
        if (enableCameraCardScanner) {
            featuresOptions.setCameraCardScanner(new TinkoffSdkCardScanner(activeLanguage));
        }
        featuresOptions.setDarkThemeMode(darkMode);
        return featuresOptions;
    }

    private Language parseLocalization(String localization) {
        switch (localization) {
            case "EN":
                return Language.EN;
            case "RU":
            default:
                return Language.RU;
        }
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(activityResultListener);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "tinkoff_sdk");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
    }
}