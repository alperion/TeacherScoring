
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class StorageMethods{
  final FirebaseStorage storage=FirebaseStorage.instance;
  final  FirebaseAuth   auth=FirebaseAuth.instance;   
  final FirebaseFirestore cloudfire=FirebaseFirestore.instance;

  Future<String> resimyuklestorage(String childname,Uint8List file,bool isPost)async{
            
     Reference ref= storage.ref().child(childname).child(auth.currentUser!.uid);
     UploadTask uploadtask=ref.putData(file);
     TaskSnapshot snapshot=await uploadtask;
     String downloadurl=await snapshot.ref.getDownloadURL();
       
     return downloadurl;  
  
  }


  Future<String> dosyabirresim(String childname,String childnameiki,Uint8List? file,String id)async{
     if(file!=null){      
     Reference ref= storage.ref().child(childname).child(auth.currentUser!.uid).child("photos").child(childnameiki);
     UploadTask uploadtask=ref.putData(file);
     TaskSnapshot snapshot=await uploadtask;
     String downloadurl=await snapshot.ref.getDownloadURL();
       
     var aslink;
    var yanlnkler;
     yanlnkler=await cloudfire.collection("Kullanicilar").doc(id).get().then((value)async{
                    return value["belgeurl"];
     });  
     aslink=yanlnkler;
     aslink.add(downloadurl);
     cloudfire.collection("Kullanicilar").doc(id).update({"belgeurl":aslink});

     return downloadurl;  
     }
     else{
      return "Lütfen Resim seçiniz";
     }

  }

  Future<String> dosyaikipdf(String childname,String childnameiki,Uint8List file,String id)async{
     if(file!=null){      
     Reference ref= storage.ref().child(childname).child(auth.currentUser!.uid).child("photos").child(childnameiki);
     UploadTask uploadtask=ref.putData(file);
     TaskSnapshot snapshot=await uploadtask;
     String downloadurl=await snapshot.ref.getDownloadURL();
     var aslink;
     var yanlnkler;
     yanlnkler=await cloudfire.collection("Kullanicilar").doc(id).get().then((value)async{
                    return value["belgeurl"];
     });  
     aslink=yanlnkler;
     aslink.add(downloadurl);
     cloudfire.collection("Kullanicilar").doc(id).update({"belgeurl":aslink});
     return downloadurl;  
     }
     else{
      return "Lütfen Resim seçiniz";
     }

  }



  





}