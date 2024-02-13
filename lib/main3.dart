import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    if(defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  GoogleMapController? _controller;
  double sliderValue = 1.0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(43.4567675, 77.0226105),
    zoom: 14.4746
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _controller = controller;
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _controller?.animateCamera(CameraUpdate.zoomIn());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          _controller?.animateCamera(CameraUpdate.zoomOut());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 100,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0)
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _controller?.animateCamera(CameraUpdate.scrollBy(-20.0, 0.0));
                },
              ),
            )
          ),
          Positioned(
            bottom: 100,
            left: 200,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0)
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  _controller?.animateCamera(CameraUpdate.scrollBy(20.0, 0.0));
                },
              ),
            )
          ),
          Positioned(
            bottom: 130,
            left: 150,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0)
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_upward),
                onPressed: () {
                  _controller?.animateCamera(CameraUpdate.scrollBy(0.0, -20.0));
                },
              ),
            )
          ),
          Positioned(
              bottom: 70,
              left: 150,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.0)
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    _controller?.animateCamera(CameraUpdate.scrollBy(0.0, 20.0));
                  },
                ),
              )
          ),
          Positioned(
              bottom: 60,
              left: 280,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.0)
                ),
                child: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    _controller?.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
                  },
                ),
              )
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  width: 200.0,
                  height: 40.0,
                  child: Slider(
                    max: 50.0,
                    min: 1.0,
                    value: sliderValue,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                      _controller?.animateCamera(CameraUpdate.zoomTo(value));
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}