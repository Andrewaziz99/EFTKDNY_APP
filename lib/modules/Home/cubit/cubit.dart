import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../models/Children/children_model.dart';
import '../../../models/User/user_model.dart';
import '../../../shared/components/constants.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  void changeChildData(ChildrenModel model) {
    childrenModel = model;
    emit(changeChildDataState());
  }

  UserModel? userModel;

  void getUserData() {
    emit(getUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(getUserDataSuccessState());
      getChildrenData();
    }).catchError((error) {
      emit(getUserDataErrorState());
    });
  }

  ChildrenModel? childrenModel;

  List<ChildrenModel>? childrenList = [];

  void getChildrenData() {
    emit(getChildrenDataLoadingState());
    Children.clear();
    FirebaseFirestore.instance
        .collection('children')
        .where('className', isEqualTo: userModel!.className)
        .get()
        .then((value) {
      for (var element in value.docs) {
        childrenList!.add(ChildrenModel.fromJson(element.data()));
        Children.add(ChildrenModel.fromJson(element.data()));
      }
      emit(getChildrenDataSuccessState());
      getAttendance('Friday');
      getAttendance('Hymns');
    }).catchError((error) {
      emit(getChildrenDataErrorState());
    });
  }

  void toggleChildSelection(ChildrenModel model) {
    if (model.isSelected == true) {
      model.isSelected = false;
    } else {
      model.isSelected = true;
    }
    emit(toggleChildSelectionState());
  }

  void clearSelectedChildren() {
    for (var element in childrenList!) {
      element.isSelected = false;
    }
    emit(clearSelectedChildrenState());
  }

  List<ChildrenModel> selectedChildren = [];
  List<ChildrenModel> Children = [];

  void getAttendance(String attendanceType) {
    emit(getAttendanceLoadingState());
    selectedChildren.clear();
    FirebaseFirestore.instance
        .collection('attendance')
        .where('type', isEqualTo: attendanceType)
        .where('attended', isEqualTo: true)
    .where('date',
            isEqualTo: DateFormat('yyyy/MM/dd').format(DateTime.now()))
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        selectedChildren.add(ChildrenModel.fromJson(element.data()));
        Children.removeWhere((child) => child.name == element['name']);
      }
      emit(getAttendanceSuccessState());
    });
  }


  void takeAttendance(selectedChildren, String attendanceType) {
    emit(takeAttendanceLoadingState());
    selectedChildren =
        selectedChildren.where((child) => child.isSelected == true).toList();
    if (selectedChildren.isNotEmpty) {
      for (var element in selectedChildren) {
        FirebaseFirestore.instance.collection('attendance').doc().set({
          'name': element.name,
          'image': element.image,
          'className': element.className,
          'attended': element.isSelected,
          'type': attendanceType,
          'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
          'metadata': {
            'recordedBy': uId, // Add your user ID if available
          }
        }).then((value) {

        }).catchError((error) {
          emit(takeAttendanceErrorState());
        });
      }
      emit(takeAttendanceSuccessState());
    } else {
      emit(takeAttendanceErrorState());
    }
  }





  // void takeAttendance(
  //     List<ChildrenModel> selectedChildren, String attendanceType) {
  //   emit(takeAttendanceLoadingState());
  //
  //   // Filter only selected children
  //   selectedChildren =
  //       selectedChildren.where((child) => child.isSelected == true).toList();
  //
  //   if (selectedChildren.isNotEmpty) {
  //     for (var element in selectedChildren) {
  //       FirebaseFirestore.instance.collection('attendance').doc().set({
  //         'name': element.name,
  //         'image': element.image,
  //         'className': userModel!.className,
  //         'attended': element.isSelected,
  //         'type': attendanceType,
  //         'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
  //         'metadata': {
  //           'recordedBy': uId,
  //         }
  //       }).then((value) {
  //         // Remove the child from the list after successful attendance
  //         childrenList!.removeWhere((child) => child.name == element.name);
  //       }).catchError((error) {
  //         emit(takeAttendanceErrorState());
  //       });
  //     }
  //     emit(takeAttendanceSuccessState());
  //   } else {
  //     emit(takeAttendanceErrorState());
  //   }
  // }
  //
  // void getAttendance(String attendanceType) {
  //   emit(getAttendanceLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('attendance')
  //       .where('type', isEqualTo: attendanceType)
  //       .where('attended', isEqualTo: true)
  //       .snapshots()
  //       .listen((QuerySnapshot snapshot) {
  //     // Clear existing attended children list if needed
  //     List<String> attendedChildren = [];
  //
  //     for (var doc in snapshot.docs) {
  //       attendedChildren.add(doc['name']);
  //     }
  //
  //     // Filter the childrenList to only show those who haven't attended today
  //     if (childrenList != null) {
  //       childrenList!
  //           .removeWhere((child) => attendedChildren.contains(child.name));
  //     }
  //
  //     emit(getAttendanceSuccessState());
  //   }).onError((error) {
  //     emit(getAttendanceErrorState(error.toString()));
  //   });
  // }

}
