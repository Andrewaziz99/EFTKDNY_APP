import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eftkdny/models/Children/children_model.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:eftkdny/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'child_dialog_page.dart';
import 'cubit/cubit.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController childNameController = TextEditingController();

  ChildrenModel? childData;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit()..getUserData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        builder: (BuildContext context, state) {
          final cubit = HomeCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/pattern.png',
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConditionalBuilder(
                    condition: state is! getUserDataLoadingState,
                    builder: (BuildContext context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDownMenu(
                            showTitle: false,
                            controller: childNameController,
                            screenWidth: MediaQuery.of(context).size.width,
                            screenRatio: MediaQuery.of(context).devicePixelRatio,
                            entries: [
                              for (var item in cubit.childrenList!)
                                DropdownMenuEntry(value: item, label: item.name!),
                            ],
                            onSelected: (value) {
                              cubit.changeChildData(value);
                              childData = value;
                              childNameController.text = childData!.name!;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is changeChildDataState || childData != null,
                          builder: (BuildContext context) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    childData!.name ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(childData!.image ?? ''),
                                    radius: 50.0,
                                    backgroundColor: Colors.white,
                                    child: childData!.image != null ? null : Icon(
                                      Icons.person,
                                      size: 50.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  subtitle: Text(
                                    childData!.birthDate ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios_outlined,),
                                  onTap: (){
                                    showDialog(context: context, builder: (buildContext) => childDialog(context, childData));
                                  },
                                ),
                              ),
                            ],
                          ),
                          fallback: (BuildContext context) => Center(child: Text(noData)),
                        ),
                      ],
                    ),
                    fallback: (BuildContext context) { return loadingDialog(context); },
                  ),
                ),
              ],
            ),
          );

        },
        listener: (BuildContext context, state) {  },
      ),
    );
  }
}
