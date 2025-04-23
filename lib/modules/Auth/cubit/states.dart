abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthChangePasswordVisibilityState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {}

class AuthRegisterErrorState extends AuthStates {
  final String error;

  AuthRegisterErrorState(this.error);
}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {
  final String uId;

  AuthSuccessState(this.uId);
}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState(this.error);
}

class AuthCreateUserLoadingState extends AuthStates {}

class AuthCreateUserSuccessState extends AuthStates {}

class AuthCreateUserErrorState extends AuthStates {
  final String error;

  AuthCreateUserErrorState(this.error);
}

class AuthResetPasswordLoadingState extends AuthStates {}

class AuthResetPasswordSuccessState extends AuthStates {}

class AuthResetPasswordErrorState extends AuthStates {
  final String error;

  AuthResetPasswordErrorState(this.error);
}

class AuthPickImageLoadingState extends AuthStates {}

class AuthPickImageSuccessState extends AuthStates {}

class AuthPickImageErrorState extends AuthStates {
  final String error;

  AuthPickImageErrorState(this.error);
}

