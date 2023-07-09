import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class OgretmenBilgileri extends StatefulWidget {
  const OgretmenBilgileri({Key? key}) : super(key: key);

  @override
  State<OgretmenBilgileri> createState() => _OgretmenBilgileriState();
}

class _OgretmenBilgileriState extends State<OgretmenBilgileri> {

   FirebaseFirestore firestoreinstance=FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Öğretmen Bilgileri"),),
      body: StreamBuilder(stream: firestoreinstance.collection("Kullanicilar").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

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
            if (snapshot.hasData) {
              print("veri var");
            }
            List ogretmentutucu=snapshot.data!.docs.toList();
            List ogretmentutucu2=[];

            ogretmentutucu.forEach((element) { 
              if(element["durum"]==1){
                ogretmentutucu2.add(element);
              }
            });
            return ListView.builder(itemCount: ogretmentutucu2.length,itemBuilder: (context,index){
              return Container(
                 decoration:const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent,Colors.grey],
                    begin: Alignment.topCenter,end: Alignment.bottomCenter),),
                    child: Column(
                      children: [
                        Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin:const EdgeInsets.only(top:20,right: 20,left: 20),
                  width: double.infinity,
                  height: 400,
                  child:ogretmentutucu2[index]["photourl"]==null?Image.asset("resimler/judgy.png"):Image(image: NetworkImage("${ogretmentutucu2[index]["photourl"]}"),fit: BoxFit.cover,)
                ),
                ListTile(title: Text("${ogretmentutucu2[index]["username"]}"),leading:const Icon(Icons.person),),
                Container(width: double.infinity,padding:const EdgeInsets.only(left: 20,right: 20),child:const Divider(color: Colors.black,),),
                ListTile(title: Text("${ogretmentutucu2[index]["numara"]}"),leading:const Icon(Icons.phone),
                trailing: IconButton(icon:const Icon(Icons.phone_forwarded_rounded),onPressed: ()async{
                     await FlutterPhoneDirectCaller.callNumber("${ogretmentutucu2[index]["numara"]}");
                },),),
                Container(width: double.infinity,padding:const EdgeInsets.only(left: 20,right: 20),child: const Divider(color: Colors.black,),),
                ListTile(title: Text("${ogretmentutucu2[index]["bio"]}"),leading:const Icon(Icons.book),),
                Container(width: double.infinity,padding:const  EdgeInsets.only(left: 20,right: 20),child:const Divider(color: Colors.black,),),
                ListTile(title: Text("${ogretmentutucu2[index]["email"]}"),leading:const Icon(Icons.mail),),
                Container(width: double.infinity,padding:const  EdgeInsets.only(left: 20,right: 20),child:const Divider(color: Colors.black,),),

                



                      ],
                    ),
              );
            });
            
      }),
     );
  }
}