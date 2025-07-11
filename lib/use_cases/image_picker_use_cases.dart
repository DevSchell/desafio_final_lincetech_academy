import 'package:image_picker/image_picker.dart';

class ImagePickerUseCase {
  final ImagePicker _imgPicker = ImagePicker();

  Future<XFile?> pickFromGallery() async {
    final selectedImage = await _imgPicker.pickImage(source: ImageSource.gallery);
    if(selectedImage != null) {
    return selectedImage;
    }
    return null;
  }

  Future<XFile?> pickFromCamera() async {
    final selectedImage = await _imgPicker.pickImage(source: ImageSource.camera);
    if(selectedImage != null) {
    return selectedImage;
    }
    return null;
  }

}