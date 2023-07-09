import 'package:ensonproje/Sayfalar/ogrenciderslistesi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dersler extends StatefulWidget {
   UserCredential? credential;
   Dersler({Key? key,this.credential}) : super(key: key);

  @override
  State<Dersler> createState() => _DerslerState();
}

class _DerslerState extends State<Dersler> {

   FirebaseStorage storageinstance=FirebaseStorage.instance;
   FirebaseFirestore cloudinstance=FirebaseFirestore.instance;
    List ogretmenidleri=[];
   

      getdocid()async{
         var data =await cloudinstance.collection("Kullanicilar").get().then((value) => value);
         print(data.docs);
        // setState(() {
          // ogretmenidleri.addAll(data.docs);
         //});
         setState(() {
           ogretmenidleri=data.docs.toList();
         });
         print(ogretmenidleri.length);
      }
      docdatas()async{
         
      }
     
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdocid();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Derslerim"),),
      body: Container(
        padding:EdgeInsets.all(10),
       
        child: ListView.separated(itemCount: ogretmenidleri.length,
        itemBuilder:(context,index1){
                 List hocalar=[];
             for (var element in ogretmenidleri){
                if(element["durum"]==1){
                   hocalar.add(element);
                }
             }
             if(ogretmenidleri[index1]["durum"]==0){
                  return SizedBox(width: 0,height: 0,);
             }
             else{
             List belgeboyut=[];
              belgeboyut=ogretmenidleri[index1]["belgeurl"];
               return ListTile(title: Text("${ogretmenidleri[index1]["email"]} ",),subtitle: Text("${belgeboyut.length} adet belge var",style: TextStyle(fontSize:15),),onTap:(){
               Navigator.push(context, MaterialPageRoute(builder:(context)=>OgrenciDersListesi(hocaid:ogretmenidleri[index1]["id"],)));
              },);
             }
        },separatorBuilder:(context,index1){
          if(ogretmenidleri[index1]["durum"]==0){
             return Divider(
            
           color: Colors.white,
           thickness: 1,
        );
          }else{
             return Divider(
            
           color: Colors.black,
           thickness: 1,
        );
          }
         },)
        /*ListView.builder(itemCount: ogretmenidleri.length,itemBuilder:(context,index1){
             List hocalar=[];
             for (var element in ogretmenidleri){
                if(element["durum"]==1){
                   hocalar.add(element);
                }
             }
             if(ogretmenidleri[index1]["durum"]==0){
                  return SizedBox(width: 0,height: 0,);
             }
             else{
             
              return ListTile(title: Text("${ogretmenidleri[index1]["email"]}       ${hocalar.length}"),onTap:(){
               Navigator.push(context, MaterialPageRoute(builder:(context)=>OgrenciDersListesi(hocaid:ogretmenidleri[index1]["id"],)));
              },);
             }

         
        }),*/
        



      ),
     );

  }
}

