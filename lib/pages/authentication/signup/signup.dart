import 'dart:developer';
import 'package:edt/pages/authentication/signup/otp.dart';
import 'package:edt/pages/authentication/signup/provider/signup_provider.dart';
import 'package:edt/pages/authentication/signup/services/google_signin.dart';
import 'package:edt/pages/authentication/signup/services/phone_auth.dart';
import 'package:edt/pages/authentication/signup/widgets/google_container.dart';
import 'package:edt/pages/authentication/signup/widgets/phone_field.dart';
import 'package:edt/pages/authentication/signup/widgets/stepper.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController phone = TextEditingController();
  String completePhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    var userPro = Provider.of<UserRoleProvider>(context);
    var signupPro = Provider.of<SignupProvider>(context);
    return Scaffold(
      appBar: getBackButton(context),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: userPro.role == 'Passenger'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Color(0xff2a2a2a),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomTextFormField(
                        hintText: 'Name',
                        controller: name,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        hintText: 'Email',
                        controller: email,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        hintText: 'Write phone with country code (+92)',
                        keyboardType: TextInputType.phone,
                        controller: phone,
                      ),
                      // PhoneInputField(
                      //   controller: phone,
                      //   onPhoneNumberChanged: (formattedNumber) {
                      //   },
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        hintText: 'Gender',
                        imagePath: 'assets/icons/arrow_down.svg',
                        controller: gender,
                        enabled: false,
                        onTap: () {
                          _showRoleSelectionBottomSheet(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/check_circle.svg'),
                            ],
                          ),
                          SizedBox(width: 5),
                          Expanded(
                              child: Text.rich(
                            TextSpan(
                              text: 'By signing up, you agree to our ',
                              style: GoogleFonts.poppins(
                                  color: Color(0xffB8B8B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff163051),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: GoogleFonts.poppins(
                                      color: Color(0xffB8B8B8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff163051),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                                TextSpan(
                                  text: '.',
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (name.text.isEmpty ||
                                email.text.isEmpty ||
                                phone.text.isEmpty ||
                                gender.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Please fill all the fields")),
                              );
                              return;
                            } else {
                              signupPro.setValues(name.text, email.text,
                                  phone.text, gender.text);
                              log('${signupPro.name},${signupPro.email},${signupPro.phone},${signupPro.gender}');
                              PhoneAuthHelper.sendOtp(
                                  phoneNumber: phone.text,
                                  context: context,
                                  onCodeSent: (String verificationId) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                            verificationId: verificationId),
                                      ),
                                    );
                                  },
                                  onError: (FirebaseAuthException error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(error.message ??
                                            "An error occurred"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => OtpScreen()));
                            }
                          },
                          child: getContainer(context, 'Sign up')),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  endIndent: 10, color: Color(0xffB8B8B8))),
                          Text(
                            'or',
                            style: GoogleFonts.poppins(
                                color: Color(0xffB8B8B8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                              child: Divider(
                                  indent: 10, color: Color(0xffB8B8B8))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        spacing: 15,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                GoogleButton().signupWithGoogle(context);
                              },
                              child: CustomContainer(
                                  svgPicture: 'assets/icons/gmail.svg')),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          spacing: 7,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff5a5a5a),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Sign in',
                              style: GoogleFonts.poppins(
                                  color: Color(0xff0F69DB),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : CustomStepperWidget()),
      ),
    );
  }

  void _showRoleSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Male', style: GoogleFonts.poppins(fontSize: 16)),
                onTap: () {
                  setState(() {
                    gender.text = 'Male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Female', style: GoogleFonts.poppins(fontSize: 16)),
                onTap: () {
                  setState(() {
                    gender.text = 'Female';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
