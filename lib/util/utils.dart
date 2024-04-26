
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null){
        return await image.readAsBytes();
    } else {
        print('No image selected.');
        return null;
    }
}
