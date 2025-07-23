import 'package:desafio_final_lincetech_academy/use_cases/image_picker_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomSheetState with ChangeNotifier {
  XFile? _selectedImage;

  XFile? get selectedImage => _selectedImage;

  Future<void> pickFromGallery() async {
    final picker = ImagePickerUseCase();
    XFile? returnedImage = await picker.pickFromGallery();
    if(returnedImage != null) {
      _selectedImage = returnedImage;
    }
    notifyListeners();
  }

  Future<void> pickFromCamera() async {
    final picker = ImagePickerUseCase();
    XFile? returnedImage = await picker.pickFromCamera();
    if(returnedImage != null) {
      _selectedImage = returnedImage;
    }
    notifyListeners();
  }
}