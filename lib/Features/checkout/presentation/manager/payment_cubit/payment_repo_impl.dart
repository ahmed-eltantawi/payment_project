import 'package:payment_project/core/functions/snak_bar.dart';
import 'package:payment_project/core/services/payment/paymob_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentRepoImpl {
  Future<void> payWithPaymob({context}) async {
    final paymentKey =
        await PaymobManager().getPaymentKey(amount: 10, currency: "EGP");
    paymentKey.fold((failure) => showSnackBar(context, failure),
        (paymentKey) async {
      await launchUrl(Uri.parse(
          "https://accept.paymob.com/api/acceptance/iframes/1057330?payment_token=$paymentKey"));
    });
  }
}
