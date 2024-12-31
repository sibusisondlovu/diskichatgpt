class LoginResponse {
  final String status;
  final String? message;
  final String? verificationId;

  LoginResponse({required this.status, this.message, this.verificationId});
}
