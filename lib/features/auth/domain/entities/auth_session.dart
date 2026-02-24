/// Purpose: Represent authenticated session state returned from backend auth API.
class AuthSession {
  /// Purpose: Construct immutable authenticated session model.
  const AuthSession({
    required this.token,
    required this.userId,
    required this.email,
    this.name,
  });

  final String token;
  final String userId;
  final String email;
  final String? name;
}
