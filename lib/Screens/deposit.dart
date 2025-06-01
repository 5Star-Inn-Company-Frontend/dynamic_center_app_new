import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/device.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/component/rounded_input_field.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constant/doublebutton.dart';
import 'Camera/camera_screen.dart';
import 'drawer/main_activity.dart';

class Deposit extends StatefulWidget {
  final String carname, expire, cardnumber;
  Deposit({Key? key, this.carname = "", this.cardnumber = "", this.expire = ""})
      : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  TextEditingController CnController = TextEditingController();
  TextEditingController ChnController = TextEditingController();
  TextEditingController EdController = TextEditingController();
  TextEditingController CvvController = TextEditingController();
  TextEditingController AmountController = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  CheckoutMethod _method = CheckoutMethod.card;
  bool _isLocal = true;
  double space = 20;
  String webViewUrl = "";
  String url = "";
  int _expiryMonth = 0, _expiryYear = 0;
  String dialogtitle = "Error in Depositing";
  String _textValue = "sample";
  PaystackPayment paystackPlugin = PaystackPayment();
  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  @override
  void initState() {
    paystackPlugin.initialize(publicKey: paystackPublicKey);
    if (widget.expire != null) {
      EdController.text = widget.expire;
    }
    if (widget.cardnumber != null) {
      CnController.text = widget.cardnumber;
    }
    if (widget.carname != null) {
      ChnController.text = widget.carname;
    }
    super.initState();
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      if (!DeviceAllow.allow()) {
        Navigator.pop(context);
        await launch(url);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  void _deposit(String cn, chn, ed, cvv) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      loading();
      // if(token != null){
      //   headers.addAll({"Authorization" : "Bearer "+token});
      // }
      try {
        var json_body = {
          'username': cn,
          'password': chn,
          'username': ed,
          'password': cvv,
          'device_name': device1
        };
        http.Response response =
            await http.post(parseUrl("login"), body: json_body);

        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          String data = response.body;
          var cmddetails = jsonDecode(data);
          print(cmddetails);
          if (cmddetails['status'] == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LandingPage();
                },
              ),
            );
            // Scaffold
            //     .of(context)
            //     .showSnackBar(SnackBar(content: Text('You can now login')));
          } else {
            print(cmddetails);
            print(response.statusCode);
            var dialog = CustomAlertDialog(
                title: dialogtitle,
                message: cmddetails['message'] + "\n" + cmddetails['error'],
                negativeBtnText: 'Continue');
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
        }
      } catch (Exception) {
        Navigator.of(context).pop();
        print(Exception);
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
    // Size size = MediaQuery.of(context).size;
    return MainActivity(
      currentIndex: 2,
      scaffoldKey: _scaffoldKey,
      child: Container(
        // width: size.width,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: space,
                      ),
                      amountwidget(),
                      Container(
                        height: space,
                      ),
                      Cn(),
                      Container(
                        height: space,
                      ),
                      Chn(),
                      Row(children: [
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: space,
                                ),
                                Ed(),
                              ]),
                        )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: space,
                                  ),
                                  Cvv(),
                                ]),
                          ),
                        ),
                      ]),
                    ]),
              ),
              Container(
                height: space,
              ),
              RoundedButton(
                text: "Deposit",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      var array1 = EdController.text.split('/');
                      _expiryMonth = int.parse(array1[0]);
                      _expiryYear = int.parse(array1[1]);
                    });
                    webViewUrl = "https://mcd.5starcompany.com.ng/?";
                    // url = "${webViewUrl}fname=MCD_${widget.name}&email=${widget.email}"
                    //     "&ref=${widget.ref}&myref=${widget.ref}&phone=${widget.phone}&amount=${widget.amount}"
                    //     "&desc=${widget.nar}";
                    _launchURL();
                    _handleCheckout(context);
                    // _deposit(CnController.text,ChnController.text,EdController.text,CvvController.text);
                  }
                },
              ),
              Container(
                height: space,
              ),
              GestureDetector(
                onTap: () {
                  showAlertDialog(context);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(children: [
                    Image(
                      image: AssetImage("assets/images/ic_scan.png"),
                      height: 50,
                      width: 50,
                    ),
                    Container(
                      width: space,
                    ),
                    Text("Scan card")
                  ]),
                ),
              ),
            ]),
      ),
    );
  }

  Widget amountwidget() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
      ],
      labelText: "Amount",
      onChanged: (value) {},
      keyboardType: TextInputType.number,
      controller: AmountController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 3) {
          return "Amount to low";
        }
        return null;
      },
    );
  }

  Widget Cn() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
        CardNumberInputFormatter(),
      ],
      labelText: "Card number",
      onChanged: (value) {},
      keyboardType: TextInputType.number,
      controller: CnController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 12) {
          return "incomplete Card number";
        }
        return null;
      },
    );
  }

  Widget Chn() {
    return RoundedInputField(
      inputFormatters: [
        // FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      labelText: "Card holder name",
      onChanged: (value) {},
      controller: ChnController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        }
        return null;
      },
    );
  }

  Widget Ed() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        // FilteringTextInputFormatter.digitsOnly,
      ],
      // keyboardType: TextInputType.number,
      labelText: "Expiring Date",
      onChanged: (value) {},
      controller: EdController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 5) {
          return "incomplete expiring date";
        } else if (value.length > 5) {
          return "invalid expiring date";
        }
        return null;
      },
    );
  }

  Widget Cvv() {
    return RoundedInputField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      labelText: "Cvv",
      onChanged: (value) {},
      controller: CvvController,
      validate: (value) {
        if (value.isEmpty) {
          return "This field can't be empty";
        } else if (value.length < 3) {
          return "incomplete cvv";
        } else if (value.length > 3) {
          return "invalid cvv";
        }
        return null;
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Choose the Options'),
      content: Container(
        color: Colors.white,
        child: Column(children: [
          Container(
            height: 20,
          ),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CameraScreen(
                            cameraAppbar: "Scan Your ATM Card",
                            camerabutton: false,
                            cameracenter: true,
                            card: "hello",
                          );
                        },
                      ),
                    );
                  },
                  child: Image(
                    image: AssetImage("assets/images/camera.png"),
                    height: 50,
                    width: 50,
                  )),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return DetailScreen("", "file");
                    //   // return PreviewScreen(imgPath: path, fileName: "$name.png",);
                    // }));
                  },
                  child: Image(
                    image: AssetImage("assets/images/gallery.png"),
                    height: 50,
                    width: 50,
                  )),
              Spacer(),
            ],
          ),
        ]),
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _handleCheckout(BuildContext context) async {
    if (_method == null) {
      Snackbar.showMessage('Select checkout method first', _scaffoldKey);
      return;
    }

    if (_method != CheckoutMethod.card && _isLocal) {
      Snackbar.showMessage(
          'Select server initialization method at the top', _scaffoldKey);
      return;
    }
    // setState(() => _inProgress = true);
    _formKey.currentState!.save();
    Charge charge = Charge()
      ..amount = int.parse("${AmountController.text}00") // In base currency
      ..email = 'customer@email.com'
      ..card = _getCardFromUI();

    if (!_isLocal) {
      // var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      // charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    try {
      CheckoutResponse response = await paystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        // logo: MyLogo(),
      );
      print('Response = $response');
      // setState(() => _inProgress = false);
      _updateStatus(response.reference!, '$response');
    } catch (e) {
      // setState(() => _inProgress = false);
      Snackbar.showMessage("Check console for error", _scaffoldKey);
      rethrow;
    }
  }

  _startAfreshCharge() async {
    _formKey.currentState!.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    // setState(() => _inProgress = true);

    if (_isLocal) {
      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an exception

      charge
        ..amount = 10000 // In base currency
        ..email = 'customer@email.com'
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Flutter SDK');
      _chargeCard(charge);
    } else {
      // Perform transaction/initialize on Paystack server to get an access code
      // documentation: https://developers.paystack.co/reference#initialize-a-transaction
      // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

  _chargeCard(Charge charge) async {
    final response = await paystackPlugin.chargeCard(context, charge: charge);

    final reference = response.reference;

    // Checking if the transaction is successful
    if (response.status) {
      // _verifyOnServer(reference);
      return;
    }

    // The transaction failed. Checking if we should verify the transaction
    if (response.verify) {
      // _verifyOnServer(reference);
    } else {
      // setState(() => _inProgress = false);
      _updateStatus(reference!, response.message);
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      cardNumber: CnController.text,
      cvv: CvvController.text,
      expiryMonth1: _expiryMonth,
      expiryYear1: _expiryYear,
    );

    // Using Cascade notation (similar to Java's builder pattern)
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear)
//      ..name = 'Segun Chukwuma Adamu'
//      ..country = 'Nigeria'
//      ..addressLine1 = 'Ikeja, Lagos'
//      ..addressPostalCode = '100001';

    // Using optional parameters
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear,
//        name: 'Ismail Adebola Emeka',
//        addressCountry: 'Nigeria',
//        addressLine1: '90, Nnebisi Road, Asaba, Deleta State');
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = new CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: new Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = DoubleButton(
        name: string.toUpperCase(),
        textcolor: Colors.white,
        press: () {
          function();
        },
      );
    }
    return widget;
  }

  // Future<String> _fetchAccessCodeFrmServer(String reference) async {
  //   String url = '$backendUrl/new-access-code';
  //   String accessCode;
  //   try {
  //     print("Access code url = $url");
  //     http.Response response = await http.get(url);
  //     accessCode = response.body;
  //     print('Response for access code = $accessCode');
  //   } catch (e) {
  //     // setState(() => _inProgress = false);
  //     _updateStatus(
  //         reference,
  //         'There was a problem getting a new access code form'
  //             ' the backend: $e');
  //   }
  //
  //   return accessCode;
  // }
  //
  // void _verifyOnServer(String reference) async {
  //   _updateStatus(reference, 'Verifying...');
  //   String url = '$backendUrl/verify/$reference';
  //   try {
  //     http.Response response = await http.get(url);
  //     var body = response.body;
  //     _updateStatus(reference, body);
  //   } catch (e) {
  //     _updateStatus(
  //         reference,
  //         'There was a problem verifying %s on the backend: '
  //             '$reference $e');
  //   }
  //   // setState(() => _inProgress = false);
  // }

  _updateStatus(String reference, String message) {
    Snackbar.showMessage(
        'Reference: $reference \n\ Response: $message', _scaffoldKey);
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
