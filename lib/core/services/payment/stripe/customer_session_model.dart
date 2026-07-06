class CustomerSessionModel {
  final String customerEphemeralKeySecret;
  final String customerId;

  CustomerSessionModel(
      {required this.customerEphemeralKeySecret, required this.customerId});
}
