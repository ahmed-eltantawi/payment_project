import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_project/Features/checkout/presentation/manager/payment_cubit/payment_cubit.dart';
import 'package:payment_project/Features/checkout/presentation/views/thank_you_view.dart';
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
            BlocConsumer<PaymentCubit, PaymentState>(
              listener: (context, state) {
                if (state is PaymentError) {
                  showSnackBar(context, state.error);
                } else if (state is PaymentSuccess) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return const ThankYouView();
                    },
                  ));
                }
              },
              builder: (context, state) {
                if (state is PaymentLoading) {
                  return const CustomButton(
                    isLoading: true,
                    text: '',
                  );
                } else {
                  return CustomButton(
                      text: 'Continue',
                      onTap: () {
                        context.read<PaymentCubit>().pay(
                            context: context, amount: 100, currency: "EGP");
                      });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
