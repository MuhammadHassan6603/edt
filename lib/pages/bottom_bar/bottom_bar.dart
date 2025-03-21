import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/pages/bottom_bar/provider/profile_provider.dart';
import 'package:edt/pages/driver_home/driver_home.dart';
import 'package:edt/pages/expense_tracking/expense_tracking.dart';
import 'package:edt/pages/expense_tracking/provider/expense_provider.dart';
import 'package:edt/pages/home/home.dart';
import 'package:edt/pages/profile/profile.dart';
import 'package:edt/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();
    String userRole =
        Provider.of<UserRoleProvider>(context, listen: false).role;

    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<PaymentProvider>(context, listen: false)
        .fetchPaymentAndExpenseData(userRole);
  });
    var userPro = Provider.of<UserRoleProvider>(context, listen: false);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //   _storeDeviceToken(userPro.role);
  // });
    if (userPro.role == 'Driver') {
      Provider.of<UserProfileProvider>(context, listen: false)
          .loadUserProfile('drivers');
    } else if (userPro.role == 'Passenger') {
      Provider.of<UserProfileProvider>(context, listen: false)
          .loadUserProfile('passengers');
    }
  }

  Future<void> _storeDeviceToken(String userRole) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return;
    
    final collectionName = userRole == 'Driver' ? 'drivers' : 'passengers';
    
    final userDocRef = FirebaseFirestore.instance.collection(collectionName).doc(userId);
    
    await userDocRef.update({
      'tokens': FieldValue.arrayUnion([fcmToken])
    }).catchError((error) {
      userDocRef.update({
        'tokens': [fcmToken]
      });
    });
    
    print('FCM Token stored successfully for $userRole: $fcmToken');
    
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _updateDeviceToken(userRole, userId, fcmToken, newToken);
    });
    
  } catch (e) {
    print('Error storing device token: $e');
  }
}


Future<void> _updateDeviceToken(String userRole, String userId, String oldToken, String newToken) async {
  try {
    final collectionName = userRole == 'Driver' ? 'drivers' : 'passengers';
    final userDocRef = FirebaseFirestore.instance.collection(collectionName).doc(userId);
    
    await userDocRef.update({
      'tokens': FieldValue.arrayRemove([oldToken])
    });
    
    await userDocRef.update({
      'tokens': FieldValue.arrayUnion([newToken])
    });
    
    print('FCM Token updated successfully for $userRole: $newToken');
  } catch (e) {
    print('Error updating device token: $e');
  }
}

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var userPro = Provider.of<UserRoleProvider>(context);
    final List<Widget> _screens = [
      userPro.role == 'Passenger'
          ? HomeScreen(scaffoldKey: _scaffoldKey)
          : DriverHomeScreen(scaffoldKey: _scaffoldKey),
      ExpenseTrackingScreen(scaffoldKey: _scaffoldKey),
      ProfileScreen(scaffoldKey: _scaffoldKey),
    ];

    return Consumer<BottomNavProvider>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            return true;
            // if (model.selectedIndex == 0) {
            //   return true;
            // } else {
            //   model.setIndex(0);
            //   return false;
            // }
          },
          child: Scaffold(
            key: _scaffoldKey,
            drawer: getDrawer(context),
            body: Stack(
              children: [
                Positioned.fill(
                  child: _screens[model.selectedIndex],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, -4),
                          spreadRadius: 0.1,
                          blurRadius: 1,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBottomNavItem(context, model,
                            'assets/icons/bottomicon1.svg', 'Home', 0),
                        _buildBottomNavItem(
                            context,
                            model,
                            'assets/icons/bottomicon2.svg',
                            userPro.role == 'Passenger'
                                ? 'Expense Tracking'
                                : 'Earning',
                            1),
                        _buildBottomNavItem(context, model,
                            'assets/icons/bottomicon3.svg', 'Profile', 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavItem(BuildContext context, BottomNavProvider model,
      String iconName, String label, int index) {
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
