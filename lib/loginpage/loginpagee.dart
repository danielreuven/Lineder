import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lineder/animation/splashicon.dart';
import 'package:lineder/helpers/ensure_visible.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/loginpage/bubble.dart';
import 'package:lineder/loginpage/style.dart' as Theme;
import 'package:lineder/useroradmin.dart';

class LoginPage extends StatefulWidget {
  final String playload;
  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;
  LoginPage({
    Key key,
    this.playload,
  }) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Future<Null> _currentScreen() async {
  //   await widget.analytics.setCurrentScreen(
  //     screenName: "LoginPage",
  //     screenClassOverride: "ScreenLogin Page",
  //   );
  // }

  // Future<Null> _sendAnalytics() async {
  //   await widget.analytics
  //       .logEvent(name: "LoginPage", parameters: <String, dynamic>{
  //     "LOGINWITH": "email",
  //   });
  // }

  // Future<Null> _sendAnalyticsLogin() async {
  //   await widget.analytics.logLogin(
  //     loginMethod: "email",
  //   );
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = TextEditingController();
  // TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  TextEditingController forgetPasswordController = TextEditingController();

  PageController _pageController;

  Color left = Colors.white; //white
  Color right = Colors.black; //black
  String w;
  bool loginFlag = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseUser user;

  Future<Null> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken, idToken: gSA.idToken);

    user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    // if (user.phoneNumber != null) {
    //   assert(user.phoneNumber != null);
    // }
    // assert(user.phoneNumber != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    print(user.displayName);
    print(user.email);
    print(user.uid);
    loginFlag = true;
  }

  // _addAllusers(methodlogin) {
  //   Firestore.instance.collection("AllUsers").document('${user.uid}').setData({
  //     "methodlogin": "$methodlogin",
  //     "userName": "${user.displayName}",
  //     "userEmail": "${user.email}",
  //     "user": "${user.uid}",
  //     // "name": "${user.displayName}",
  //     "phone": "${user.phoneNumber}",
  //     "photoUrl": "${user.photoUrl}",
  //     "bio": "",
  //     "followers": {},
  //   });
  // }

  void _nextPage(method, usermethod) {
    if (loginFlag) {
      print("Wellcome you sign");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserOrAdmin(
                  uid: usermethod.uid,
                  email: usermethod.email,
                  displayName: usermethod.displayName,
                  productId: productId,
                  photoUrl: usermethod.photoUrl,
                  phone: usermethod.phoneNumber,
                  currentocation: currentocation,
                  method: method)));
    }
  }

  // void _signOut() {
  //   googleSignIn.signOut();
  //   print("User Signed out Gmail");
  // }

  // void _signOutEmail() {
  //   _auth.signOut();
  //   print("User Signed out Email");
  // }

  String productId;

/////////enter e-mail and password//////

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser useremail;
  Future<String> signInEmail(String email, String password) async {
    useremail = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((useremail) async {
      if (!useremail.isEmailVerified) {
        showInSnack('${DemoLocalizations.of(context).confirmemail}');
      } else {
        final QuerySnapshot result = await Firestore.instance
            .collection('AllUsers')
            .where('user', isEqualTo: useremail.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          // // Update data to server if new user
          // Firestore.instance
          //     // .collection("$country")
          //     // .document(user.uid)
          //     .collection("AllUsers")
          //     .document('${useremail.uid}')
          //     .setData({
          //   "methodlogin": "email",
          //   "userName": "${useremail.displayName}",
          //   "userEmail": "${useremail.email}",
          //   "user": "${useremail.uid}",
          //   "phone": "${useremail.phoneNumber}",
          //   "photoUrl": "${useremail.photoUrl}",
          //   "bio": "",
          //   // "country": "$country",
          //   "location":
          //       GeoPoint(currentocation.latitude, currentocation.longitude)
          // });
        }
        loginFlag = true;
        _nextPage("email", useremail);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => UserOrAdmin(
        //               uid: useremail.uid,
        //               email: useremail.email,
        //               displayName: useremail.displayName,
        //               productId: productId,
        //               photoUrl: useremail.photoUrl,
        //               phone: useremail.phoneNumber,
        //               method: "email",
        //             )));
        showInSnack('${DemoLocalizations.of(context).login}');
      }
    }).catchError((e) {
      showInSnack('${DemoLocalizations.of(context).emailorpass}');

      print(e.details); // code, message, details
    });

    // _nextPage();

    return null;
  }

  void showInSnack(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  void showInSnakAction(value, FirebaseUser useremail) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      action: SnackBarAction(
        label: '${DemoLocalizations.of(context).sendagain}',
        onPressed: () {
          // signUpEmail(email, password);
        },
      ),
    ));
  }

  // @override
  signUpEmail(String email, String password) async {
    FirebaseUser useremail = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      showInSnack('${DemoLocalizations.of(context).emailexists}');
      print(e.message);
    });
    try {
      await useremail.sendEmailVerification();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                  Text('${DemoLocalizations.of(context).emailverification}'),
              actions: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.check),
                )
              ],
            );
          });
      // showInSnack('${DemoLocalizations.of(context).sendmail}');
      return useremail.uid;
    } catch (e) {
      showInSnack('${DemoLocalizations.of(context).emailexists}');
      print(e.message);
    }
  }

  Future<String> getCurrentUser() async {
    FirebaseUser useremail = await _auth.currentUser();
    return useremail.uid;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      showInSnack('${DemoLocalizations.of(context).sendmail}');
    }).catchError((e) {
      showInSnack('${DemoLocalizations.of(context).emailvalidator}');

      print(e.details); // code, message, details
    });
  }

  @override
  Widget build(BuildContext context) {
    return EnsureVisibleWhenFocused(
      focusNode: FocusNode(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new Scaffold(
          key: _scaffoldKey,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00AAFF),
                        const Color.fromRGBO(99, 138, 223, 1.0),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 1) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 0) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  var platporm;
  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  var currentocation;
  @override
  void initState() {
    super.initState();
    // _currentScreen(); // isSignedIn();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentocation = currloc;
      });
    });
    platporm = Platform.operatingSystem;
    print(platporm);
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Container(height: 33.0, width: 1.0, color: Colors.white),

            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  DemoLocalizations.of(context).signin,
                  style: TextStyle(
                      color: "${DemoLocalizations.of(context).language}" == 'he'
                          ? left
                          : right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "${DemoLocalizations.of(context).signup}",
                  style: TextStyle(
                      color: "${DemoLocalizations.of(context).language}" == 'he'
                          ? right
                          : left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DocumentSnapshot> documents;
  final Map<String, dynamic> _formData = {
    // 'name': null,
    'email': null,
    'password': null,
  };
  final Map<String, dynamic> _formDataLogin = {
    'email': null,
    'password': null,
  };
  bool forgetbool = false;
  funcforget() {
    if (forgetbool == false) {
      setState(() {
        this.forgetbool = true;
      });
    } else {
      setState(() {
        this.forgetbool = false;
      });
    }
  }
bool isLoggedIn=false;
Map userProfile;

  // bool isLoading = false;
  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKeyLogin,
            child: Stack(
              alignment: Alignment.bottomCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: DemoLocalizations.of(context).email,
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                            ),
                            validator: (String value) {
                              if (value.isEmpty ||
                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(value)) {
                                return '${DemoLocalizations.of(context).emailvalidator}';
                              }
                            },
                            onSaved: (String value) {
                              _formDataLogin['email'] = value;
                            },
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          color: Colors.black,
                          indent: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText:
                                  '${DemoLocalizations.of(context).password}',
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return '${DemoLocalizations.of(context).passwordvalidator}';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formDataLogin['password'] = value;
                            },
                            //val
                            //onSave
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 60.0),
                    child: InkWell(
                      onTap: () async {
                        try {
                          if (_formKeyLogin.currentState.validate()) {
                            _formKeyLogin.currentState.save();
                            // await _sendAnalyticsLogin();
                            // setState(() {
                            //   isLoading = true;
                            // });
                            print(_formDataLogin['email']);
                            print(_formDataLogin['password']);
                            await signInEmail(loginEmailController.text,
                                loginPasswordController.text);
                          }
                        } catch (e) {
                          print(e);
                        }
                        // signInEmail(_formDataLogin['email'], _formDataLogin['password']);
                      },
                      child: Text(
                        '${DemoLocalizations.of(context).login}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                  ),
                ),
                // : ColorLoader3(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: funcforget,
                child: Text(
                  '${DemoLocalizations.of(context).forgetpassword}',
                  style: TextStyle(
                      // decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
          forgetbool == true
              ? Card(
                  child: Container(
                    height: 40,
                    child: TextField(
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                      // controller: forgetPasswordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            try {
                              if (forgetPasswordController.text != null) {
                                resetPassword(forgetPasswordController.text);
                              }
                            } catch (e) {
                              print(e);
                            }
                            return null;
                            // else {
                            //   print("not good");
                            // }
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                        hintText: '${DemoLocalizations.of(context).email}',
                      ),
                      onSubmitted: ((value) {
                        forgetPasswordController.text = value;
                        if (forgetPasswordController.text != null) {
                          resetPassword(forgetPasswordController.text);
                        }
                      }),
                      onChanged: (value) {
                        forgetPasswordController.text = value;
                      },

                      // controller: forgetPasswordController,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    '${DemoLocalizations.of(context).or}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.only(top: 10.0, right: 40.0),
              //   child: GestureDetector(
              //     onTap: () {
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(15.0),
              //       decoration: new BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //       ),
              //       child: new Icon(
              //         FontAwesomeIcons.facebookF,
              //         color: Color(0xFF0084ff),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    showInSnackBar('${DemoLocalizations.of(context).login}');
                    try {
                      _signIn().then((s) async {
                        if (user.uid != null && user.email != null) {
                          // await _sendAnalyticsLogin();

                          final QuerySnapshot result = await Firestore.instance
                              .collection('AllUsers')
                              .where('user', isEqualTo: user.uid)
                              .getDocuments();
                          documents = result.documents;
                          if (documents.length == 0) {
                            print("new userssss");
                            // await Firestore.instance
                            //     // .collection("$country")
                            //     // .document(user.uid)
                            //     .collection("AllUsers")
                            //     .document('${user.uid}')
                            //     .setData({
                            //   "methodlogin": "gmail",
                            //   "userName": "${user.displayName}",
                            //   "userEmail": "${user.email}",
                            //   "user": "${user.uid}",
                            //   "phone": "${user.phoneNumber}",
                            //   "photoUrl": "${user.photoUrl}",
                            //   "bio": "",
                            //   // "country": "$country",
                            //   "location": GeoPoint(currentocation.latitude,
                            //       currentocation.longitude)
                            // });
                          }

                          _nextPage("gmail", user);
                        }
                      }).catchError((e) {
                        print(e);
                      });
                    } catch (e) {}

                    // }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
          InformationApp(),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Column(
                      children: <Widget>[
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        //   child: TextFormField(
                        //     focusNode: myFocusNodeName,
                        //     controller: signupNameController,
                        //     keyboardType: TextInputType.text,
                        //     textCapitalization: TextCapitalization.words,
                        //     style: TextStyle(
                        //         fontFamily: "WorkSansSemiBold",
                        //         fontSize: 16.0,
                        //         color: Colors.black),
                        //     decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       icon: Icon(
                        //         FontAwesomeIcons.user,
                        //         color: Colors.black,
                        //       ),
                        //       hintText: "Name",
                        //       hintStyle: TextStyle(
                        //           fontFamily: "WorkSansSemiBold",
                        //           fontSize: 16.0),
                        //     ),
                        //     validator: (value) {
                        //       if (value.isEmpty) {
                        //         return 'Enter some text';
                        //       }
                        //       return null;
                        //     },
                        //     onSaved: (String value) {
                        //       _formData['name'] = value;
                        //     },
                        //   ),
                        // ),
                        // Divider(
                        //   height: 1,
                        //   color: Colors.black,
                        //   indent: 20,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmail,
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                              hintText:
                                  '${DemoLocalizations.of(context).email}',
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0),
                            ),
                            validator: (String value) {
                              if (value.isEmpty ||
                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(value)) {
                                return '${DemoLocalizations.of(context).emailvalidator}';
                              }
                            },
                            onSaved: (String value) {
                              _formData['email'] = value;
                            },
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black,
                          indent: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePassword,
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText:
                                  '${DemoLocalizations.of(context).password}',
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return '${DemoLocalizations.of(context).passwordvalidator}';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _formData['password'] = value;
                            },
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black,
                          indent: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText:
                                  '${DemoLocalizations.of(context).confirmpassword}',
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextSignupConfirm
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: ((value) {
                              if (value.isNotEmpty &&
                                  value != signupPasswordController.text) {
                                return '${DemoLocalizations.of(context).confirmpasswordvalidator}';
                              }
                              return null;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 340.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 60.0),
                    child: InkWell(
                      onTap: () {
                        try {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print(_formData);
                            print(_formData['name']);
                            print(_formData['email']);
                            print(_formData['password']);
                            signUpEmail(signupEmailController.text,
                                signupPasswordController.text);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        '${DemoLocalizations.of(context).signuppp}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    String lang = "${DemoLocalizations.of(context).language}";
    _pageController.animateToPage(lang == 'he' ? 1 : 0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    String lang = "${DemoLocalizations.of(context).language}";
    _pageController?.animateToPage(lang == 'he' ? 0 : 1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
