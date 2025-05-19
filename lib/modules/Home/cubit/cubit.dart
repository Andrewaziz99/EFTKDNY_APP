import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/models/Answers/answers_model.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  List<AnswersModel> answersList = [];

  void getAnswers(String childId) {
    emit(getAnswersLoadingState());
    FirebaseFirestore.instance
        .collection('answers')
        .where('childId', isEqualTo: childId)
        .get()
        .then((value) {
      answersList.clear();
      for (var element in value.docs) {
        answersList.add(AnswersModel.fromJson(element.data()));
      }
      emit(getAnswersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getAnswersErrorState(error.toString()));
    });
  }

  var image = '';

  Future<void> pickImageFromGallery() async {
    emit(PickImageLoadingState());
    // Implement image picking logic here
    final imageFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      image = imageFile.path;
      print(image);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState('No image selected'));
      return;
    }
  }


  Future<void> captureImage() async {
    emit(PickImageLoadingState());
    // Implement image picking logic here
    final imageFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      image = imageFile.path;
      print(image);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState('No image selected'));
      return;
    }
  }

  String? imageUrl;
  Future<void> updateChildData({
    required String childId,
    required String name,
    required String birthDate,
    required String phone,
    required String address,
    required String className,
    String? imagePath,
  }) async {
    emit(updateChildDataLoadingState());

    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('children').doc(childId);



      // Check if a new image is provided
      if (imagePath != null && imagePath.isNotEmpty) {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('children')
            .child('$name.jpg');

        final UploadTask uploadTask = storageReference.putFile(File(imagePath));
        final TaskSnapshot storageSnapshot = await uploadTask;
        imageUrl = await storageSnapshot.ref.getDownloadURL();
      }

      // Create an updated model
      ChildrenModel updatedModel = ChildrenModel(
        childId: childId,
        name: name,
        birthDate: birthDate,
        phone: phone,
        address: address,
        className: className,
        image: imageUrl, // Will use new image URL or retain old one if imagePath is null
      );

      // Update the document in Firestore
      await docRef.update(updatedModel.toMap());

      emit(updateChildDataSuccessState());
    } catch (error) {
      emit(updateChildDataErrorState(error.toString()));
      print(error);
    }
  }


}
