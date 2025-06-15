abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class getUserDataLoadingState extends HomeStates {}

class getUserDataSuccessState extends HomeStates {}

class getUserDataErrorState extends HomeStates {}

class getClassNamesLoadingState extends HomeStates {}

class getClassNamesSuccessState extends HomeStates {}

class getClassNamesErrorState extends HomeStates {
  final String error;

  getClassNamesErrorState(this.error);
}

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

class getAttendanceByMonthLoadingState extends HomeStates {}

class getAttendanceByMonthSuccessState extends HomeStates {}

class getAttendanceByMonthErrorState extends HomeStates {
  final String error;

  getAttendanceByMonthErrorState(this.error);
}

class getAnswersLoadingState extends HomeStates {}

class getAnswersSuccessState extends HomeStates {}

class getAnswersErrorState extends HomeStates {
  final String error;

  getAnswersErrorState(this.error);
}

class PickImageLoadingState extends HomeStates {}

class PickImageSuccessState extends HomeStates {}

class PickImageErrorState extends HomeStates {
  final String error;

  PickImageErrorState(this.error);
}

class updateChildDataLoadingState extends HomeStates {}

class updateChildDataSuccessState extends HomeStates {}

class updateChildDataErrorState extends HomeStates {
  final String error;

  updateChildDataErrorState(this.error);
}

class generateAttendancePdfLoadingState extends HomeStates {}

class generateAttendancePdfSuccessState extends HomeStates {}

class generateAttendancePdfErrorState extends HomeStates {
  final String error;

  generateAttendancePdfErrorState(this.error);
}

class uploadAndParseCsvLoadingState extends HomeStates {}

class uploadAndParseCsvSuccessState extends HomeStates {}

class uploadAndParseCsvErrorState extends HomeStates {
  final String error;

  uploadAndParseCsvErrorState(this.error);
}

class readCsvFileLoadingState extends HomeStates {}

class readCsvFileSuccessState extends HomeStates {}

class readCsvFileErrorState extends HomeStates {
  final String error;

  readCsvFileErrorState(this.error);
}