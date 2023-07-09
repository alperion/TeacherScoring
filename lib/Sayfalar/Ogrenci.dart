import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensonproje/Sayfalar/OgretmenListele.dart';
import 'package:ensonproje/Sayfalar/ogrencidersler.dart';
import 'package:ensonproje/Sayfalar/ogretmenlervedersler.dart';
import 'package:ensonproje/Sayfalar/siralamalar.dart';
import 'package:ensonproje/Servis/KayitMetotlari.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ensonproje/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bilgilerimsayfasi.dart';
import 'ogretmenbilgileri.dart';
class Ogrenci extends StatefulWidget {
   UserCredential? credential ;
   Ogrenci({Key? key,this.credential}) : super(key: key);

  @override
  State<Ogrenci> createState() => _OgrenciState();
}

class _OgrenciState extends State<Ogrenci> {
  FirebaseFirestore firestoreornek=FirebaseFirestore.instance;
  String photourl=""; 
  Future<String> getirici()async{
    String photourls=await firestoreornek.collection("Kullanicilar").doc(widget.credential!.user?.uid).get().then((value){
        
        

        setState(() {
          photourl=value["photourl"];
        });
        return photourl;
    });
    return "";
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getirici();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Öğrenci"),),
      drawer: Drawer(backgroundColor: Colors.blueGrey,child:ListView(children: [
        DrawerHeader(child:SingleChildScrollView(child: Column(
          children: [
            CircleAvatar(backgroundImage:NetworkImage(photourl),radius: 80,),
            
          ],
        ))),
        ListTile(leading: FaIcon(FontAwesomeIcons.ruler),title:Text("Öğretmenler "),onTap:(){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>OgretmenListele(credential: widget.credential,)));
        },),
        ListTile(leading: FaIcon(FontAwesomeIcons.bookAtlas),title: Text("Yüklenen Dersler"),onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>Dersler(credential: widget.credential,)));
        },),
        ListTile(leading: FaIcon(FontAwesomeIcons.sort),title: Text("Sıralamalar"),onTap:()async{
             Navigator.push(context, MaterialPageRoute(builder:(context)=>SiralamaSayfasi()));
          },),
        ListTile(leading: FaIcon(FontAwesomeIcons.outdent),title: Text("Çıkış Yap"),onTap:()async{await KayitIslemleri().cikisYap();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>GirisSayfasi()), (route) => false);
          },),
          
      ],)),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              width: 100,
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient: LinearGradient(colors:[Colors.tealAccent,Colors.grey] )),
              child: GestureDetector(
                child: Center(child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [ Icon(Icons.data_saver_off_rounded,size: 50,),Text("Bilgilerim")],),),
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder:(context)=>BilgilerimSayfasi(credentials: widget.credential,)));
                },
              ),
            ),
           const SizedBox(height: 10,),
            Container(
              
              margin: EdgeInsets.all(5),
              width: 100,
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient: LinearGradient(colors: [Colors.red,Colors.black87])),
              child: GestureDetector(
                child: Center(child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [FaIcon(FontAwesomeIcons.bookSkull,size: 60,),Text("Öğretmenler ve Bilgileri",style: TextStyle(color: Colors.white),)],),),
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder:(context)=>OgretmenBilgileri()));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: 100,
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey),
              child: GestureDetector(
                child: Center(child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [FaIcon(FontAwesomeIcons.searchengin,size: 60,color: Colors.yellow,),Text("Öğretmenler ve Dersler")],),),
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder:(context)=>OgretmenlerveDersler()));
                },
              ),
            )
          ],
        ),
      ),
     );
  }
}
