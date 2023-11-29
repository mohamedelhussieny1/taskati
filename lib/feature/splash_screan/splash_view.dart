import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskati/feature/home/home_screan.dart';
import 'package:taskati/feature/upLoad_screan/upLoad.dart';
import 'package:taskati/storage/local_storage.dart';
import 'package:taskati/utiles/text_style.dart';
import 'package:lottie/lottie.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
          () {
        AppLocal.getData(AppLocal.IS_UPLOAD).then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
            (value ?? false) ? const HomeScrean() : const UploadView(),
          ));
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/logo.json',
              height: 250,
            ),
            Text(
              'Taskati',
              style: getTitleStyle(
                  fontSize: 22, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'It\'s Time To Get Orginzed',
              style: getSmallTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
