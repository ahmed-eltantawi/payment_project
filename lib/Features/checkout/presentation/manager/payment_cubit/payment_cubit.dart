import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment_project/Features/checkout/presentation/manager/payment_cubit/payment_repo_impl.dart';
import 'package:payment_project/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  final PaymentRepoImpl paymentRepoImpl = PaymentRepoImpl();

  int paymentGetawayIndex = PaymentGetaway.paymob.index;

  Future<void> pay(context) async {
    log("paymentLoading");
    emit(PaymentLoading());
    try {
      if (paymentGetawayIndex == PaymentGetaway.paymob.index) {
        await paymentRepoImpl.payWithPaymob(context: context);
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
