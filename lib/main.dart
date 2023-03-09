import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:painter_bug_poc/image_painter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? currentImage;

  void _onTap() async {
    XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final generatedImage =
          await ImageCropPainter().generate(File(imageFile.path));
      final result = await _getTempImageFile;
      result.writeAsBytes(Uint8List.view(generatedImage.buffer));
      setState(() => currentImage = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (currentImage != null)
            SizedBox(
              height: 200,
              width: 200,
              child: Image.file(
                currentImage!,
                fit: BoxFit.contain,
              ),
            ),
          Center(
              child: ElevatedButton(
                  onPressed: _onTap, child: const Text('Open Gallery'))),
        ],
      ),
    );
  }
}

Future<File> get _getTempImageFile async {
  Directory tempDirectory = await getTemporaryDirectory();
  String imagePath =
      path.joinAll([tempDirectory.path, 'image ${Random().nextInt(100)}.png']);
  return File(imagePath);
}
