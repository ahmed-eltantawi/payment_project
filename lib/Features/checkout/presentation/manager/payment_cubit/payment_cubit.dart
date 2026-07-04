import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment_project/Features/checkout/presentation/manager/payment_cubit/payment_repo_impl.dart';
import 'package:payment_project/core/functions/snak_bar.dart';
import 'package:payment_project/core/services/payment/paymob_manager.dart';
import 'package:url_launcher/url_launcher.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  final PaymentRepoImpl paymentRepoImpl = PaymentRepoImpl();

  int paymentGetawayIndex = PaymentGetaway.paymob.index;

  Future<void> pay(context) async {
    emit(PaymentLoading());
    try {
      if (paymentGetawayIndex == PaymentGetaway.paymob.index) {
        await paymentRepoImpl.payWithPaymob(context: context);
      } else if (paymentGetawayIndex == PaymentGetaway.paypal.index) {
        // pay with paypal
      } else if (paymentGetawayIndex == PaymentGetaway.stripe.index) {
        // pay with stripe
      }
      emit(PaymentSuccess());
    } on Exception catch (e) {
      emit(PaymentError(error: e.toString()));
    }
  }
}

enum PaymentGetaway { paymob, paypal, stripe }
