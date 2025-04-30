import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eftkdny/models/Children/children_model.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:eftkdny/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Questions/question_screen.dart';
import 'child_dialog_page.dart';
import 'cubit/cubit.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController childNameController = TextEditingController();

  ChildrenModel? childData;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (BuildContext context, state) {
        final cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () async {
              cubit.childrenList!.clear();
              cubit.getUserData();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/pattern.png',
                  fit: BoxFit.fill,
                ),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
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
                              screenRatio:
                                  MediaQuery.of(context).devicePixelRatio,
                              entries: [
                                for (var item in cubit.childrenList!)
                                  DropdownMenuEntry(
                                      value: item, label: item.name!),
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
                            condition: state is changeChildDataState ||
                                childData != null,
                            builder: (BuildContext context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    childData!.name ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        childData!.image ?? ''),
                                    radius: 30.0,
                                    backgroundColor: Colors.white,
                                    child: childData!.image != null
                                        ? null
                                        : Icon(
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
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (buildContext) =>
                                            childDialog(context, childData));
                                  },
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                defaultButton(
                                    function: () {
                                      navigateTo(context, QuestionScreen());
                                    },
                                    text: startVisit,
                                    width: double.infinity,
                                    background: Colors.blueAccent,
                                    radius: 10.0,
                                    fSize: 20.0),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  headLine1,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            fallback: (BuildContext context) =>
                                Center(child: Text(noData)),
                          ),
                        ],
                      ),
                      fallback: (BuildContext context) {
                        return loadingDialog(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, state) {},
    );
  }
}
