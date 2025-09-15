import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_tuba/core/widgets/widgets.dart';

import 'base_game.dart';

class PhotoGame extends BaseGame {
  const PhotoGame({
    super.key,
    required super.gameMeta,
    required super.onGameCompleted,
    required super.onScoreUpdate,
  });

  @override
  State<PhotoGame> createState() => _PhotoGameState();
}

class _PhotoGameState extends BaseGameState<PhotoGame> {
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage;
  late String _task;
  late String _description;
  bool _photoTaken = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final config = widget.gameMeta.config;
    _task = config['task'] ?? 'Сделайте снимок';
    _description = config['description'] ?? 'Сфотографируйте указанный объект';
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _photoTaken = true;
        });

        // Award points for taking a photo
        updateScore(100.0);
      }
    } catch (e) {
      _showErrorDialog('Ошибка при съемке: $e');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _photoTaken = true;
        });

        // Award slightly fewer points for gallery selection
        updateScore(75.0);
      }
    } catch (e) {
      _showErrorDialog('Ошибка при выборе фото: $e');
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _photoTaken = false;
    });
    updateScore(0.0);
  }

  void _submitPhoto() {
    if (_capturedImage != null) {
      // Here you would typically save the photo or send it to a server
      completeGame();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(60, 90, 50, 1),
        title: const Text(
          'Ошибка',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildGameContent() {
    return Column(
      children: [
        buildGameHeader('Сделай снимок'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Task Description
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _task,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Photo Display or Camera Options
                if (!_photoTaken) ...[
                  _buildCameraOptions(),
                ] else ...[
                  _buildPhotoPreview(),
                ],

                const Spacer(),

                // Action Buttons
                if (!_photoTaken) ...[
                  CustomButton(
                    text: 'Открыть камеру',
                    onPressed: _takePicture,
                    icon: Icon(Icons.camera_alt),
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    text: 'Выбрать из галереи',
                    onPressed: _selectFromGallery,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    textColor: Colors.white,
                    icon: Icon(Icons.photo_library),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Переснять',
                          onPressed: _retakePhoto,
                          backgroundColor: Colors.red.withOpacity(0.3),
                          textColor: Colors.white,
                          icon: Icon(Icons.refresh),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomButton(
                          text: 'Готово',
                          onPressed: _submitPhoto,
                          icon: Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraOptions() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 2.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              'Нажмите на кнопку ниже,\nчтобы сделать снимок',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color.fromRGBO(116, 136, 21, 1),
            width: 3.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Image.file(
                File(_capturedImage!.path),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}














