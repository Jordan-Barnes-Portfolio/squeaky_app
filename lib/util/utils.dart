import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if (image != null) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      compressQuality: 80,
      maxHeight: 300,
      maxWidth: 300,
      compressFormat: ImageCompressFormat.jpg,
    );
    if (croppedFile != null) {
      return croppedFile.path;
    }
    return image.path;
  } else {
    print('No image selected.');
    return null;
  }
}

getUserFromFirestore(String email) async {
  final users = FirebaseFirestore.instance.collection('users');
  var doc = await users.doc(email).get();
  return doc.data();
}
