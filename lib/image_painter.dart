import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageCropPainter {
  Future<ByteData> generate(File inputImageFile) async {
    ui.Image inputImage = await _loadImage(await inputImageFile.readAsBytes());
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromLTWH(
            0, 0, inputImage.width.toDouble(), inputImage.height.toDouble()));
    canvas.save();

    canvas.drawColor(Colors.white, BlendMode.color);

    paintImage(
      rect: Rect.fromLTWH(
          0, 0, inputImage.width.toDouble(), inputImage.height.toDouble()),
      canvas: canvas,
      image: inputImage,
      fit: BoxFit.contain,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(inputImage.width, inputImage.height);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!;
  }

  Future<ui.Image> _loadImage(Uint8List imageBytes) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }
}
