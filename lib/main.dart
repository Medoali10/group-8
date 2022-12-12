import 'package:app1/screens/graphs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'firebase_options.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          'Home': (context) => MyHomePage(),
          'Graphs': (context) => Graphs(),
        },
      debugShowCheckedModeBanner: false,
      title: 'Sandy',
      home: SplashScreenView(
        navigateRoute: MyHomePage(),
        duration: 3000,
        imageSize: 130,
        imageSrc: "assets/icons8-flutter-240.png",
        text: "Sandy",
        textType: TextType.TyperAnimatedText,
        textStyle: TextStyle(
          fontSize: 30.0,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  num moisture = 0;
  num temperature = 0;
  num co2 = 0;
  num drops = 0;


  final databaseRef = FirebaseDatabase.instance.ref('test/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseRef.onValue.listen((event) {
      if(event.snapshot.exists){
        Map<String, dynamic> _post = Map<String, dynamic>.from(event.snapshot.value as Map);
        co2 = _post['co2'];
        moisture = _post["moisure"];
        temperature = _post["temp"];
        drops = _post["rain"];
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () => {Navigator.pushReplacementNamed(context, 'Home')},
              ),
              ListTile(
                leading: Icon(Icons.show_chart),
                title: Text('Graphs'),
                onTap: () => {Navigator.pushReplacementNamed(context, 'Graphs')},
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          centerTitle: true,
          title: Text("Sandy"),
          backgroundColor: Colors.green.withOpacity(0.8),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.green.withOpacity(0.8),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 26),
                        child: Text(
                          "Data",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 30),
                        ),
                      ),
                      Lottie.asset("assets/95297-computer.json"),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 150,
                              height: 120,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 20,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'CO₂',
                                        style: TextStyle(
                                            color: Colors.black,
                                           ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.co2,
                                        color: Colors.green.withOpacity(0.8),
                                        size: 40,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "$co2%",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 150,
                              height: 120,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 20,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Temperature',
                                        style: TextStyle(
                                            color: Colors.black,),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Lottie.asset("assets/62290-kelvin-temperature-scale-conversion.json" , height: 40)
                                    ),
                                    Container(
                                      child: Text(
                                        "$temperature°C",
                                        style: TextStyle(
                                            color: Colors.black,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 150,
                              height: 120,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 20,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Soil moisture',
                                        style: TextStyle(
                                            color: Colors.black,),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: ImageIcon(
                                        AssetImage("assets/icons8-soil-80.png"),
                                        color: Colors.green.withOpacity(0.8),
                                        size: 40,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "$moisture%",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 150,
                            height: 120,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 20,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Rain drops',
                                      style: TextStyle(
                                          color: Colors.black,),
                                    ),
                                  ),
                                  Container(
                                    child: Lottie.asset("assets/36240-rain-icon.json" , height: 60)
                                  ),
                                  Container(
                                    child: Text(
                                      "$drops%",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
