import 'package:flutter/material.dart';


import '../../model/slide.dart';
import '../components/ui/button.dart';
import '../tools/app_colours.dart';
import '../tools/app_routes.dart';
import '../tools/app_strings.dart';
import '../tools/app_styles.dart';

class WalkScreen extends StatefulWidget {
  const WalkScreen({super.key});

  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  PageController pageController = PageController();
  List<SlideModel> slide = [
    SlideModel(
        AppStrings.title1, AppStrings.description1, "assets/images/logo 1.png"),
    SlideModel(
        AppStrings.title2, AppStrings.description2, "assets/images/logo 5.png"),
    SlideModel(
        AppStrings.title3, AppStrings.description3, "assets/images/logo 3.png"),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 140),
                      Center(
                          child: Image.asset(slide[index].image,
                            width: MediaQuery.of(context).size.width/1.5,
                          )
                      ),
                      const SizedBox(height: 10),
                      Text(
                        slide[index].title,
                        style: AppStyles.title1(color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Text(slide[index].description,
                          style: AppStyles.regular1(size: 18), textAlign: TextAlign.center),
                    ],
                  );
                },
                controller: pageController,
                itemCount: slide.length,
                onPageChanged: (index) => setState(() => currentPage = index),
              )),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                indicator(),
                // const SizedBox(height: 90),
                // ButtonComponent(
                //     onPressed:()=> Navigator.of(context).pushNamed(AppRoutes.signup),
                //     label: 'Signup',
                //     icon: null,
                //     type: ButtonType.secondary
                // ),
                const SizedBox(height: 20),
                ButtonComponent(
                    onPressed:()=>Navigator.of(context).pushNamed(AppRoutes.login),
                    label: 'Connexion',
                    icon: null,
                    type: ButtonType.primary),
                const SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < slide.length; i++) ...[
          InkWell(
            onTap: () {
              if (i != currentPage)
                pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
            },
            child: Icon(
              Icons.circle,
              size: currentPage == i ? 18 : 12,
              color: currentPage == i
                  ? AppColours.primaryColor
                  : AppColours.primaryColorlight,
            ),
          ),
          if (i < slide.length - 1) SizedBox(width: 10),
        ],
      ],
    );
  }
}
