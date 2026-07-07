import 'billing_data.dart';
import 'item.dart';

class IntentionDetail {
  int? amount;
  List<Item>? items;
  String? currency;
  BillingData? billingData;

  IntentionDetail({
    this.amount,
    this.items,
    this.currency,
    this.billingData,
  });

  factory IntentionDetail.fromJson(Map<String, dynamic> json) {
    return IntentionDetail(
      amount: json['amount'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      currency: json['currency'] as String?,
      billingData: json['billing_data'] == null
          ? null
          : BillingData.fromJson(json['billing_data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'items': items?.map((e) => e.toJson()).toList(),
        'currency': currency,
        'billing_data': billingData?.toJson(),
      };
}
