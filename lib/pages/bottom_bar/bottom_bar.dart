import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/pages/expense_tracking/expense_tracking.dart';
import 'package:edt/pages/home/home.dart';
import 'package:edt/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  
  final List<Widget> _screens = [
    HomeScreen(),
    ExpenseTrackingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, model, child) {
        return Scaffold(
          extendBody: true,
          body: _screens[model.selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, -4),
                spreadRadius: 2,
                blurRadius: 8
                
              ),],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildBottomNavItem(context, model, 'assets/icons/bottomicon1.svg', 'Home', 0),
                  _buildBottomNavItem(context, model, 'assets/icons/bottomicon2.svg', 'Expense Tracking', 1),
                  _buildBottomNavItem(context, model, 'assets/icons/bottomicon3.svg', 'Profile', 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavItem(BuildContext context, BottomNavProvider model, String iconName, String label, int index) {
    bool isSelected = model.selectedIndex == index;
    Color iconColor = isSelected ? Color(0xff0F69DB) : Colors.black;

    return GestureDetector(
      onTap: () {
        model.setIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName,
            color: iconColor,
            height: 24,
          ),
          Text(
            label,
            style: TextStyle(color: iconColor),
          ),
        ],
      ),
    );
  }
}
