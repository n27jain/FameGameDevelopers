import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Declare Variables
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  final _globalKey = GlobalKey<ScaffoldState>();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //OnStart
  @override
  void initState() {
    super.initState();

    //set variables
    pageController = PageController();
    // googleSignIn.onCurrentUserChanged.listen((account) {
    //   handleSignIn(account);
    // }, onError: (err) {
    //   print('Error signing in: $err');
    // });
    // googleSignIn.signInSilently(suppressErrors: false).then((account) {
    //   handleSignIn(account);
    // }).catchError((err) {
    //   print('Error signing in: $err');
    // });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);
    print('signInWithGoogle succeeded: $user');
    //return 'signInWithGoogle succeeded: $user';
  }
  //Funtion Handlers
  // handleSignIn(GoogleSignInAccount account) async {
  //   if (account != null) {
  //     await createUserInFirestore();
  //     print("User signed in!: $account");
  //     setState(() {
  //       isAuth = true;
  //     });
  //     configurePushNotifications();
  //   } else {
  //     setState(() {
  //       isAuth = false;
  //     });
  //   }
  // }

  // configurePushNotifications() {
  //   final GoogleSignInAccount user = googleSignIn.currentUser;
  //   if (Platform.isIOS) getIOSPermission();

  //   _firebaseMessaging.getToken().then((token) {
  //     print("Firebase Messaging Token: $token\n");
  //     usersRef
  //         .document(user.id)
  //         .updateData({"androidNotificationToken": token});
  //   });

  //   _firebaseMessaging.configure(
  //     // onLaunch: (Map <String, dynamic>  message) async {},
  //     // onResume: (Map <String, dynamic>  message) async {},
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("Message: $message");
  //       final String recipientId = message['data']['recipient'];
  //       final String body = message['notification']['body'];
  //       if (recipientId == user.id) {
  //         print("Notification shown!");
  //         SnackBar snackbar = SnackBar(
  //             content: Text(
  //           body,
  //           overflow: TextOverflow.ellipsis,
  //         ));
  //         _globalKey.currentState.showSnackBar(snackbar);
  //       }
  //       print("Notification NOT shown");
  //     },
  //   );
  // }

  // getIOSPermission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(alert: true, badge: true, sound: true));
  //   _firebaseMessaging.onIosSettingsRegistered.listen((event) {
  //     print("Settings registered: $event");
  //   });
  // }

  // createUserInFirestore() async {
  //   //exists in userscollection in database
  //   final GoogleSignInAccount user = googleSignIn.currentUser;
  //   DocumentSnapshot doc = await usersRef.document(user.id).get();
  //   //if doesnt exists take to create account page
  //   if (!doc.exists) {
  //     final username = await Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => CreateAccount()));
  //     //get username from create account, use it to make a  new users document in the collection.
  //     usersRef.document(user.id).setData({
  //       "id": user.id,
  //       "username": username,
  //       "photoUrl": user.photoUrl,
  //       "email": user.email,
  //       "displayName": user.displayName,
  //       "bio": "",
  //       "timestamp": timeStamp,
  //     });

  //     // make new user their own follower (to include their posts in their timeline)
  //     await followersRef
  //         .document(user.id)
  //         .collection('usersFollowers')
  //         .document(user.id)
  //         .setData({});

  //     doc = await usersRef.document(user.id).get();
  //   }
  //   currentUser = User.fromDocument(doc);
  //   print(currentUser);
  // }

  // logout() {
  //   googleSignIn.signOut();
  // }

  // onPageChanged(int pageIndex) {
  //   setState(() {
  //     this.pageIndex = pageIndex;
  //   });
  // }

  // onTap(int pageIndex) {
  //   pageController.animateToPage(
  //     pageIndex,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  // Widget buildAuthScreen() {
  //   return Scaffold(
  //       key: _globalKey,
  //       body: PageView(
  //         children: <Widget>[
  //           Timeline(currentUser: currentUser),
  //           ActivityFeed(),
  //           Upload(currentUser: currentUser),
  //           Search(),
  //           Profile(profileId: currentUser?.id),
  //         ],
  //         controller: pageController,
  //         onPageChanged: onPageChanged,
  //         physics: NeverScrollableScrollPhysics(),
  //       ),
  //       bottomNavigationBar: CupertinoTabBar(
  //         currentIndex: pageIndex,
  //         onTap: onTap,
  //         activeColor: Theme.of(context).primaryColor,
  //         items: [
  //           BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
  //           BottomNavigationBarItem(icon: Icon(Icons.notifications)),
  //           BottomNavigationBarItem(
  //               icon: Icon(
  //             Icons.photo_camera,
  //             size: 35.0,
  //           )),
  //           BottomNavigationBarItem(icon: Icon(Icons.search)),
  //           BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
  //         ],
  //       ));
  // }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorLight
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'FameGame',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Theme.of(context).accentColor,
              ),
            ),
            Image(
              image: AssetImage('assets/images/splash_image.png'),
              fit: BoxFit.cover,
            ),
            GestureDetector(
              onTap: login, //login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUnAuthScreen();
    // return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
