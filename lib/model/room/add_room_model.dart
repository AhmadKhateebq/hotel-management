import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomModel{
  double rating = 3.5;
  XFile? image;
  RxBool seaView = false.obs;
  List<XFile>? slideShow;

  pickImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  pickSlideShow() async {
    slideShow = await ImagePicker().pickMultiImage();
  }

  void setSeaView() {
    seaView.value = !seaView.value;
  }

  void setRating(double value) {
    rating = value;
  }
}