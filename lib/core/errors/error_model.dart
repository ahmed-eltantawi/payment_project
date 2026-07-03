import '../networking/api_end_points.dart';

class ErrorModel {
  int statusCode;
  String errorMessage;
  ErrorModel({required this.statusCode, required this.errorMessage});
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      statusCode: json[ApiKey.statusCode],
      errorMessage: json[ApiKey.errorMessage],
    );
  }
}

// I made this SignUpErrorModel class because the
//server returns a different error message
// if the statues code is 400 in the signup
//endpoint the api sends a List of error messages
class SignUpErrorModel extends ErrorModel {
  SignUpErrorModel({required super.statusCode, required super.errorMessage});

  factory SignUpErrorModel.fromJson(Map<String, dynamic> json) {
    return SignUpErrorModel(
      statusCode: json[ApiKey.statusCode],
      errorMessage: json[ApiKey.errorMessage][0],
    );
  }
}

class Success {
  const Success();
}
