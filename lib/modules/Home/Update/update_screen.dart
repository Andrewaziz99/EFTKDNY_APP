import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eftkdny/models/Children/children_model.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:toastification/toastification.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../New Child/image_options.dart';
import '../cubit/cubit.dart';

class UpdateScreen extends StatelessWidget {
  final ChildrenModel child;
  UpdateScreen({super.key, required this.child});

  final TextEditingController childNameController = TextEditingController();
  final TextEditingController childBirthDateController = TextEditingController();
  final TextEditingController childAddressController = TextEditingController();
  final TextEditingController childPhoneNumberController = TextEditingController();
  final TextEditingController childClassNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var imageUrl = '';
  var imagePath = '';
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (BuildContext context, state) {

        final cubit = HomeCubit.get(context);
        cubit.image = child.image ?? '';
        imageUrl = child.image ?? '';
        childNameController.text = child.name!;
        childBirthDateController.text = child.birthDate!;
        childAddressController.text = child.address!;
        childPhoneNumberController.text = child.phone!;
        childClassNameController.text = child.className!;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              appName,
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/pattern.png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
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
                                        : imageUrl.isNotEmpty ? CachedNetworkImageProvider(imageUrl) : null,
                                    radius: MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        if (isImageSelected == false && imageUrl.isEmpty)
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
                              textColor: Colors.black,
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
                                textColor: Colors.black,
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
                                      initialDate: DateTime(2000))
                                      .then((value) {
                                    childBirthDateController.text =
                                        DateFormat('yyyy/MM/dd').format(value!);
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
                                textColor: Colors.black,
                                controller: childAddressController,
                                type: TextInputType.text,
                                label: address,
                                suffix: Icons.location_on,
                                suffixPressed: () async {
                                  await Navigator.of(context).push(
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
                                textColor: Colors.black,
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
                                textColor: Colors.black,
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
                                    image: imagePath,
                                    birthDate: childBirthDateController.text,
                                    address: childAddressController.text,
                                    className: childClassNameController.text,
                                    phone: childPhoneNumberController.text,
                                  );
                                  if (imagePath.isNotEmpty) {
                                    cubit.updateChildData(
                                        childId: child.childId!,
                                        name: model.name!,
                                        birthDate: model.birthDate!,
                                        phone: model.phone!,
                                        address: model.address!,
                                        className: model.className!,
                                        imagePath: model.image
                                    );
                                  }  else {
                                    cubit.imageUrl = imageUrl;
                                    cubit.updateChildData(
                                        childId: child.childId!,
                                        name: model.name!,
                                        birthDate: model.birthDate!,
                                        phone: model.phone!,
                                        address: model.address!,
                                        className: model.className!,
                                    );
                                  }
                                }
                              },
                              text: edit,
                              fSize: 20.0,
                              radius: 10.0,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        );
      },
      listener: (BuildContext context, state) {

        if (state is PickImageSuccessState) {
          isImageSelected = true;
          imagePath = HomeCubit.get(context).image;
          print('Image selected: $imagePath');
          Navigator.pop(context);
        }

        if (state is updateChildDataLoadingState) {
          showLoadingDialog(context);
        }

        if (state is updateChildDataSuccessState) {
          Navigator.pop(context);
          Toastification().show(
            context: context,
            backgroundColor: Colors.green,
            type: ToastificationType.success,
            autoCloseDuration: Duration(seconds: 2),
            title: Text(updateSuccess),
            showIcon: true,
          );
          Navigator.pop(context);
        }

        if (state is updateChildDataErrorState) {
          Navigator.pop(context);
          Toastification().show(
            context: context,
            backgroundColor: Colors.red,
            type: ToastificationType.error,
            autoCloseDuration: Duration(seconds: 2),
            title: Text(updateError),
            showIcon: true,
          );
        }
      },
    );
  }
}
