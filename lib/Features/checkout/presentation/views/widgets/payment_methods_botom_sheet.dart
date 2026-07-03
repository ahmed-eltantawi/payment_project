import 'package:flutter/material.dart';
import 'package:payment_project/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:payment_project/core/services/payment/paymob_manager.dart';
import 'package:payment_project/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentMethodsBottomSheet extends StatelessWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const PaymentMethodsListView(),
          const SizedBox(height: 32),
          CustomButton(text: 'Continue', onTap: _pay),
        ],
      ),
    );
  }

  void _pay() async {
    final String paymentKey =
        await PaymobManager().getPaymentKey(amount: 50.97, currency: "EGP");

    await launchUrl(Uri.parse(
        "https://accept.paymob.com/api/acceptance/iframes/1057330?payment_token=$paymentKey"));
  }
}
