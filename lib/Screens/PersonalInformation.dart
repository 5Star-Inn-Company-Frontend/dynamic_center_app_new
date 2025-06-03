import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PersonalInformation extends StatefulWidget {
  PersonalInformation({Key? key}) : super(key: key);

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String dialogtitle = "Updating profile Error";
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1700),
      // lastDate: DateTime(2021),
      lastDate: new DateTime.now().add(new Duration(days: 0)),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        // selectedDate = picked;
        dateofbirthController =
            TextEditingController(text: "${picked.toLocal()}".split(' ')[0]);
      });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  // @protected
  // @mustCallSuper
  // void didChangeDependencies() {
  //   getData();
  // }
  void getData() async {
    setState(() {
      firstnameController.text = firstName;
      // firstnameController.selection = TextSelection.collapsed(offset: firstnameController.text.length);

      lastnameController.text = lastName;
      // lastnameController.selection = TextSelection.fromPosition(TextPosition(offset:lastnameController.text.length));
      addressController.text = address;
      // addressController .selection = TextSelection.fromPosition(TextPosition(offset:addressController.text.length));
      dateofbirthController.text = dob;
      // dateofbirthController.selection = TextSelection.fromPosition(TextPosition(offset:dateofbirthController.text.length));
      phoneController.text = phoneno;
      // phoneController.selection = TextSelection.fromPosition(TextPosition(offset:phoneController.text.length));
      genderController.text = gender;
      // genderController.selection = TextSelection.fromPosition(TextPosition(offset:genderController.text.length));
      emailController.text = email;
      // emailController.selection = TextSelection.fromPosition(TextPosition(offset:emailController.text.length));

      // cityController.selection = TextSelection.fromPosition(TextPosition(offset:cityController.text.length));

      // CitizenshipController.selection = TextSelection.fromPosition(TextPosition(offset:CitizenshipController.text.length));
    });
  }

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController genderController = TextEditingController(); // O
  TextEditingController CitizenshipController = TextEditingController(); //
  TextEditingController dateofbirthController = TextEditingController(); //
  TextEditingController phoneController = TextEditingController(); // O
  TextEditingController emailController = TextEditingController(); //
  int _radioValue = 0;
  Color textcolor = primarycolour2;
  Color unselectedcolor = Color(0xff000056);
  var typ = "Gender";

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  void _update(firstName, lastName, address, date, city, gender, citizenship,
      phoneno, email) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      // loading();

      try {
        var json_body = {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'date': date,
          'phoneno': city,
          'gender': gender,
          'country': citizenship,
          // 'phoneno': phoneno,
          // 'email': email,
        };
        http.Response response = await http.post(parseUrl("updateprofile"),
            body: json_body,
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          Navigator.of(context).pop();
          if (cmddetails['status'] == 1) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       // return JsonApiDropdown();
            //       return Login();
            //     },
            //   ),
            // );
            // Scaffold
            //     .of(context)
            //     .showSnackBar(SnackBar(content: Text('You can now login')));
          } else {
            var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message'] + "\n" + cmddetails['error'],
              onPostivePressed: () {
                // Navigator.push(
                //   context,
                // MaterialPageRoute(
                //   builder: (context) {
                //     // return JsonApiDropdown();
                //     return Login();
                //   },
                // ),
                // );
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
        print(Exception);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personal Information",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Cardlayout(
            child: Form(
              key: _formKey,
              child: Container(
                width: size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 20,
                      ),
                      firstname(),
                      SizedBox(
                        height: 30,
                      ),
                      lastname(),
                      SizedBox(
                        height: 30,
                      ),
                      addresswidget(),
                      SizedBox(
                        height: 30,
                      ),
                      dateofbirth(),
                      SizedBox(
                        height: 30,
                      ),
                      city(),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Gender",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              value: 0,
                              activeColor: primarycolour2,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChanged,
                              title: Text(
                                'Male',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _radioValue == 0
                                      ? textcolor
                                      : unselectedcolor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              value: 1,
                              activeColor: primarycolour2,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChanged,
                              title: Text(
                                'Female',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _radioValue == 1
                                      ? textcolor
                                      : unselectedcolor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Citizenship(),
                      Container(
                        height: 30,
                      ),
                      RoundedButton(
                        text: "Save",
                        press: () {
                          _update(
                              firstnameController.text,
                              lastnameController.text,
                              addressController.text,
                              dateofbirthController.text,
                              cityController.text,
                              genderController.text,
                              CitizenshipController.text,
                              phoneController.text,
                              emailController.text);
                        },
                      ),
                      Container(
                        height: 30,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firstname() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "First Name",
      // onChanged: (value) {
      //   setState(() {
      //     firstnameController.text = value;
      //   });
      // },
      // initialValue: prefs.getString('firstName'),
      // controller: firstnameController,
      controller: firstnameController,
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
      // onChanged: (value) {
      //   setState(() {
      //     lastnameController.text = value;
      //   });
      // },
      // initialValue: lastName,
      controller: lastnameController,
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

  Widget addresswidget() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Street address",
      // onChanged: (value) {
      //   setState(() {
      //     addressController.text = value;
      //   });
      // },
      controller: addressController,
      // initialValue: addresstext,
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

  Widget phonenowidget() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Phone number",
      // onChanged: (value) {
      //   setState(() {
      //     phoneController.text = value;
      //   });
      // },
      keyboardType: TextInputType.number,
      controller: phoneController,
      // initialValue: phonenotext,
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

  Widget dateofbirth() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Date of Birth",
      // onChanged: (value) {
      //   setState(() {
      //     dateofbirthController.text = value;
      //   });
      // },
      onTap: () {
        _selectDate(context);
      },
      controller: dateofbirthController,
      // initialValue: dateofbirthtext,
      focusNode: FocusNode(),
      enableInteractiveSelection: false,
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

  Widget city() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "City",
      // onChanged: (value) {
      //   setState(() {
      //     cityController.text = value;
      //   });
      // },
      controller: cityController,
      // initialValue: citytext,
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

  void _handleRadioValueChanged(int? value) {
    setState(() {
      if (value == 0) {
        genderController.text = "Male";
      }

      if (value == 1) {
        genderController.text = "Female";
      }
      _radioValue = value!;
    });
  }

  Widget Citizenship() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Country",
      // onChanged: (value) {
      //   setState(() {
      //     CitizenshipController.text = value;
      //   });
      // },
      controller: CitizenshipController,
      // initialValue: Citizenshiptext,
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

  Widget emailwidget() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Email Address",
      // onChanged: (value) {
      //   setState(() {
      //     emailController.text = value;
      //   });
      // },
      keyboardType: TextInputType.emailAddress,
      // initialValue: emailtext,
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
}
