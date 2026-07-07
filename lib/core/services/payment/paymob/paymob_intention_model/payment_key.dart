class PaymentKey {
  int? integration;
  String? key;
  String? gatewayType;
  dynamic iframeId;
  int? orderId;

  PaymentKey({
    this.integration,
    this.key,
    this.gatewayType,
    this.iframeId,
    this.orderId,
  });

  factory PaymentKey.fromJson(Map<String, dynamic> json) => PaymentKey(
        integration: json['integration'] as int?,
        key: json['key'] as String?,
        gatewayType: json['gateway_type'] as String?,
        iframeId: json['iframe_id'] as dynamic,
        orderId: json['order_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'integration': integration,
        'key': key,
        'gateway_type': gatewayType,
        'iframe_id': iframeId,
        'order_id': orderId,
      };
}
