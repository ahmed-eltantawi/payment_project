import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment_project/Features/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:payment_project/core/services/payment/paymob/paymob_manager.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  int paymentGetawayIndex = 0;

  Future<void> pay(
      {required context,
      required double amount,
      required String currency}) async {
    emit(PaymentLoading());

    final result = await paymentGetaways[paymentGetawayIndex].makePayment(
      context: context,
      amount: amount,
      currency: currency,
    );
    result.fold((failure) => emit(PaymentError(error: failure)), (r) {
      if (paymentGetaways[paymentGetawayIndex] is PaymobManager) {
        // because paymob is used as webview so we don't know yet if the payment is done or not
        emit(PaymentLoadingDone());
      } else {
        emit(PaymentSuccess());
      }
    });
  }
}
