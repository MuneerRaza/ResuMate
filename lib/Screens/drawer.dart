import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Screens/Login.dart';
import 'package:resumate/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawerHeader extends StatefulWidget {
  final String name;
  const SideDrawerHeader({required this.name, super.key});

  @override
  State<SideDrawerHeader> createState() => _SideDrawerHeaderState();
}

class _SideDrawerHeaderState extends State<SideDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    double drawerHeight = MediaQuery.of(context).size.height;
    double drawerWidth = MediaQuery.of(context).size.width * 0.75;
    return Container(
        color: Colors.blueGrey,
        width: double.infinity,
        height: drawerHeight/3.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: drawerWidth*0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Images/profile_pic.png')
                ),
                shape: BoxShape.circle,
              ),
            ),
            Text(widget.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: drawerWidth*0.06, fontWeight: FontWeight.w500),),
          ],
        ),
      );
  }
}


class SideDrawerList extends StatefulWidget {
  const SideDrawerList({super.key});

  @override
  State<SideDrawerList> createState() => _SideDrawerListState();
}

class _SideDrawerListState extends State<SideDrawerList> {
  @override
  Widget build(BuildContext context) {
    return drawerList(context);
  }
}



Widget drawerList(context) {
  return Container(
    padding: const EdgeInsets.only(top: 15),
    child: Column(
      children: [
        menuItems(Icons.person, "Profile", context),
        menuItems(Icons.group, "About us", context),
        Divider(color: Colors.blueGrey[700],),
        menuItems(Icons.logout, "Logout", context),
      ],
    ),
  );
}


Widget menuItems(icon, text, context){
  return Material(
    child: InkWell(
      onTap: (){
        if(text == 'Profile'){
          onClickProfile(context);
        }
        else if(text == 'About us'){
          onClickAboutUs(context);
        }
        else {
          onClickLogout(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(child: Icon(icon, size: 20, color: Colors.blueGrey,)),
            Expanded(flex:3, child: Text(text))
          ],
        ),
      ),
    ),
  );
}

onClickProfile(context){
//   TODO: profile page
}
onClickAboutUs(context){
  // TODO: about us page
}
onClickLogout(context) async{
  var sharedpref = await SharedPreferences.getInstance();
  sharedpref.setBool(MyApp.LOGINKEY, false);
  sharedpref.setString(MyApp.EMAILKEY, '');
  Navigator.of(context).pushReplacement(_createRoute(const Login()));
}
Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
