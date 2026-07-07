class PaymentMethod {
  int? integrationId;
  dynamic alias;
  String? name;
  String? methodType;
  String? currency;
  bool? live;
  bool? useCvcWithMoto;

  PaymentMethod({
    this.integrationId,
    this.alias,
    this.name,
    this.methodType,
    this.currency,
    this.live,
    this.useCvcWithMoto,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        integrationId: json['integration_id'] as int?,
        alias: json['alias'] as dynamic,
        name: json['name'] as String?,
        methodType: json['method_type'] as String?,
        currency: json['currency'] as String?,
        live: json['live'] as bool?,
        useCvcWithMoto: json['use_cvc_with_moto'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'integration_id': integrationId,
        'alias': alias,
        'name': name,
        'method_type': methodType,
        'currency': currency,
        'live': live,
        'use_cvc_with_moto': useCvcWithMoto,
      };
}
