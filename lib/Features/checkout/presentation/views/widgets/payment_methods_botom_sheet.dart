import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_project/Features/checkout/presentation/manager/payment_cubit/payment_cubit.dart';
import 'package:payment_project/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:payment_project/core/widgets/custom_button.dart';

import '../../../../../core/functions/snak_bar.dart';

class PaymentMethodsBottomSheet extends StatelessWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocProvider(
        create: (context) => PaymentCubit(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const PaymentMethodsListView(),
            const SizedBox(height: 32),
            BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                var customButton = CustomButton(
                    text: 'Continue',
                    onTap: () {
                      log("pressed");
                      context
                          .read<PaymentCubit>()
                          .pay(context: context, amount: 1000, currency: "EGP");
                    });
                if (state is PaymentLoading) {
                  log("loading");
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PaymentError) {
                  showSnackBar(context, state.error);
                  return customButton;
                } else {
                  return customButton;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
