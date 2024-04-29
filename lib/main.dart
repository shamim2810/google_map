import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;

  @override
  void initState() {
    super.initState();
    _onScreenStart();
    _listenCurrentLocation();
  }

  Future<void> _onScreenStart() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print(isEnabled);

    print(await Geolocator.getLastKnownPosition());
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
      print(position);
    } else {
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        _onScreenStart();
      } else {
        print('Permission denied');
      }
    }
  }

  void _listenCurrentLocation(){
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
        timeLimit: Duration(seconds: 3),
      )
    ).listen((p) {
      print(p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text(
            'current location${position?.latitude}, ${position?.longitude}'),
      ),
    );
  }
}
