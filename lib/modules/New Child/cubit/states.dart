abstract class addChildStates {}

class addChildInitialState extends addChildStates {}

class addChildLoadingState extends addChildStates {}

class addChildSuccessState extends addChildStates {}

class addChildErrorState extends addChildStates {}

class getUserDataLoadingState extends addChildStates {}

class getUserDataSuccessState extends addChildStates {}

class getUserDataErrorState extends addChildStates {}

class getChildrenDataLoadingState extends addChildStates {}

class getChildrenDataSuccessState extends addChildStates {}

class getChildrenDataErrorState extends addChildStates {}

class PickImageLoadingState extends addChildStates {}

class PickImageSuccessState extends addChildStates {}

class PickImageErrorState extends addChildStates {
  final String error;

  PickImageErrorState(this.error);
}