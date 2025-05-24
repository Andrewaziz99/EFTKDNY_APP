import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/Admin/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/User/user_model.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);

  List<UserModel> servants = [];

  void getServants(){
    emit(getServantsLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      servants = [];
      value.docs.forEach((element) {
          servants.add(UserModel.fromJson(element.data()));
      });
      emit(getServantsSuccessState());
    }).catchError((error){
      emit(getServantsErrorState(error.toString()));
    });
  }


  void getServantsByClass(String className){
    emit(getServantsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .where('className', isEqualTo: className)
        .get()
        .then((value) {
      servants = [];
      value.docs.forEach((element) {
          servants.add(UserModel.fromJson(element.data()));
      });
      emit(getServantsSuccessState());
    }).catchError((error){
      emit(getServantsErrorState(error.toString()));
    });
  }

  void changeClassName(String newClassName, String userId) {
    emit(changeClassNameLoadingState());
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'className': newClassName,
    }).then((value) {
      getServants();
      emit(changeClassNameSuccessState());
    }).catchError((error) {
      emit(changeClassNameErrorState(error.toString()));
    });
  }

}