import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

import '../../shared/components/constants.dart';

Widget childDialog(context, data) => AlertDialog(
      title: Text(childData, style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.transparent,
      content: BlurryContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(data!.image ?? ''),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                  child: data!.image != null ? null : Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              //Name
              Text(
                data.name!,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              //Birth Date
              Text(
                data.birthDate,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              //Address
              Text(
                data.address,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              //Phone
              Row(
                children: [
                  Text(
                    data.phone,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      // Call the phone number
                      // launch('tel:${data.phone}');
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              //Additional Phone
              // Row(
              //   children: [
              //     Text(
              //       data.additionalPhone,
              //       style: TextStyle(color: Colors.white, fontSize: 18.0),
              //     ),
              //     Spacer(),
              //     IconButton(
              //       onPressed: () {
              //         // Call the phone number
              //         // launch('tel:${data.phone}');
              //       },
              //       icon: Icon(
              //         Icons.phone,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: (){}, child: Text(update, style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),)),
        TextButton(onPressed: (){Navigator.pop(context);}, child: Text(exit, style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),)),
      ],
    );
