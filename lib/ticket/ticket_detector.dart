import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';

import 'scanner_utils.dart';
import 'detector_painters.dart';

class TicketDetector extends StatefulWidget {
  const TicketDetector({
    Key key,
  }) : super(key: key);

  @override
  _TicketDetectorState createState() => _TicketDetectorState();
}

class _TicketDetectorState extends State<TicketDetector> {
  final _recognizer = FirebaseVision.instance.textRecognizer();
  VisionText _scanResults;
  CameraController _camera;
  Detector _currentDetector = Detector.text;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description = await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS ? ResolutionPreset.low : ResolutionPreset.medium,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _recognizer.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (_currentDetector == null) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null || _camera == null || !_camera.value.isInitialized) {
      return noResultsText;
    }

    if (_scanResults.text.contains('OT')) {
      final _filteredScanRresults = _scanResults.blocks.where((b) => b.text.contains('OT')).toList();
      if (_filteredScanRresults.length == 1) {
        try {
          final result = _filteredScanRresults.firstWhere((n) => n.text.contains('OT') && n.text.length == 9);
          if (result != null) {
            print(result.text);
            setState(() {
              _isDetecting = false;
            });
          }
        } catch (e) {
          print(e);
        }
      }
    } else {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    painter = TextDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            )
          : AspectRatio(
              aspectRatio: _camera.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(_camera),
                  _buildResults(),
                ],
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _recognizer.close();
    });

    _currentDetector = null;
    super.dispose();
  }
}
