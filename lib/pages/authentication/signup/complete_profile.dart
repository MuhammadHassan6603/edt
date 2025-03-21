import 'dart:io';
import 'package:edt/pages/authentication/signup/provider/signup_provider.dart';
import 'package:edt/pages/authentication/signup/services/signup_service.dart';
import 'package:edt/pages/authentication/signup/widgets/phone_field.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:svg_flutter/svg.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var signupPro = Provider.of<SignupProvider>(context);
    TextEditingController fullName = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController street = TextEditingController();
    TextEditingController city = TextEditingController();
    TextEditingController district = TextEditingController();

    fullName.text = signupPro.name;
    phone.text = signupPro.phone;
    email.text = signupPro.email;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_ios,
                                size: 24, color: Color(0xff414141)),
                            Text('Back',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff414141),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text('Profile',
                              style: GoogleFonts.poppins(
                                color: const Color(0xff2a2a2a),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: Icon(Icons.person, size: 25)),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            color: Color(0xff163051),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child:
                                  SvgPicture.asset('assets/icons/camera.svg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                    hintText: 'Full Name', controller: fullName),
                const SizedBox(height: 20),
                CustomTextFormField(
                  hintText: 'Phone',
                  controller: phone,
                  enabled: false,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                    hintText: 'Email', controller: email, enabled: false),
                const SizedBox(height: 20),
                CustomTextFormField(hintText: 'Street', controller: street),
                const SizedBox(height: 20),
                CustomTextFormField(hintText: 'City', controller: city),
                const SizedBox(height: 20),
                CustomTextFormField(hintText: 'District', controller: district),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomBar()));
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xff163051))),
                          child: Center(
                            child: Text('Cancel',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff414141),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          var roleProvider = Provider.of<UserRoleProvider>(
                              context,
                              listen: false);
                          String role = roleProvider.role;
                          SignupService signupService = SignupService();
                          EasyLoading.show(status: 'Saving...');
                          await signupService.updateUserProfile(
                            fullName.text,
                            phone.text,
                            email.text,
                            street.text,
                            city.text,
                            district.text,
                            _imageFile?.path ?? '',
                            role,
                            context,
                          );
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess('Saved');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomBar()));
                        },
                        child: getContainer(context, 'Save'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
