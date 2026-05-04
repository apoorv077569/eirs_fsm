import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InAppCameraScreen extends StatefulWidget {
  const InAppCameraScreen({super.key});

  @override
  State<InAppCameraScreen> createState() => _InAppCameraScreenState();
}

class _InAppCameraScreenState extends State<InAppCameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isTaking = false;
  bool _isFrontCamera = false;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera({bool useFront = false}) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        Get.back();
        return;
      }

      // ✅ Front ya rear select karo
      final camera = useFront
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      // ✅ Purana controller dispose karo
      await _controller?.dispose();

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isFrontCamera = useFront;
        });
      }
    } catch (e) {
      debugPrint("❌ Camera init error: $e");
      Get.back();
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_isInitialized || _isTaking) return;
    setState(() => _isTaking = true);

    try {
      final XFile photo = await _controller!.takePicture();
      // ✅ File wapas bhejo controller ko
      Get.back(result: File(photo.path));
    } catch (e) {
      debugPrint("❌ Capture error: $e");
      Get.snackbar("Error", "Photo capture failed",
          backgroundColor: Colors.red, colorText: Colors.white);
      setState(() => _isTaking = false);
    }
  }

  void _flipCamera() {
    _initCamera(useFront: !_isFrontCamera);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized
          ? Stack(
              children: [
                // ── Full Screen Preview ──
                SizedBox.expand(
                  child: CameraPreview(_controller!),
                ),

                // ── Top Bar ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 28),
                          onPressed: () => Get.back(),
                        ),
                        const Text(
                          "Take Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Flip Camera
                        IconButton(
                          icon: const Icon(Icons.flip_camera_ios,
                              color: Colors.white, size: 28),
                          onPressed: _flipCamera,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Bottom Controls ──
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 24,
                      top: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _capturePhoto,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: _isTaking ? 64 : 72,
                          height: _isTaking ? 64 : 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: _isTaking
                                ? Colors.grey
                                : Colors.white.withOpacity(0.9),
                          ),
                          child: _isTaking
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(
                                      color: Colors.black, strokeWidth: 2),
                                )
                              : const Icon(Icons.camera_alt,
                                  color: Colors.black, size: 32),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
    );
  }
}