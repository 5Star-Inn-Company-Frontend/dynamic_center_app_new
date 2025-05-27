import 'package:dynamic_center/Screens/Xchange.dart';
import 'package:dynamic_center/Screens/landing_page.dart';
import 'package:dynamic_center/Screens/transaction.dart';
import 'package:dynamic_center/Screens/transfer.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainActivity extends StatefulWidget {
  Widget child;
  final int currentIndex;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  MainActivity(
      {Key? key, required this.child, this.currentIndex = 1, this.scaffoldKey})
      : super(key: key);

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  var cmddetails;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // final plugin = FacebookLogin(debug: true);

  // Future<void> _onPressedLogOutButton() async {
  //   await plugin.logOut();
  //   // await _updateLoginInfo();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   child = Background(_controller);
  //   getData();
  // }
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    getData();
  }

  void getData() async {
    try {
      http.Response response = await http.get(parseUrl("user"), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });

      if (response.statusCode == 200) {
        String data = response.body;
        cmddetails = jsonDecode(data);
        SaveDetails(cmddetails, false);
        print("hello people");
        print(cmddetails);
        // Scaffold
        //     .of(context)
        //     .showSnackBar(SnackBar(content: Text('You can now login')));

      }
    } catch (Exception) {}
  }

  void animate(String hero) {
    _startAnimation(_controller!);
  }

  void _backViewOnClick(int position) async {
    switch (position) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LandingPage();
            },
          ),
        );
        break;
      case 1:
        setState(() {
          // child = fluttermvm();
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Deposit();
            },
          ),
        );
        break;
      case 3:
        animate("Hulk");
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Transfer();
            },
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Xchange();
            },
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Profile();
            },
          ),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Support();
            },
          ),
        );
        break;
      case 8:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Login();
            },
          ),
        );
        if (googlelogin) {
          await _googleSignIn.signOut();
          print("User Sign Out");
        } 
        // else if (facebooklogin) {
        //   plugin.logOut();
        // }
        break;

      default:
    }
    _startAnimation(_controller!);
  }

  Widget activityContainer(BuildContext context, BoxConstraints constraint) {
    final ThemeData _theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    print(size.height);
    return Container(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              child: _backView(_theme),
              height: size.height,
            ),
            GestureDetector(
              child: Container(
                child: _frontView(),
                height: size.height,
              ),
              onTap: () {
                if (draweropen) {
                  draweropen = false;
                  _controller!.fling(
                      velocity: AnimUtil.isBackpanelVisible(_controller!)
                          ? -1.0
                          : 1.0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  // final String imageUrl =
  // "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";

  final List<MenuItem> options = [
    MenuItem(Icons.home, 'HomePage', 0),
    // MenuItem(Icons.add, 'Wallet',1),
    MenuItem(Icons.account_balance, 'Deposit', 2),
    // MenuItem(Icons.arrow_circle_down, 'Withdraw',3),
    MenuItem(Icons.arrow_circle_up, 'Transfer', 4),
    MenuItem(Icons.zoom_out_map, 'Exchange', 5),
    MenuItem(Icons.account_box, 'Profile', 6),
  ];

  Widget _backView(ThemeData theme) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: theme.backgroundColor,
      //   elevation: 0.0,
      // ),
      backgroundColor: theme.colorScheme.background,
      body: Container(
        padding: EdgeInsets.only(
            top: 62, bottom: 8, right: MediaQuery.of(context).size.width / 2.9),
        color: Color(0xffE5E5E5),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircularImage(
                    NetworkImage(profile_path),
                  ),
                ),
                Text(
                  first_name + " " + last_name,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
                Text(
                  'Verify your profile',
                  style: GoogleFonts.poppins(
                    color: Color(primarycolour),
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Spacer(),
            Column(
              children: options.map((item) {
                return GestureDetector(
                  onTap: () => _backViewOnClick(item.position),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: Color(0xffCFD2D8),
                      size: 20,
                    ),
                    title: Text(
                      item.title,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            ListTile(
              onTap: () {
                _backViewOnClick(7);
              },
              leading: Icon(
                Icons.settings,
                color: Color(0xffCFD2D8),
                size: 20,
              ),
              title: Text('Support',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
            ListTile(
              onTap: () {
                _backViewOnClick(8);
              },
              leading: Icon(
                Icons.logout,
                color: Color(0xffCFD2D8),
                size: 20,
              ),
              title: Text('Sign out',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

/*
Frontview body is wrappped by SlideTransition and ScaleTransition.
Alignment is set to centerLeft inorder to show navigation back button.
*/

  Widget _frontView() {
    return SlideTransition(
        position: _getSlideAnimation(),
        child: ScaleTransition(
          alignment: Alignment.centerLeft,
          scale: _getScaleAnimation(),
          child: _frontViewBody(),
        ));
  }

  Widget _frontViewBody() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: Color(primarycolour),
        appBar: AppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(company),
            ],
          ),
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => _startAnimation(_controller!),
            icon: AnimatedIcon(
              icon: AnimatedIcons.arrow_menu,
              progress: _controller!,
            ),
          ),
        ),
        body:
            // physics: ClampingScrollPhysics(), child:
            Stack(alignment: Alignment.center, children: <Widget>[
          Positioned(
            child: Container(
              height: size.height,
              alignment: Alignment.center,
              color: Color(primarycolour),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.03),
                    Text(
                      wallet.toString(),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Wallet Balance",
                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
                    ),
                  ]),
            ),
          ),
          Positioned(
            top: 140.0,
            child: Cardlayout(
              // color: Colors.transparent,
              child: Container(
                height: size.height,
                width: size.width,
                child: widget.child,
              ),
            ),
          ),
        ]),
        // ),
        bottomNavigationBar: ConvexAppBar(
          cornerRadius: 25,
          style: TabStyle.fixedCircle,
          // backgroundColor: Color(scafoldcolour),
          items: [
            TabItem(icon: Icons.shopping_cart, title: 'Transactions'),
            TabItem(icon: Icons.home, title: 'Add'),
            TabItem(icon: Icons.account_balance, title: 'Deposit'),
          ],
          initialActiveIndex: widget.currentIndex, //optional, default as 0
          onTap: (int i) => _bottomOnClick(i),
          // print('click index=$i'),
        ));
    // return Container(
    //   color: Colors.white,
    //     child:child,
    // );
  }

  _bottomOnClick(int i) {
    switch (i) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Transaction();
            },
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LandingPage();
            },
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Deposit();
            },
          ),
        );
        break;

      default:
    }
    if (draweropen) {
      _startAnimation(_controller!);
    }
  }

  void _startAnimation(AnimationController _controller) {
    if (draweropen) {
      draweropen = false;
    } else {
      draweropen = true;
    }
    _controller.fling(
        velocity: AnimUtil.isBackpanelVisible(_controller) ? -1.0 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: activityContainer,
    );
  }

/*
FrontView Slide Animation
*/

  Animation<Offset> _getSlideAnimation() {
    return Tween(begin: Offset(0.50, 0.0), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));
  }

/*
Front View Scale Animation
*/

  Animation<double> _getScaleAnimation() {
    return Tween(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));
  }
}

class MenuItem {
  String title;
  IconData icon;
  int position;

  MenuItem(this.icon, this.title, this.position);
}
