abstract class AdminStates {}

class AdminInitialState extends AdminStates {}

class getServantsLoadingState extends AdminStates {}

class getServantsSuccessState extends AdminStates {}

class getServantsErrorState extends AdminStates {
  final String error;

  getServantsErrorState(this.error);
}

class changeClassNameLoadingState extends AdminStates {}

class changeClassNameSuccessState extends AdminStates {}

class changeClassNameErrorState extends AdminStates {
  final String error;

  changeClassNameErrorState(this.error);
}