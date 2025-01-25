import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Import provider to listen to localization changes
import '../const/AppColors.dart';
import '../const/LocalizationProvider.dart';
import '../screens/DrawerScreen.dart';
import '../widgets/CustomBottomNavBar.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Get the current strings based on the selected language
    var strings = Provider.of<LocalizationProvider>(context).currentStrings;

    return Scaffold(
      drawer: DrawerScreen(),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            floating: true,
            pinned: true,
            snap: true,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: AppColors.backgroundColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Text(
              strings['appTitle']!,
              style: TextStyle(color: AppColors.backgroundColor),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.message, color: AppColors.backgroundColor),
                onPressed: () {
                  Navigator.pushNamed(context, "/ChatBot");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
