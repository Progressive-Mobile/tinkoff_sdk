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

import java.util.Map;

import ru.tinkoff.acquiring.sdk.localization.AsdkSource;
import ru.tinkoff.acquiring.sdk.localization.Language;
import ru.tinkoff.acquiring.sdk.models.DarkThemeMode;
import ru.tinkoff.acquiring.sdk.models.options.CustomerOptions;
import ru.tinkoff.acquiring.sdk.models.options.FeaturesOptions;
import ru.tinkoff.acquiring.sdk.models.options.OrderOptions;
import ru.tinkoff.acquiring.sdk.models.options.screen.AttachCardOptions;
import ru.tinkoff.acquiring.sdk.models.options.screen.PaymentOptions;
import ru.tinkoff.acquiring.sdk.models.options.screen.SavedCardsOptions;
import ru.tinkoff.acquiring.sdk.utils.Money;

class TinkoffSdkParser {
    private final String language;

    TinkoffSdkParser(String language) {
        this.language = language;
    }

    SavedCardsOptions createSavedCardOptions(Map<String, Object> arguments) {
        final SavedCardsOptions options = new SavedCardsOptions();

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

        return options;
    }

    PaymentOptions createPaymentOptions(Map<String, Object> arguments) {
        final PaymentOptions paymentOptions = new PaymentOptions();

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
        return paymentOptions;
    }

    OrderOptions parseOrderOptions(Map<String, Object> arguments) {
        final OrderOptions orderOptions = new OrderOptions();

        final String orderId = (String) arguments.get("orderId");
        final long coins = (int) arguments.get("amount");
        final String title = (String) arguments.get("title");
        final String description = (String) arguments.get("description");
        final boolean reccurentPayment = (boolean) arguments.get("reccurentPayment");

        orderOptions.setOrderId(orderId);
        orderOptions.setRecurrentPayment(reccurentPayment);
        orderOptions.setAmount(Money.Companion.ofCoins(coins));
        orderOptions.setTitle(title);
        orderOptions.setDescription(description);

        return orderOptions;
    }

    CustomerOptions parseCustomerOptions(Map<String, Object> arguments) {
        final String customerKey = (String) arguments.get("customerKey");
        final String email = (String) arguments.get("email");
        final String checkType = (String) arguments.get("checkType");

        final CustomerOptions customerOptions = new CustomerOptions();
        customerOptions.setCustomerKey(customerKey);
        customerOptions.setEmail(email);
        customerOptions.setCheckType(checkType);

        return customerOptions;
    }

    FeaturesOptions parseFeatureOptions(Map<String, Object> arguments) {
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
        featuresOptions.setLocalizationSource(new AsdkSource(parseLocalization(language)));
        featuresOptions.setHandleCardListErrorInSdk(handleCardListErrorInSdk);
        if (enableCameraCardScanner) {
            featuresOptions.setCameraCardScanner(new TinkoffSdkCardScanner(language));
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
}
