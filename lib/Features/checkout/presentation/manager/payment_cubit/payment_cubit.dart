import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment_project/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:payment_project/core/services/payment/paymob/paymob_manager.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  int paymentGetawayIndex = PaymentGetaway.paymob.index;

  Future<void> pay(
      {required context,
      required double amount,
      required String currency}) async {
    log("paymentLoading");
    emit(PaymentLoading());
    try {
      if (paymentGetawayIndex == PaymentGetaway.paymob.index) {
        await PaymobManager.makePayment(
            context: context, amount: amount, currency: currency);
      } else if (paymentGetawayIndex == PaymentGetaway.paypal.index) {
        // pay with paypal
      } else if (paymentGetawayIndex == PaymentGetaway.stripe.index) {
        // pay with stripe
      }
      log("paymentSuccess");
      emit(PaymentSuccess());
    } on Exception catch (e) {
      log("paymentError");
      emit(PaymentError(error: e.toString()));
    }
  }
}
