import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskati/profile/profile.dart';
import 'package:taskati/storage/local_storage.dart';
import 'package:taskati/utiles/colors.dart';
import 'package:taskati/utiles/text_style.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: AppLocal.getData(AppLocal.Name_Key),
              builder: (context, snapshot) {
                return Text(
                  'Hello, ${snapshot.data?.split(' ').first}',
                  style: getHeadlineStyle(),
                );
              },
            ),
            //
            Text(
              'Have A Nice Day.',
              style: getSmallTextStyle(),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ProfileView(),
            ));
          },
          child: FutureBuilder(
              future: AppLocal.getData(AppLocal.Image_Key),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primaryColor,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: FileImage(File(snapshot.data!)),
                    ),
                  );
                } else {
                  return CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.greyColor,
                    child: const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/user.png')),
                  );
                }
              }),
        )
      ],
    );
  }
}
