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

import ru.tinkoff.cardio.R;
import ru.tinkoff.cardio.BuildConfig;
import ru.tinkoff.cardio.CameraCardIOScanner;

import ru.tinkoff.acquiring.sdk.cardscanners.CameraCardScanner;
import ru.tinkoff.acquiring.sdk.cardscanners.models.AsdkScannedCardData;
import ru.tinkoff.acquiring.sdk.cardscanners.models.ScannedCardData;

//public class TinkoffSdkCardScanner implements CameraCardScanner {
//    private final String locale;
//
//    TinkoffSdkCardScanner(String locale) {
//        switch (locale) {
//            case "EN":
//                this.locale = "en";
//                break;
//            case "RU":
//            default:
//                this.locale = "ru_RU";
//        }
//    }
//
//    @Override
//    public boolean hasResult(Intent data) {
//        return data != null && data.hasExtra(CardIOActivity.EXTRA_SCAN_RESULT);
//    }
//
//    @Override
//    public ScannedCardData parseIntentData(Intent data) {
//        CreditCard scanResult = data.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT);
//
//        final String cardNumber = scanResult.getRedactedCardNumber();
//        final String expireDate = scanResult.expiryMonth + "/" + scanResult.expiryYear;
//        final String cardholder = scanResult.cardholderName;
//
//        return new AsdkScannedCardData(
//            cardNumber,
//            expireDate,
//            cardholder
//        );
//    }
//
//    @Override
//    public void startActivityForScanning(Context context, int requestCode) {
//        Intent scanIntent = new Intent(context, CardIOActivity.class);
//
//        scanIntent.putExtra(CardIOActivity.EXTRA_LANGUAGE_OR_LOCALE, locale);
//        scanIntent.putExtra(CardIOActivity.EXTRA_SUPPRESS_CONFIRMATION, false);
//        scanIntent.putExtra(CardIOActivity.EXTRA_USE_PAYPAL_ACTIONBAR_ICON, false);
//        scanIntent.putExtra(CardIOActivity.EXTRA_SCAN_INSTRUCTIONS, false);
//        scanIntent.putExtra(CardIOActivity.EXTRA_HIDE_CARDIO_LOGO, true);
//        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CARDHOLDER_NAME, true);
//        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY, true);
//        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CVV, false);
//        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_POSTAL_CODE, false);
//
//        ((Activity) context).startActivityForResult(scanIntent, requestCode);
//    }
//}