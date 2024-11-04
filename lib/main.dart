import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pubdev/widget/filter_selector.dart';
import 'package:flutter_plugin_pubdev/widget/takepicture_widget.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi kamera yang tersedia
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const MyApp({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: CameraWithFilterScreen(camera: firstCamera),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraWithFilterScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraWithFilterScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraWithFilterScreenState createState() => _CameraWithFilterScreenState();
}

class _CameraWithFilterScreenState extends State<CameraWithFilterScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Color selectedFilter = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Overlay Filter
          if (selectedFilter != Colors.transparent)
            Container(
              color: selectedFilter.withOpacity(0.3), // Set opacity for the filter effect
            ),
          // Filter Selector Widget at the Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FilterSelector(
              filters: [
                Colors.transparent,
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
              ],
              onFilterChanged: (Color color) {
                setState(() {
                  selectedFilter = color;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}