import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OgrenciListele extends StatefulWidget {
  const OgrenciListele({Key? key}) : super(key: key);

  @override
  State<OgrenciListele> createState() => _OgrenciListeleState();
}

class _OgrenciListeleState extends State<OgrenciListele> {
  FirebaseFirestore firebaseornek1=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Öğrenciler"),),
      body: StreamBuilder(stream: firebaseornek1.collection("Kullanicilar").snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
             if (snapshot.hasError) {
              print("hata var");
            }
            if (snapshot.hasError && !snapshot.hasData) {
              print("hata var ve veri yok kardes");
            }
            if (!snapshot.hasData) {
              print("veri yok");
              return CircularProgressIndicator();
            }
            if (snapshot.hasData){
              print("veri var");
            }

            List liste3 = snapshot.data!.docs.toList();
            List liste4= [];
            
            liste3.forEach((element) { 
              if(element["durum"]==0){
                liste4.add(element);
              }
            });


            return ListView.builder(itemCount:liste4.length,itemBuilder: (context,index){

              return ListTile(title: Text("${liste4[index]["username"]}"),leading: CircleAvatar(backgroundImage:NetworkImage("${liste4[index]["photourl"]}"),),subtitle: Text("${liste4[index]["email"]}"),);
            });

      },),
     );
  }
}