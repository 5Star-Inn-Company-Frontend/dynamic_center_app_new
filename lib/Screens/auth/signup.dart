import 'dart:convert';

import 'package:dynamic_center/general/SizeConfig.dart';
import 'package:dynamic_center/general/component/already_have_an_account_acheck.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/component/rounded_password_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(); // Option 2
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
    } catch (Exception) {
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
      first_name, last_name, email, password, phoneno, company_id) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'password': password,
          'phoneno': phoneno,
          'company_id': company_id,
          'referral': ''
        };
        http.Response response =
            await http.post(parseUrl("signup"), body: json_body);

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
      } catch (Exception) {
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
    print(size.height);
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
            child: Container(
              height: cardheight(context: context, needed: true),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.07),
                    Text(
                      "Create Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    SizedBox(height: size.height * 0.03),
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
                                SizedBox(
                                  height: 20,
                                ),
                                firstname(),
                                SizedBox(
                                  height: 20,
                                ),
                                lastname(),
                                SizedBox(
                                  height: 20,
                                ),
                                phoneno(),
                                SizedBox(
                                  height: 20,
                                ),
                                email(),
                                SizedBox(
                                  height: 20,
                                ),
                                password(),
                                SizedBox(height: size.height * 0.05),
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
                                SizedBox(height: size.height * 0.03),
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
                                SizedBox(height: size.height * 0.03),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget companylist() {
    return DropdownButtonFormField<Source>(
      items: _region.map((user) {
        return DropdownMenuItem<Source>(
          child: Text(user.name),
          value: user,
        );
      }).toList(),
      value: _currentUser,
      hint: Text('Select Company'),
      onChanged: (Source? salutation) => setState(() {
        _currentUser = salutation;
        _selectedcompanyid = _currentUser!.id.toString();
      }),
      validator: (value) => value == null ? 'field required' : null,
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
