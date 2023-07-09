import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ensonproje/Servis/dosyametotlari.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:firebase_core/firebase_core.dart';


class KayitIslemleri{

    FirebaseAuth _authinstance=FirebaseAuth.instance;
    FirebaseFirestore _firestoreinstance=FirebaseFirestore.instance;

    Future<UserCredential> kayitOl(String email,String password,String username,String bio,int durum,Uint8List profilresim,String numara)async{

          UserCredential user=await _authinstance.createUserWithEmailAndPassword(email: email, password: password); 
           String urls="";
           
           if(profilresim==null){
             ByteData byteData = await rootBundle.load("resimler/personimage.jpg");
             Uint8List bytes = byteData.buffer.asUint8List();
             print("varsayılan resim kullanıldı");
             profilresim= bytes;
              
           }
           urls=await  StorageMethods().resimyuklestorage("profilePics",profilresim, false);
           
        

           await _firestoreinstance.collection("Kullanicilar").doc(user.user!.uid).set({
             "email" : email,
             "password" : password,
             "username" : username,
             "bio" : bio,
             "durum" : durum,
             "id":user.user!.uid,
             "begeni":0  ,
             "yorumlar":{},
             "begenenlistesi":[],
             "photourl":urls,
             "belgeurl":[],
             "numara":numara
           });

           return user;

    }



    Future<UserCredential>girisyap(String email,String password)async{
        
       UserCredential user= await _authinstance.signInWithEmailAndPassword(email: email, password: password);

       var response=await _firestoreinstance.collection("Kullanicilar").doc(user.user!.uid).get();
       Map<String, dynamic>? map =response.data(); 
       print(map?["id"]);  
       print(map?["durum"]);

         return user;
    } 

    cikisYap()async{
      return  _authinstance.signOut();
    }


}
