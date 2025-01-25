// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:xie_hackathon/const/AppColors.dart';
// import '../screens/DrawerScreen.dart';
// import '../widgets/CustomBottomNavBar.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<Map<String, dynamic>> verticalGridItems = [
//     {"title": "Vertical 1", "icon": Icons.ac_unit},
//     {"title": "Vertical 2", "icon": Icons.access_alarm},
//     {"title": "Vertical 3", "icon": Icons.accessibility},
//   ];

//   final List<Map<String, dynamic>> horizontalGridItems1 = [
//     {"title": "Horizontal 1", "icon": Icons.account_balance},
//     {"title": "Horizontal 2", "icon": Icons.add_a_photo},
//     {"title": "Horizontal 3", "icon": Icons.airport_shuttle},
//     {"title": "Horizontal 3", "icon": Icons.airport_shuttle},
//   ];

//   final List<Map<String, dynamic>> horizontalGridItems2 = [
//     {"title": "Another 1", "icon": Icons.backup},
//     {"title": "Another 2", "icon": Icons.beach_access},
//     {"title": "Another 3", "icon": Icons.cake},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: DrawerScreen(),
//       backgroundColor: AppColors.backgroundColor,
//       bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: AppColors.primaryColor,
//             floating: true,
//             pinned: true,
//             snap: true,
//             leading: Builder(
//               builder: (context) => IconButton(
//                 icon: Icon(Icons.menu, color: AppColors.backgroundColor),
//                 onPressed: () => Scaffold.of(context).openDrawer(), // Open drawer
//               ),
//             ),
//             title: Text(
//               'My App', 
//               style: TextStyle(color: AppColors.backgroundColor)
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.message, color: AppColors.backgroundColor),
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/ChatBot");
//                 },
//               ),
//             ],
//           ),

//           // Title for Vertical Grid
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Vertical Grid',
//                 style: TextStyle(
//                   fontSize: 20, 
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryColor
//                 ),
//               ),
//             ),
//           ),

//           // Vertical Grid
//           SliverPadding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             sliver: SliverGrid(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 1,
//                 childAspectRatio: 2.5,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => _buildGridItem(verticalGridItems[index]),
//                 childCount: verticalGridItems.length,
//               ),
//             ),
//           ),

//           // Title for First Horizontal Grid
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Horizontal Grid 1',
//                 style: TextStyle(
//                   fontSize: 20, 
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryColor
//                 ),
//               ),
//             ),
//           ),

//           // First Horizontal Grid
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 150,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: horizontalGridItems1.length,
//                 itemBuilder: (context, index) => 
//                     _buildHorizontalGridItem(horizontalGridItems1[index]),
//               ),
//             ),
//           ),

//           // Title for Second Horizontal Grid
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Horizontal Grid 2',
//                 style: TextStyle(
//                   fontSize: 20, 
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryColor
//                 ),
//               ),
//             ),
//           ),

//           // Second Horizontal Grid
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 150,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: horizontalGridItems2.length,
//                 itemBuilder: (context, index) => 
//                     _buildHorizontalGridItem(horizontalGridItems2[index]),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGridItem(Map<String, dynamic> item) {
//     return AnimationConfiguration.staggeredGrid(
//       position: 0,
//       columnCount: 1,
//       duration: const Duration(milliseconds: 375),
//       child: ScaleAnimation(
//         child: FadeInAnimation(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primaryColor.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     item['icon'],
//                     size: 50,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     item['title'],
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHorizontalGridItem(Map<String, dynamic> item) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: 120,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primaryColor.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               item['icon'],
//               size: 50,
//               color: AppColors.primaryColor,
//             ),
//             SizedBox(height: 10),
//             Text(
//               item['title'],
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }