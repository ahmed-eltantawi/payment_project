import 'creation_extras.dart';

class Extras {
  CreationExtras? creationExtras;
  dynamic confirmationExtras;

  Extras({this.creationExtras, this.confirmationExtras});

  factory Extras.fromJson(Map<String, dynamic> json) => Extras(
        creationExtras: json['creation_extras'] == null
            ? null
            : CreationExtras.fromJson(
                json['creation_extras'] as Map<String, dynamic>),
        confirmationExtras: json['confirmation_extras'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'creation_extras': creationExtras?.toJson(),
        'confirmation_extras': confirmationExtras,
      };
}
