import 'dart:io';

import 'package:eftkdny/modules/New%20Child/image_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:toastification/toastification.dart';
import '../../models/Children/children_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AddScreen extends StatelessWidget {
  TextEditingController childImageController = TextEditingController();
  TextEditingController childNameController = TextEditingController();
  TextEditingController childBirthDateController = TextEditingController();
  TextEditingController childAddressController = TextEditingController();
  TextEditingController childPhoneNumberController = TextEditingController();
  TextEditingController childAdditionalPhoneNumberController =
      TextEditingController();
  TextEditingController childClassNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var imagePath = '';
  bool isImageSelected = false;

  AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => addChildCubit(),
      child: BlocConsumer<addChildCubit, addChildStates>(
        builder: (BuildContext context, state) {
          final cubit = addChildCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/pattern.png',
                  fit: BoxFit.fill,
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                            child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    image_options(context, cubit));
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                isImageSelected && imagePath.isNotEmpty
                                    ? FileImage(File(imagePath))
                                    : null,
                            radius: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                if (isImageSelected == false)
                                  Icon(
                                    Icons.person,
                                    size: 70.0,
                                    color: Colors.blue,
                                  ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                if (isImageSelected == false)
                                  Text(
                                    selectImage,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: childNameController,
                            type: TextInputType.text,
                            label: name,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return nameValidation;
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: childBirthDateController,
                            type: TextInputType.text,
                            label: birthdate,
                            suffix: Icons.calendar_month_rounded,
                            suffixPressed: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime(
                                        2000,
                                      ),
                                      lastDate: DateTime.now(),
                                      initialDate: DateTime.now())
                                  .then((value) {
                                childBirthDateController.text =
                                    DateFormat('dd/MM/yyyy').format(value!);
                              });
                            },
                            validate: (val) {
                              if (val!.isEmpty) {
                                return birthdateValidation;
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: childAddressController,
                            type: TextInputType.text,
                            label: address,
                            suffix: Icons.location_on,
                            suffixPressed: () async {
                              final location = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Material(
                                    child: FlutterLocationPicker(
                                      initZoom: 11,
                                      minZoomLevel: 0,
                                      maxZoomLevel: 100,
                                      trackMyPosition: true,
                                      searchBarBackgroundColor: Colors.white,
                                      selectedLocationButtonTextStyle: const TextStyle(fontSize: 18),
                                      mapLanguage: 'en',
                                      onError: (e) => print(e),
                                      selectLocationButtonLeadingIcon: const Icon(Icons.check),
                                      showContributorBadgeForOSM: true,
                                      onPicked: (PickedData pickedData) {
                                        Navigator.of(context).pop(pickedData);
                                        childAddressController.text =
                                            pickedData.address;
                                        print(pickedData.latLong);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            validate: (val) {
                              if (val!.isEmpty) {
                                return addressValidation;
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: childPhoneNumberController,
                            type: TextInputType.number,
                            label: phone,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return phoneValidation;
                              } else if (val.length < 11) {
                                return phoneValidation;
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        CustomDropDownMenu(
                            showTitle: true,
                            title: selectClass,
                            titleColor: Colors.white,
                            textColor: Colors.white,
                            controller: childClassNameController,
                            screenWidth: MediaQuery.of(context).size.width,
                            screenRatio: MediaQuery.of(context).size.height,
                            entries: [
                              for (var item in classItems)
                                DropdownMenuEntry(value: item, label: item),
                            ],
                            onSelected: (value) {
                              childClassNameController.text = value;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultButton(
                          function: () {
                            if (_formKey.currentState!.validate()) {
                              final model = ChildrenModel(
                                name: childNameController.text,
                                image: cubit.image,
                                birthDate: childBirthDateController.text,
                                address: childAddressController.text,
                                className: childClassNameController.text,
                                phone: childPhoneNumberController.text,
                              );
                              cubit.createNewChild(
                                name: model.name!,
                                birthDate: model.birthDate!,
                                phone: model.phone!,
                                address: model.address!,
                                className: model.className!,
                                imagePath: model.image,
                              );
                            }
                          },
                          text: add,
                          fSize: 20.0,
                          radius: 10.0,
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {
          final cubit = addChildCubit.get(context);
          if (state is PickImageSuccessState) {
            imagePath = cubit.image;
            isImageSelected = true;
            childImageController.text = imagePath;
          }

          if (state is addChildLoadingState || state is createNewChildLoadingState) {
            showDialog(context: context, builder: (buildContext) => loadingDialog(context));
          }

          if (state is addChildSuccessState || state is createNewChildSuccessState) {
            Navigator.pop(context);
            Toastification().show(
              context: context,
              backgroundColor: Colors.green,
              type: ToastificationType.success,
              autoCloseDuration: Duration(seconds: 2),
              title: Text(addSuccess),
              showIcon: true,
            );
            cubit.getUserData();
          }
          if (state is addChildErrorState || state is createNewChildErrorState) {
            Navigator.pop(context);
            Toastification().show(
              context: context,
              backgroundColor: Colors.red,
              type: ToastificationType.error,
              autoCloseDuration: Duration(seconds: 2),
              title: Text(addError),
              showIcon: true,
            );
          }
        },
      ),
    );
  }
}
