


import 'package:ensonproje/Servis/KayitMetotlari.dart';
import 'package:ensonproje/Servis/resimekleme.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({Key? key}) : super(key: key);

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController numara=TextEditingController();
  int durum = 0;
  Uint8List? nullableimage;



  void resimsec()async{
      Uint8List im= await resimsecici(ImageSource.gallery);
      setState(() {
        nullableimage=im; 
      });
  }
   
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red,Colors.yellow],begin: Alignment.topCenter,end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Stack(
                children: [
                  nullableimage!=null?CircleAvatar( radius: 64,backgroundImage:
                   MemoryImage(nullableimage!),):
                  CircleAvatar( radius: 64,backgroundImage:
                   NetworkImage("https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg"),),
                   Positioned(bottom: -10,left: 80,child: IconButton(onPressed: resimsec, icon:Icon(Icons.add_a_photo)))
                
                
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
              
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  cursorColor: email.text.isEmpty?Colors.red:Colors.green,
                  controller: email,
                  decoration: InputDecoration(
                      hintText: "email", border: InputBorder.none,focusColor: email.text.isEmpty?Colors.red:Colors.green),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      hintText: "password", border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      hintText: "username", border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: bio,
                  decoration:
                      InputDecoration(hintText: "bio", border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: numara,
                  decoration:
                      InputDecoration(hintText: "numara", border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Center(
                  child: CupertinoPicker(
                      itemExtent: 50,
                      
                      magnification: 1.5,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          durum = value;
                        });
                        print(durum);
                      },
                      children: [Text("Öğrenci"), Text("Öğretmen")]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    onPressed: ()async{ 
                      if(email.text.isEmpty && password.text.isEmpty){
                        showDialog(context: context, builder:(context,){
                          return AlertDialog(content: Text("Lütfen email ve şifre alanlarını doldurunuz"),);
                        });
                      }
                      else{
                        if(nullableimage==null){
                         ByteData resimverisi=await rootBundle.load("resimler/personimage.jpg");
                          Uint8List bytes = resimverisi.buffer.asUint8List();
                          nullableimage=bytes;
                        }
                        KayitIslemleri().kayitOl(email.text,
                        password.text, username.text, bio.text, durum,nullableimage!,numara.text).then((value) {
                          return showDialog(context: context, builder:(context,){
                          return AlertDialog(content: Text("kaydınız gerçekleştirildi"),);
                        });
                        });
                      }
                    },
                    child: Text("Kayıt Ol")),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
