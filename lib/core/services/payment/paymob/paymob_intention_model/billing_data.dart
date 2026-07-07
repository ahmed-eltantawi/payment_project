class BillingData {
  String? apartment;
  String? floor;
  String? firstName;
  String? lastName;
  String? street;
  String? building;
  String? phoneNumber;
  String? shippingMethod;
  String? city;
  String? country;
  String? state;
  String? email;
  String? postalCode;

  BillingData({
    this.apartment,
    this.floor,
    this.firstName,
    this.lastName,
    this.street,
    this.building,
    this.phoneNumber,
    this.shippingMethod,
    this.city,
    this.country,
    this.state,
    this.email,
    this.postalCode,
  });

  factory BillingData.fromJson(Map<String, dynamic> json) => BillingData(
        apartment: json['apartment'] as String?,
        floor: json['floor'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        street: json['street'] as String?,
        building: json['building'] as String?,
        phoneNumber: json['phone_number'] as String?,
        shippingMethod: json['shipping_method'] as String?,
        city: json['city'] as String?,
        country: json['country'] as String?,
        state: json['state'] as String?,
        email: json['email'] as String?,
        postalCode: json['postal_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'apartment': apartment,
        'floor': floor,
        'first_name': firstName,
        'last_name': lastName,
        'street': street,
        'building': building,
        'phone_number': phoneNumber,
        'shipping_method': shippingMethod,
        'city': city,
        'country': country,
        'state': state,
        'email': email,
        'postal_code': postalCode,
      };
}
