import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'dart:io';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late CameraController controller;
  late List<CameraDescription> _cameras;
  XFile? imageFile;
  List<XFile> imagesList = [];

  int currentPageIndex = 0;
  String title = 'Camera preview';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(initCamera());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if(cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if(state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if(state == AppLifecycleState.resumed) {
      _onNewCameraSelected(cameraController.description);
    }
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max  : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    await controller?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  void changeSelected(int index){
    setState(() {
      currentPageIndex = index;
      title = (index == 0) ? 'Camera preview' : 'Images gallery';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => changeSelected(index),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.camera),
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
        ],
      ),
      body: <Widget>[
        Container(
           width: double.infinity,
          child: CameraPreview(controller!),
        ),
        Container(
          height: 250,
          child: (imagesList.isEmpty)
              ? Center(child: Text('Еще не картинок...'),)
              : ListView.builder(
                  itemCount: imagesList.length,
                  itemBuilder: (context, index) {
                    final image = imagesList[index];
                    return Container(
                      child: Image.asset(image.path),
                    );
                  },
                )
        ),
      ][currentPageIndex],
      floatingActionButton: (currentPageIndex == 0) ? FloatingActionButton(
        onPressed: () async {
          try{
            imageFile = await controller.takePicture();
            print('img');
            print(imageFile?.path);
            setState(() {
              imagesList.add(imageFile!);
            });
            print('oo');
            print(imagesList);
          }catch(e){
            print(e);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.camera),
      )
      : Text(''),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
