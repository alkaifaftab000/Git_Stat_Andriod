import 'package:flutter/material.dart';
import 'package:git_stat/constant/app_color.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:git_stat/view/book_mark_images.dart';
import 'package:git_stat/view/image_view.dart';
import 'package:git_stat/view/repo_view.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  final List<String> labels = ["Images", "Repo", "Bookmark"];

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: labels.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        onTabItemSelected: (int value) {
          setState(() {
            // _tabController!.index = value;
            _motionTabBarController!.index = value;
          });
        },
        tabBarColor: AppColor.backGroundAppColor,
        tabIconColor: Colors.grey.shade700,
        tabIconSelectedSize: 35,
        tabIconSelectedColor: Colors.white,
        tabSelectedColor: Colors.cyan,
        textStyle: AppText.popinsFont(fontWt: FontWeight.bold),
        tabIconSize: 35,
        initialSelectedTab: labels[0],
        labels: labels,
        icons: const [Icons.image, Icons.home_rounded, Icons.bookmark_add],
      ),
      body: TabBarView(
        physics:
            const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        // controller: _tabController,
        controller: _motionTabBarController,
        children: const [ImageView(), RepoList(), SavedPhotosScreen()],
      ),
    );
  }
}
