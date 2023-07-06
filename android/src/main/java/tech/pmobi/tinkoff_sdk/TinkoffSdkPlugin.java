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
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;

import com.google.android.gms.wallet.WalletConstants;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
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
import kotlin.Unit;
import ru.tinkoff.acquiring.sdk.AcquiringSdk;
import ru.tinkoff.acquiring.sdk.TinkoffAcquiring;
import ru.tinkoff.acquiring.sdk.exceptions.AcquiringApiException;
import ru.tinkoff.acquiring.sdk.models.AsdkState;
import ru.tinkoff.acquiring.sdk.models.Card;
import ru.tinkoff.acquiring.sdk.models.DefaultState;
import ru.tinkoff.acquiring.sdk.models.GooglePayParams;
import ru.tinkoff.acquiring.sdk.models.enums.CardStatus;
import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions;
import ru.tinkoff.acquiring.sdk.models.options.screen.SavedCardsOptions;
import ru.tinkoff.acquiring.sdk.payment.PaymentListener;
import ru.tinkoff.acquiring.sdk.payment.PaymentState;
import ru.tinkoff.acquiring.sdk.requests.GetCardListRequest;
import ru.tinkoff.acquiring.sdk.utils.GooglePayHelper;

public class TinkoffSdkPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {
    private static final String TAG = "tinkoff_sdk";

    private static final int PAYMENT_REQUEST_CODE = 1001;
    private static final int ATTACH_CARD_REQUEST_CODE = 1002;
    private static final int QR_REQUEST_CODE = 1003;
    private static final int REQUEST_CAMERA_CARD_SCAN = 4123;
    private static final int GOOGLE_PAY_REQUEST_CODE = 5001;

    private Activity activity;
    private MethodChannel methodChannel;
    private Result result;

    private TinkoffAcquiring tinkoffAcquiring;
    private AcquiringSdk sdk;
    private TinkoffSdkParser parser;

    private GooglePayHelper googlePayHelper;
    private boolean isGooglePayEnabled = false;
    private PaymentOptions shadowPaymentOptions;

    private PaymentListener paymentListener = new PaymentListener() {
        @Override
        public void onSuccess(long l, @Nullable String s, @Nullable String s1) {
            if (result == null) return;

            shadowPaymentOptions = null;
            result.success(createResult(-1, null).toString());
            result = null;
        }

        @Override
        public void onUiNeeded(@NotNull AsdkState asdkState) {
            tinkoffAcquiring.openPaymentScreen(
                (FragmentActivity) activity,
                shadowPaymentOptions,
                PAYMENT_REQUEST_CODE,
                asdkState
            );
        }

        @Override
        public void onError(@NonNull Throwable throwable, @androidx.annotation.Nullable Long aLong) {
            if (result == null) return;
            final String locMessage = throwable.getLocalizedMessage();
            final String message = throwable.getMessage();
            result.error(locMessage, message, null);
            result = null;
        }

        @Override
        public void onStatusChanged(@Nullable PaymentState paymentState) {
            final String state = paymentState != null ? paymentState.toString() : "null";
            Log.i(TAG, "PaymentListener onStatusChanged: " + state);
        }
    };

    private PluginRegistry.ActivityResultListener activityResultListener = new PluginRegistry.ActivityResultListener() {

        @Override
        public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
            if (result != null) {

                if (requestCode == PAYMENT_REQUEST_CODE) {
                    result.success(createResult(resultCode, data).toString());
                    shadowPaymentOptions = null;
                    result = null;
                } else if (requestCode == ATTACH_CARD_REQUEST_CODE) {
                    result.success(null);
                    result = null;
                } else if (requestCode == QR_REQUEST_CODE) {
                    result.success(null);
                    result = null;
                } else if (requestCode == GOOGLE_PAY_REQUEST_CODE) {
                    handleGooglePayResult(resultCode, data);
                }
            }
            return false;
        }
    };

    private JSONObject createResult(int resultCode, Intent data) {
        JSONObject json = new JSONObject();
        String message;
        final boolean success = resultCode == -1;

        if (data != null && !success) {
            final Bundle bundle = data.getExtras();
            final AcquiringApiException exception = (AcquiringApiException) bundle.get(TinkoffAcquiring.EXTRA_ERROR);
                message = exception != null
                    ? exception.getLocalizedMessage()
                    : "Неизвестная ошибка";
        } else {
            message = success ? "Оплата прошла успешно" : "Закрытие экрана оплаты";
        }

        try {
            json.put("success", success);
            json.put("isError", resultCode > 0);
            json.put("message", message);
        } catch (JSONException ex) {
            ex.printStackTrace();
        }
        return json;
    }

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
            case "cardList":
                handleCardList(call);
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
            case "isNativePayAvailable":
                handleIsNativePayAvailable(call);
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
            final boolean nativePay = (boolean) arguments.get("nativePay");
            final boolean isDeveloperMode = (boolean) arguments.get("isDeveloperMode");
            final boolean isDebug = (boolean) arguments.get("isDebug");
            final String language = (String) arguments.get("language");
            AcquiringSdk.Companion.setDeveloperMode(isDeveloperMode);
            AcquiringSdk.Companion.setDebug(isDebug);

            parser = new TinkoffSdkParser(language);
            tinkoffAcquiring = new TinkoffAcquiring(activity.getApplicationContext(), terminalKey, publicKey);
            sdk = new AcquiringSdk(terminalKey, publicKey);
                sdk.init(initRequest -> Unit.INSTANCE);

            if (nativePay) {
                setupGooglePlay(terminalKey);
            }

            result.success(true);
        } catch (Exception e) {
            result.success(false);
        }
        result = null;
    }

    private void setupGooglePlay(@NonNull String terminalKey) {
        final GooglePayParams googleParams = new GooglePayParams(
            terminalKey,
            false,
            false,
            AcquiringSdk.Companion.isDebug()
                ? WalletConstants.ENVIRONMENT_TEST
                : WalletConstants.ENVIRONMENT_PRODUCTION
        );

        googlePayHelper = new GooglePayHelper(googleParams);

        Context context = activity.getApplicationContext();
        googlePayHelper.initGooglePay(
            context,
            isReady -> {
                isGooglePayEnabled = isReady;
                return Unit.INSTANCE;
            }
        );
    }

    private void handleCardList(MethodCall call) {
        try {
            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            final String customerKey = (String) arguments.get("customerKey");

            final GetCardListRequest request = sdk.getCardList(r -> {
                r.setCustomerKey(customerKey);
                return Unit.INSTANCE;
            });

            Thread thread = new Thread(() -> {
                request.execute(
                    response -> {
                        activity.runOnUiThread(() -> {
                            final Card[] cards = response.getCards();
                            final ArrayList<String> cardsList = new ArrayList();

                            for (final Card card : cards) {
                                if (card.getStatus() == CardStatus.ACTIVE) {
                                    JSONObject json = new JSONObject();
                                    try {
                                        json.put("cardId", card.getCardId());
                                        json.put("pan", card.getPan());
                                        json.put("expDate", card.getExpDate());
                                        cardsList.add(json.toString());
                                    } catch (JSONException ex) {
                                        ex.printStackTrace();
                                    }
                                }
                            }

                            result.success(cardsList);
                            result = null;
                        });
                        return Unit.INSTANCE;
                    },
                    e -> {
                        activity.runOnUiThread(() -> {
                            result.success(new ArrayList());
                            result = null;
                        });

                        return Unit.INSTANCE;
                    }
                );
            });
            thread.start();

        } catch (Exception e) {
            e.printStackTrace();
            result.success(new ArrayList());
            result = null;
        }
    }

    private void handleOpenPaymentScreen(MethodCall call) {
        try {
            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            final PaymentOptions paymentOptions = parser.createPaymentOptions(arguments);

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
            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            final SavedCardsOptions options = parser.createSavedCardOptions(arguments);

            tinkoffAcquiring.openSavedCardsScreen(
                (FragmentActivity) activity,
                options,
                ATTACH_CARD_REQUEST_CODE
            );
        } catch (Exception e) {
            result.error("Error opening AttachCardScreen", e.getMessage(), null);
            result = null;
        }
    }

    private void handleIsNativePayAvailable(MethodCall call) {
        result.success(isGooglePayEnabled);
        result = null;
    }

    private void handleShowQrScreen(MethodCall call) {
        //TODO: implement method
        result.notImplemented();
    }

    private void handleOpenNativePayment(MethodCall call) {
        if (isGooglePayEnabled) {
            @SuppressWarnings("unchecked")
            final Map<String, Object> arguments = (Map<String, Object>) call.arguments;
            shadowPaymentOptions = parser.createPaymentOptions(arguments);

            googlePayHelper.openGooglePay(
                activity,
                shadowPaymentOptions.getOrder().getAmount(),
                GOOGLE_PAY_REQUEST_CODE
            );
        } else {
            result.error("GooglePay is not available", "", null);
            result = null;
        }
    }

    private void handleGooglePayResult(int resultCode, Intent data) {
        if (data != null && resultCode == -1) {
            final String token = GooglePayHelper.getGooglePayToken(data);

            tinkoffAcquiring.initPayment(token, shadowPaymentOptions)
                .subscribe(paymentListener)
                .start();
        } else {
            result.success(createResult(resultCode, data).toString());
            result = null;
        }
    }

    private void handleStartCharge(MethodCall call) {
        //TODO: implement method
        result.notImplemented();
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
        methodChannel = new MethodChannel(messenger, TAG);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
    }
}