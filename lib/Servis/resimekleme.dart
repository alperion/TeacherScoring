



import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';



resimsecici(ImageSource source)async{
   final ImagePicker _imagepicker=ImagePicker();
   XFile? _file=await _imagepicker.pickImage(source: source);

   if(_file!=null){
    print("secilen resim kullanıldı");
     return await _file.readAsBytes();
   }
   else{
    ByteData byteData = await rootBundle.load("resimler/personimage.jpg");
    Uint8List bytes = byteData.buffer.asUint8List();
    print("varsayılan resim kullanıldı");
    return bytes;

   }
}