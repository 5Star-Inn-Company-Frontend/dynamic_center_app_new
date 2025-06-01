import 'package:dynamic_center/Screens/verify_phone_number2.dart';
import 'package:dynamic_center/Screens/verify_phone_number3.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/device.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';

class VerifyPhoneNumber extends StatefulWidget {
  VerifyPhoneNumber({Key? key}) : super(key: key);

  @override
  _VerifyPhoneNumberState createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController phoneController = TextEditingController();
  String image = "https://www.countryflags.io/AF/flat/64.png",
      country = "Afghanistan",
      code = "";
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  RegExp regEx = RegExp(
      r"(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})");
  @override
  void initState() {
    super.initState();
    code = "+93";
  }

  final _formKey = GlobalKey<FormState>();

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyPhoneNumber2(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      String details, details1;
      if (result == null) {
        details = "Afghanistan- +93;https://www.countryflags.io/AF/flat/64.png";
      } else {
        details = result;
      }
      var array = details.split(';');
      details1 = array[0];
      var array1 = details1.split('-');
      country = array1[0];
      code = array1[1];
      image = array[1];
      // text = result;
    });
  }

  String checknumber() {
    if (phoneController.text.length == 11) {
      return phoneController.text.substring(1);
    } else {
      return phoneController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text(
          "Verify Phone Number",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: Column(children: [
            SizedBox(height: 10),
            Text(
              "Please select your country and your phone number to receive a verification code",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Expanded(
              child: Cardlayout(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          _awaitReturnValueFromSecondScreen(context);
                        },
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.only(right: 5, left: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Color(scafoldcolour),
                            child: Container(
                              margin: EdgeInsets.only(right: 10, left: 10),
                              child: Row(children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(image),
                                  backgroundColor: Color(scafoldcolour),
                                  radius: 20,
                                ),
                                Container(
                                  width: 20,
                                ),
                                Text(country),
                                Spacer(),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Color(0xffB5BBC9),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Container(
                          child: phoneno(),
                          margin: EdgeInsets.all(20),
                        ),
                      ),
                      SizedBox(height: 70),
                      RoundedButton(
                        text: "Submit",
                        press: () {
                          print(code + checknumber());
                          if (_formKey.currentState!.validate()) {
                            if (DeviceAllow.allow()) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyPhoneNumber3(
                                      phonenumber: code + checknumber(),
                                    ),
                                  ));
                            } else {
                              Snackbar.showMessage(
                                  "kindly make use of mobile device",
                                  _scaffoldKey);
                            }
                          }
                        },
                      ),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget phoneno() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Phone number",
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          phoneController.text = value;
        });
      },
      prefixText: code,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (!regEx.hasMatch(code + checknumber())) {
          return "invalid phone number";
        }
        return null;
      },
    );
  }
}
