part of 'payment_cubit.dart';

sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentError extends PaymentState {
  final String error;
  PaymentError({required this.error});
}

final class PaymentSuccess extends PaymentState {}

final class PaymentLoadingDone extends PaymentState {}
