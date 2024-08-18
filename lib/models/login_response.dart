class LoginResponse {
  final int id;
  final String lineId;

  LoginResponse({required this.id, required this.lineId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      lineId: json['lineId'],
    );
  }
}
