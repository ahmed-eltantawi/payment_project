// EndPoints: the endpoints of the api
abstract class EndPoint {
  static const String baseUrl = "https://accept.paymob.com/api";
}

// ApiKeys: the keys of the api
abstract class ApiKey {
  static const String apiKey = "api_key";
  static const String statusCode = "statusCode";
  static const String errorMessage = "message";
}

// ApiHeaderKey: the header keys of the api
abstract class ApiHeaderKey {}
