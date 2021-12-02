import 'package:flutter/material.dart';
import 'package:nss_tracker/model/user_model.dart';
import 'package:nss_tracker/services/firebase/firebase.dart';
import 'package:nss_tracker/views/home_view.dart';
import 'package:nss_tracker/views/login_view.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);
  // final List<Widget> views = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // pinned: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              floating: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.blue,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.whatshot,
                        color: Colors.red,
                      ),
                      Text(
                        "12",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await firebaseAuthServices.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginView()),
                          (route) => false);
                    },
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ];
        },
        body: HomeView(userModel: Provider.of<UserModel>(context)),
      ),
      // bottomNavigationBar: ClipRRect(
      //   borderRadius: BorderRadius.circular(20.0),
      //   child: BottomNavigationBar(

      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     elevation: 20.0,
      //     items: [
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.settings), label: "Placeholder"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.settings), label: "Placeholder"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.settings), label: "Placeholder"),
      //       // BottomNavigationBarItem(
      //       // icon: Icon(Icons.settings), label: "Placeholder"),
      // ],
      // ),
      // ),
    );
  }
}
