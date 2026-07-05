import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_project/Features/checkout/presentation/manager/payment_cubit/payment_cubit.dart';
import 'package:payment_project/Features/checkout/presentation/views/widgets/payment_method_item.dart';
import 'package:flutter/material.dart';

enum PaymentGetaway { paymob, paypal, stripe }

class PaymentMethodsListView extends StatefulWidget {
  const PaymentMethodsListView({super.key});

  @override
  State<PaymentMethodsListView> createState() => _PaymentMethodsListViewState();
}

class _PaymentMethodsListViewState extends State<PaymentMethodsListView> {
  final List<String> paymentMethodsItems = const [
    'assets/images/card.svg',
    'assets/images/paypal.svg',
    'assets/images/stripe.svg',
  ];

  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ListView.builder(
        itemCount: paymentMethodsItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                context.read<PaymentCubit>().paymentGetawayIndex = index;
                setState(() {
                  activeIndex = index;
                });
              },
              child: PaymentMethodItem(
                isActive: activeIndex == index,
                image: paymentMethodsItems[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
