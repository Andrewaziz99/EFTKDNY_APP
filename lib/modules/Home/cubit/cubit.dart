import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/Children/children_model.dart';
import '../../../models/User/user_model.dart';
import '../../../shared/components/constants.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);


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

  void changeChildData(ChildrenModel model) {
    childrenModel = model;
    emit(changeChildDataState());
  }




}
