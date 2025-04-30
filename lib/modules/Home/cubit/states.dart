abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class getUserDataLoadingState extends HomeStates {}

class getUserDataSuccessState extends HomeStates {}

class getUserDataErrorState extends HomeStates {}

class getChildrenDataLoadingState extends HomeStates {}

class getChildrenDataSuccessState extends HomeStates {}

class getChildrenDataErrorState extends HomeStates {}

class changeChildDataState extends HomeStates {}

class toggleChildSelectionState extends HomeStates {}

class clearSelectedChildrenState extends HomeStates {}

class takeAttendanceLoadingState extends HomeStates {}

class takeAttendanceSuccessState extends HomeStates {}

class takeAttendanceErrorState extends HomeStates {}

class getAttendanceLoadingState extends HomeStates {}

class getAttendanceSuccessState extends HomeStates {}

class getAttendanceErrorState extends HomeStates {
  final String error;

  getAttendanceErrorState(this.error);
}