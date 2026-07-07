import 'extras.dart';
import 'intention_detail.dart';
import 'payment_key.dart';
import 'payment_method.dart';

class PaymobIntentionModel {
  List<PaymentKey>? paymentKeys;
  int? intentionOrderId;
  String? id;
  IntentionDetail? intentionDetail;
  String? clientSecret;
  List<PaymentMethod>? paymentMethods;
  String? specialReference;
  Extras? extras;
  bool? confirmed;
  String? status;
  DateTime? created;
  dynamic cardDetail;
  List<dynamic>? cardTokens;
  String? object;

  PaymobIntentionModel({
    this.paymentKeys,
    this.intentionOrderId,
    this.id,
    this.intentionDetail,
    this.clientSecret,
    this.paymentMethods,
    this.specialReference,
    this.extras,
    this.confirmed,
    this.status,
    this.created,
    this.cardDetail,
    this.cardTokens,
    this.object,
  });

  factory PaymobIntentionModel.fromJson(Map<String, dynamic> json) {
    return PaymobIntentionModel(
      paymentKeys: (json['payment_keys'] as List<dynamic>?)
          ?.map((e) => PaymentKey.fromJson(e as Map<String, dynamic>))
          .toList(),
      intentionOrderId: json['intention_order_id'] as int?,
      id: json['id'] as String?,
      intentionDetail: json['intention_detail'] == null
          ? null
          : IntentionDetail.fromJson(
              json['intention_detail'] as Map<String, dynamic>),
      clientSecret: json['client_secret'] as String?,
      paymentMethods: (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialReference: json['special_reference'] as String?,
      extras: json['extras'] == null
          ? null
          : Extras.fromJson(json['extras'] as Map<String, dynamic>),
      confirmed: json['confirmed'] as bool?,
      status: json['status'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      cardDetail: json['card_detail'] as dynamic,
      cardTokens: json['card_tokens'] as List<dynamic>?,
      object: json['object'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'payment_keys': paymentKeys?.map((e) => e.toJson()).toList(),
        'intention_order_id': intentionOrderId,
        'id': id,
        'intention_detail': intentionDetail?.toJson(),
        'client_secret': clientSecret,
        'payment_methods': paymentMethods?.map((e) => e.toJson()).toList(),
        'special_reference': specialReference,
        'extras': extras?.toJson(),
        'confirmed': confirmed,
        'status': status,
        'created': created?.toIso8601String(),
        'card_detail': cardDetail,
        'card_tokens': cardTokens,
        'object': object,
      };
}
