class AuthState {
  final String name;
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    required this.name,
    required this.email,
    required this.password,
    required this.isLoading,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(
    name: '',
    email: '',
    password: '',
    isLoading: false,
    errorMessage: null,
  );

  AuthState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
