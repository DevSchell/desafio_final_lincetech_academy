import 'package:image_picker/image_picker.dart';

/// A use case for handling image picking operations.
///
/// This class provides methods to select images from the device's gallery
/// or capture a new one using the camera, abstracting the [ImagePicker]
/// library.
class ImagePickerUseCase {
  final ImagePicker _imgPicker = ImagePicker();

  /// Instigates the user to select an image from the device's photo gallery.
  ///
  /// Returns an [XFile] object representing the selected image,
  /// or [null] if the user cancels the selection.
  Future<XFile?> pickFromGallery() async {
    final selectedImage = await _imgPicker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      return selectedImage;
    }
    return null;
  }

  /// Prompts the user to capture a new image using the device's camera.
  ///
  /// Returns an [XFile] object representing the captured image,
  /// or [null] if the user cancels the operation.
  Future<XFile?> pickFromCamera() async {
    final selectedImage = await _imgPicker.pickImage(
      source: ImageSource.camera,
    );
    if (selectedImage != null) {
      return selectedImage;
    }
    return null;
  }
}
