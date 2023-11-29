import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:taskati/feature/home/home_screan.dart';
import 'package:taskati/profile/widget.dart';
import 'package:taskati/storage/local_storage.dart';
import 'package:taskati/utiles/colors.dart';
import 'package:taskati/utiles/text_style.dart';

String name = '';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Box<bool> modeBox;
  @override
  void initState() {
    super.initState();
    modeBox = Hive.box('mode');
    AppLocal.getData(AppLocal.Name_Key).then((value) {
      setState(() {
        name = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = modeBox.get('darkMode') ?? false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomeScrean(),
              ));
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  modeBox.put('darkMode', !isDark);
                });
              },
              icon: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FutureBuilder(
                  future: AppLocal.getData(AppLocal.Image_Key),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.lightBg,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(File(snapshot.data!)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showImageDialog(context, onTapCamera: () async {
                                await getImagefromCamera().then((value) {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                });
                              }, onTapGallery: () async {
                                await getImagefromGallery().then((value) {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                });
                              });
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.lightBg,
                        child: const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/user.png')),
                      );
                    }
                  }),
              const SizedBox(
                height: 20,
              ),


              Padding(
                padding: const EdgeInsets.all(20),
                child: Divider(
                  color: AppColors.primaryColor,
                  thickness: .7,
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: getHeadlineStyle(),
                  ),
                  IconButton(
                      onPressed: () {
                        showNameDialog(context, name);
                        setState(() {});
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor)),
                        child: Icon(
                          Icons.mode_edit_outline_outlined,
                          color: AppColors.primaryColor,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
