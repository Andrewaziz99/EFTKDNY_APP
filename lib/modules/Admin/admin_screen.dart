import 'package:cached_network_image/cached_network_image.dart';
import 'package:eftkdny/modules/Admin/cubit/states.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AdminScreen extends StatelessWidget {
  TextEditingController classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getServants(),
      child: BlocConsumer<AdminCubit, AdminStates>(
        builder: (BuildContext context, state) {
          final cubit = AdminCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                appName,
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                cubit.getServants();
                classController.clear();
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/pattern.png',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDownMenu(
                            controller: classController,
                            screenWidth: MediaQuery.of(context).size.width,
                            screenRatio: MediaQuery.of(context).devicePixelRatio,
                            entries: [
                              for (var cl in classItems)
                                DropdownMenuEntry(value: cl, label: cl)
                            ],
                            onSelected: (value) {
                              classController.text = value.toString();
                              cubit.getServantsByClass(value);
                            }),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cubit.servants.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool isFirst = index == 0;
                              bool isLast = index == cubit.servants.length;
                              return TimelineTile(
                                indicatorStyle: const IndicatorStyle(
                                  width: 20,
                                  color: Colors.blue,
                                ),
                                isFirst: isFirst,
                                isLast: isLast,
                                beforeLineStyle: LineStyle(color: Colors.green),
                                afterLineStyle: LineStyle(color: Colors.blue),
                                alignment: TimelineAlign.center,
                                hasIndicator: true,
                                startChild: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => changeClassNameDialog(
                                                  context,
                                                  cubit.servants[index].uId!,
                                                  cubit.servants[index].className!,
                                                  cubit
                                              ),
                                            );
                                          },
                                          child:
                                              Text(cubit.servants[index].name!)),
                                    ],
                                  ),
                                ),
                                endChild: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => changeClassNameDialog(
                                                context,
                                                cubit.servants[index].uId!,
                                                cubit.servants[index].className!,
                                                cubit
                                              ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 30.0,
                                          child: (cubit.servants[index].image != null && cubit.servants[index].image!.isNotEmpty)
                                              ? CircleAvatar(
                                                  backgroundImage: CachedNetworkImageProvider(cubit.servants[index].image!),
                                                  radius: 28.0,
                                                  backgroundColor: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  size: 30.0,
                                                  color: Colors.blue,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }
}

Widget changeClassNameDialog(
    BuildContext context,
    String userId,
    String currentClassName,
    AdminCubit cubit
  ) {
  TextEditingController classController = TextEditingController();
  classController.text = currentClassName;

  return AlertDialog(
    title: const Text('تغيير اسم الاسرة'),
    content: CustomDropDownMenu(
        controller: classController,
        screenWidth: MediaQuery.of(context).size.width,
        screenRatio: MediaQuery.of(context).devicePixelRatio,
        entries: [
          for (var cl in classItems)
            DropdownMenuEntry(value: cl, label: cl)
        ],
        onSelected: (value) {
          classController.text = value.toString();
        }),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('إلغاء'),
      ),
      TextButton(
        onPressed: () {
          cubit.changeClassName(
            classController.text,
            userId,
          );
          Navigator.pop(context);
          classController.clear();
        },
        child: const Text('تغيير'),
      ),
    ],
  );
}