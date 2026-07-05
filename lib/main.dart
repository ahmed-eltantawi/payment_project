import 'package:payment_project/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:flutter/material.dart';

import 'core/services/services_locator.dart';

void main() async {
  // main
  await setupServiceLocator();
  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCartView(),
    );
  }
}
