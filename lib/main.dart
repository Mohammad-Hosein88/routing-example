// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routemaster/routemaster.dart';
import 'package:universal_html/html.dart' as html;

late final GetDelegate delegate;

void main() {
  delegate = GetDelegate(
    backButtonPopMode: PopMode.History
  );
  html.window.addEventListener("popstate", (event) {
    print("event :${(event.path.first as html.Window).location.pathname}");
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    print("history length: ${html.window.history.length}");
    if(html.window.history.length > 1){
      // html.window.location.replace("/");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      getPages: [
        GetPage(
          name: '/home/:id',
          page: () {
            print(Get.parameters["id"]);
            return const HomePage();
          },
        ),
      ],
      routerDelegate: delegate,
      routeInformationParser: GetInformationParser(initialRoute: "/home/1"),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final bool canPop = Get.nestedKey(2)!.currentState!.canPop();
        print("can pop: $canPop");
        if(canPop){
          Get.nestedKey(2)!.currentState!.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text("Home"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                final bool canPop = Get.nestedKey(2)!.currentState!.canPop();
                print("can pop: $canPop");
                if(canPop){
                  Get.nestedKey(2)!.currentState!.pop();
                }
              },
            )
        ),
        body: Navigator(
          key: Get.nestedKey(2),
          onPopPage: (val1, val2) {
            final bool canPop = Get.nestedKey(2)!.currentState!.canPop();
            return canPop;
          },
          onGenerateRoute: (settings){
            print(settings.name);
            if(settings.name == "feed"){
              return GetPageRoute(
                page: () => FeedPage(title: "Feed"),
              );
            } else {
              return GetPageRoute(
                page: () => FeedPage(title: "Settings"),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            if(index == 0){
              Get.nestedKey(2)!.currentState!.pushNamed("feed");
              html.window.location.href = "#/feed";
            } else {
              Get.nestedKey(2)!.currentState!.pushNamed("setting");
              html.window.location.href = "#/setting";
            }
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Feed',
              icon: Icon(CupertinoIcons.list_bullet),
            ),
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(CupertinoIcons.search,color: Colors.red,),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            delegate.toNamed('/home/1');
          },
          child: Text("$title Page")
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       label: 'Feed',
      //       icon: Icon(CupertinoIcons.list_bullet,color: Colors.red),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: GestureDetector(
      //         onTap: (){
      //           delegate.toNamed('/home/1');
      //         },
      //         child: Icon(
      //           CupertinoIcons.search,
      //         )
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Profile page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Settings page')));
  }
}