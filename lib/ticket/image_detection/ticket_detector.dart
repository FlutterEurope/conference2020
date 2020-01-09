import 'package:conferenceapp/common/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';

import 'scanner_utils.dart';
import 'detector_painters.dart';

typedef void TextDetected(String number);
typedef bool CheckCondition(String word);

class TicketDetector extends StatefulWidget {
  const TicketDetector({
    Key key,
    this.onDetected,
    this.condition,
    this.detectorHeight,
    this.overlay,
  }) : super(key: key);

  final TextDetected onDetected;
  final CheckCondition condition;
  final double detectorHeight;
  final Widget overlay;

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
  Size _screenSize;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.medium
          : ResolutionPreset.medium,
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
          if (_currentDetector == null || results == null) return;
          if (results is VisionText) {
            final handled = handleScannerResults(results);
            if (handled) return;
            setState(() {
              _scanResults = results;
            });
          }
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Widget _buildImage() {
    return WillPopScope(
      onWillPop: () async {
        await _camera.dispose().then((_) {
          _recognizer.close();
        });
        return true;
      },
      child: Container(
        child: _camera == null
            ? const Center(
                child: Text(
                  'Initializing Camera...',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              )
            : InitializedCamera(
                camera: _camera,
                overlay: widget.overlay,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
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

  bool handleScannerResults(VisionText results) {
    try {
      final _filteredScanRresults =
          results.blocks.where((b) => textWithinBounds(b)).toList();

      if (_filteredScanRresults != null && _filteredScanRresults.length > 0) {
        for (var text in _filteredScanRresults) {
          for (var line in text.lines) {
            for (var word in line.text.split(' ')) {
              final correct = widget.condition(word);

              if (correct) {
                final result = word.toUpperCase();
                logger.info(result);
                setState(() {
                  widget.onDetected(result);
                });
                return true;
              }
            }
          }
        }
      }
      logger.info('No results');
    } catch (e) {
      logger.errorException(e);
    }
    return false;
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
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

  bool textWithinBounds(TextBlock b) {
    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );
    final double scaleY = imageSize.height / _screenSize.height;
    final double imageHalfY = imageSize.height / 2.0;
    for (var l in b.lines) {
      for (var e in l.elements) {
        final result =
            e.boundingBox.top > (imageHalfY - widget.detectorHeight / 2) &&
                e.boundingBox.bottom < (imageHalfY + widget.detectorHeight / 2);

        if (result == true) {
          print('TRUE ${e.text}');
          return true;
        }
      }
    }

    return false;
  }
}

class InitializedCamera extends StatelessWidget {
  const InitializedCamera({
    Key key,
    @required CameraController camera,
    @required Widget overlay,
  })  : _camera = camera,
        _overlay = overlay,
        super(key: key);

  final CameraController _camera;
  final Widget _overlay;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.scale(
        scale: 1 / _camera.value.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: _camera.value.aspectRatio,
            child: Stack(
              children: <Widget>[
                CameraPreview(_camera),
                Transform.scale(
                  scale: 1 * _camera.value.aspectRatio,
                  child: _overlay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
