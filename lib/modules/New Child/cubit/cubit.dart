import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/New%20Child/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/Children/children_model.dart';
import '../../../models/User/user_model.dart';
import '../../../shared/components/constants.dart';


class addChildCubit extends Cubit<addChildStates> {
  addChildCubit() : super(addChildInitialState());

  static addChildCubit get(context) => BlocProvider.of(context);


  UserModel? userModel;

  void getUserData() {
    emit(getUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
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
    FirebaseFirestore.instance
        .collection('children')
        .where('className', isEqualTo: userModel!.className)
        .get().then((value){
      for (var element in value.docs) {
        childrenList!.add(ChildrenModel.fromJson(element.data()));
      }
      emit(getChildrenDataSuccessState());
    }).catchError((error) {
      emit(getChildrenDataErrorState());
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

  Future<void> createNewChild({
    required String name,
    required String phone,
    required String address,
    required String className,
    String? imagePath,
  }) async {
    emit(createNewChildLoadingState());

    String? imageUrl;
    try {
      // Check if imagePath is provided and not empty
      if (imagePath != null && imagePath.isNotEmpty) {
        // Upload the image to Firebase Storage
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('children')
            .child('$name.jpg');

        final UploadTask uploadTask = storageReference.putFile(File(imagePath));
        final TaskSnapshot storageSnapshot = await uploadTask;
        imageUrl = await storageSnapshot.ref.getDownloadURL();
      }

      ChildrenModel model = ChildrenModel(
        name: name,
        phone: phone,
        address: address,
        className: className,
        image: imageUrl,
      );
      // Save the user data to Firestore
      await FirebaseFirestore.instance
          .collection('children')
          .doc(uId)
          .set(model.toMap());
      emit(createNewChildSuccessState());
    } catch (error) {
      emit(createNewChildErrorState(error.toString()));
    }

  }


  void addNewChild({
    required String name,
    required String phone,
    required String address,
    required String className,
    required imagePath,
  }) {
    emit(addChildLoadingState());
    createNewChild(
        name: name,
        phone: phone,
        address: address,
        className: className
    ).then((value) {
      emit(addChildSuccessState());
    }).catchError((error) {
      emit(addChildErrorState());
    });
  }

}
