import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:http/http.dart' as http;

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  String dialogtitle = "Forget Password Error";
  // final bool _isloading = false;

  void loading(){
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  void _resetpassword(String email) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      // loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var jsonBody = {
          'username': email,
        };
        http.Response response = await http.post(parseUrl('resetpassword'), body: jsonBody);

        if (response.statusCode == 200) {
          String data = response.body;
          var cmddetails = jsonDecode(data);
          Navigator.of(context).pop();
          if(cmddetails['status'] == 1){
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
          }else{
            var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message']+"\n"+cmddetails['error'],
              onPostivePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
              },
              positiveBtnText: 'Continue',
              // negativeBtnText: 'Cancel'
            );
            showDialog(
                context: context,
                builder: (BuildContext context) => dialog);
          }
        } else {
          Navigator.of(context).pop();
          var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: "Connection Error",
              // onPostivePressed: () {},
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue'
          );
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog);
        }
      }on Exception{
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
            title: dialogtitle,
            message: nonetwork,
            // onPostivePressed: () {},
            // positiveBtnText: 'Ok',
            negativeBtnText: 'Cancel');
        showDialog(
            context: context,
            builder: (BuildContext context) => dialog);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Forgot Password?",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
            child: SizedBox(
            height: size.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Gap(20.h),
                  Text(
                    "Enter your registered Email address/Phone number to receive password reset instructions",
                    style: GoogleFonts.poppins(fontSize: 13.sp,),
                    textAlign: TextAlign.center,
                  ),

                  Gap(40.h),
                  Expanded(
                    child:
                    Cardlayout(
                      child: Container(
                        width: size.width,
                        margin: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              email(),
                              Gap(20.h),

                              RoundedButton(
                                text: "Reset Password",
                                press: () {
                                  _resetpassword(emailController.text);},
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
          ),
          ),
      ),
    );
  }
  
  Widget email () {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),

      ],
      labelText: "Your Email/Phone number",
      onChanged: (value) {
        emailController.text = value;
      },
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.contains('@')) {
          if (!EmailValidator.validate(value.toString())) {
            return "Invalid Email Address";
          }
        } else {
          if (value.length < 11) {
            return "Incomplete Phone number";
          } else if (value.length > 11) {
            return "Invalid Phone number";
          } else if(!isValidPhoneNumber(value.toString())){
            return "Invalid Phone number";
          }
        }
        return null;
      },
    );
  }
}