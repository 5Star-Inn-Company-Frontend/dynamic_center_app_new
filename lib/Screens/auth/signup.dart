import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); // Option 2
  String _selectedcompanyid = ""; // Option 2
  List<Source> _region = [];
  Source? _currentUser;
  String dialogtitle = "Signup Error";
  var cmddetails;

  @override
  void initState() {
    super.initState();
    getData();
    _mockCheckForSession().then((status) async {
      if (status) {
        loading();
      }
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 100), () {});

    return true;
  }

  void getData() async {
    // loading();
    try {
      http.Response response = await http.get(parseUrl("companys"));
      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        final items = cmddetails["data"].cast<Map<String, dynamic>>();
        setState(() {
          _region = items.map<Source>((json) {
            return Source.fromJson(json);
          }).toList();
        });
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: "Contact Admin",
          onPostivePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  // return JsonApiDropdown();
                  return Login();
                },
              ),
            );
          },
          positiveBtnText: 'Continue',
          // negativeBtnText: 'No'
        );
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    } on Exception {
      Navigator.of(context).pop();
      var dialog = CustomAlertDialog(
        title: dialogtitle,
        message: nonetwork,
        onPostivePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                // return JsonApiDropdown();
                return Login();
              },
            ),
          );
        },
        positiveBtnText: 'Yes',
        // negativeBtnText: 'No'
      );
      showDialog(context: context, builder: (BuildContext context) => dialog);
    }
  }

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  void _login(
      firstName, lastName, email, password, phoneno, companyId) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var jsonBody = {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneno': phoneno,
          'company_id': companyId,
          'referral': ''
        };
        http.Response response =
            await http.post(parseUrl("signup"), body: jsonBody);

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          Navigator.of(context).pop();
          if (cmddetails['status'] == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  // return JsonApiDropdown();
                  return Login();
                },
              ),
            );
            // Scaffold
            //     .of(context)
            //     .showSnackBar(SnackBar(content: Text('You can now login')));
          } else {
            var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message'] + "\n" + cmddetails['error'],
              onPostivePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // return JsonApiDropdown();
                      return Login();
                    },
                  ),
                );
              },
              positiveBtnText: 'Continue',
              // negativeBtnText: 'Cancel'
            );
            showDialog(
                context: context, builder: (BuildContext context) => dialog);
          }
        } else {
          Navigator.of(context).pop();
          var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: "Connection Error",
              // onPostivePressed: () {},
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue');
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        }
      } on Exception {
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
            title: dialogtitle,
            message: nonetwork,
            // onPostivePressed: () {},
            // positiveBtnText: 'Ok',
            negativeBtnText: 'Cancel');
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log(size.height.toString());
    // if (size.height >= 988) {
    //   cardheight = size.height;
    // }if (size.height >= 860) {
    //   cardheight = size.height* 1.17;
    // } else if (size.height >= 734) {
    //   cardheight = size.height * 1.25;
    // } else if (size.height >= 681) {
    //   cardheight = size.height * 1.8;
    // } else if (size.height >= 565) {
    //   cardheight = size.height * 2.3;
    // } else {
    //   cardheight = size.height * 7;
    // }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: SizedBox(
              height: cardheight(context: context, needed: true),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Gap(40.h),
                    Text(
                      "Create Account",
                      style:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    
                    Gap(20.h),
                    Image(
                      image: AssetImage("assets/images/office.png"),
                    ),

                    Expanded(
                      child: Cardlayout(
                        child: Container(
                          width: size.width,
                          margin: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                companylist(),
                                Gap(15.h),

                                firstname(),
                                Gap(15.h),

                                lastname(),
                                Gap(15.h),

                                phoneno(),
                                Gap(15.h),

                                email(),
                                Gap(15.h),

                                password(),
                                Gap(25.h),

                                RoundedButton(
                                  text: "Create Account",
                                  press: () {
                                    _login(
                                        firstnameController.text,
                                        lastnameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        phoneController.text,
                                        _selectedcompanyid);
                                  },
                                ),
                                Gap(20.h),
                                
                                AlreadyHaveAnAccountCheck(
                                  login: false,
                                  press: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Login();
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Gap(20.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
            )
          ),
      ),
    );
  }

  Widget companylist() {
    return DropdownButtonFormField<Source>(
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      value: _currentUser,
      hint: Text('Select Company', style: GoogleFonts.poppins(fontSize: 12.sp)),
      validator: (value) => value == null ? 'field required' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      items: _region.map((user) {
        return DropdownMenuItem<Source>(
          value: user,
          child: Text(user.name, style: GoogleFonts.poppins(fontSize: 12.sp)),
        );
      }).toList(),
      onChanged: (Source? salutation) => setState(() {
        _currentUser = salutation;
        _selectedcompanyid = _currentUser!.id.toString();
      }),
      
    );
  }

  Widget firstname() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "First Name",
      onChanged: (value) {
        setState(() {
          firstnameController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 3) {
          return "your name must be atleast 3 character";
        }
        return null;
      },
    );
  }

  Widget lastname() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Last Name",
      onChanged: (value) {
        setState(() {
          lastnameController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 3) {
          return "your name must be atleast 3 character";
        }
        return null;
      },
    );
  }

  Widget phoneno() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Phone number",
      onChanged: (value) {
        setState(() {
          phoneController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 11) {
          return "incomplete phone number";
        } else if (value.length > 11) {
          return "invalid phone number";
        }
        return null;
      },
    );
  }

  Widget email() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Email Address",
      onChanged: (value) {
        setState(() {
          emailController.text = value;
        });
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (!EmailValidator.validate(value.toString())) {
          return "Invalid Email Address";
        }
        return null;
      },
    );
  }

  Widget password() {
    return RoundedPasswordField(
      onChanged: (value) {
        setState(() {
          passwordController.text = value;
        });
      },
      press: () {
        _toggle();
      },
      obscureText: _obscureText,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }
}

class Source {
  int id;
  String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["id"] as int,
      name: json["name"] as String,
    );
  }
}
