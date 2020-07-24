package tech.pmobi.tinkoff_sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import io.card.payment.CardIOActivity;
import io.card.payment.CreditCard;
import ru.tinkoff.acquiring.sdk.cardscanners.CameraCardScanner;
import ru.tinkoff.acquiring.sdk.cardscanners.models.AsdkScannedCardData;
import ru.tinkoff.acquiring.sdk.cardscanners.models.ScannedCardData;

public class TinkoffSdkCardScanner implements CameraCardScanner {
    private final String locale;

    TinkoffSdkCardScanner(String locale) {
        switch (locale) {
            case "EN":
                this.locale = "en";
                break;
            case "RU":
            default:
                this.locale = "ru_RU";
        }
    }

    @Override
    public boolean hasResult(Intent data) {
        return data != null && data.hasExtra(CardIOActivity.EXTRA_SCAN_RESULT);
    }

    @Override
    public ScannedCardData parseIntentData(Intent data) {
        CreditCard scanResult = data.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT);

        final String cardNumber = scanResult.getRedactedCardNumber();
        final String expireDate = scanResult.expiryMonth + "/" + scanResult.expiryYear;
        final String cardholder = scanResult.cardholderName;

        return new AsdkScannedCardData(
            cardNumber,
            expireDate,
            cardholder
        );
    }

    @Override
    public void startActivityForScanning(Context context, int requestCode) {
        Intent scanIntent = new Intent(context, CardIOActivity.class);

        scanIntent.putExtra(CardIOActivity.EXTRA_LANGUAGE_OR_LOCALE, locale);
        scanIntent.putExtra(CardIOActivity.EXTRA_SUPPRESS_CONFIRMATION, false);
        scanIntent.putExtra(CardIOActivity.EXTRA_USE_PAYPAL_ACTIONBAR_ICON, false);
        scanIntent.putExtra(CardIOActivity.EXTRA_SCAN_INSTRUCTIONS, false);
        scanIntent.putExtra(CardIOActivity.EXTRA_HIDE_CARDIO_LOGO, true);
        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CARDHOLDER_NAME, true);
        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY, true);
        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CVV, false);
        scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_POSTAL_CODE, false);

        ((Activity) context).startActivityForResult(scanIntent, requestCode);
    }
}