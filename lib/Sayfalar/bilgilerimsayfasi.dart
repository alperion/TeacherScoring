import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class BilgilerimSayfasi extends StatefulWidget {
  UserCredential? credentials;
 
  BilgilerimSayfasi({Key? key,this.credentials}) : super(key: key);

  @override
  State<BilgilerimSayfasi> createState() => _BilgilerimSayfasiState();
}

class _BilgilerimSayfasiState extends State<BilgilerimSayfasi> {

  FirebaseFirestore firestoreinstance=FirebaseFirestore.instance;
  FirebaseStorage storageinstance=FirebaseStorage.instance;
  Map<String,String> mapverisi={};
  TextEditingController verikullanici=TextEditingController();
  /*verilericek()async{
   Map<String,String> verisu=await firestoreinstance.collection("Kullanicilar").doc(widget.credentials!.user!.uid).get().then((value)async{
        Map<String,String> jack={};
        await value;
        jack.addAll({"bio":value["bio"]});
        jack.addAll({"numara":value["numara"]});
        jack.addAll({"username":value["username"]});
        jack.addAll({"photourl":value["photourl"]});
        return   jack;
   });
   setState(() {
     mapverisi=verisu;
     print(mapverisi.length);
   });
  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //verilericek();
     print("son verinizin degeri     ${mapverisi.length}");
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar:AppBar(title:Center(child:Text("Bilgilerim "),)),
      body:StreamBuilder(
        stream: firestoreinstance.collection("Kullanicilar").snapshots(),
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
             List liste = snapshot.data!.docs.toList();
             List liste2=[];
             liste.forEach((element) {
              if(element["id"]==widget.credentials!.user!.uid){
                  liste2.add(element);
              }
             });
             return Container(
               
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent,Colors.grey],
                    begin: Alignment.topCenter,end: Alignment.bottomCenter),),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                  Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red),
                  margin: EdgeInsets.only(top:20,right: 20,left: 20),
                  width: double.infinity,
                  height: 400,
                  child:liste2[0]["photourl"]==null?Image.asset("resimler/judgy.png"):Image(image: NetworkImage("${liste2[0]["photourl"]}"),fit: BoxFit.cover,)
                ),
                

                ListTile(leading:Icon(Icons.person),
                title:Text("${liste2[0]["username"]}"),
                trailing: IconButton(onPressed: (){     
               showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  title:const Text("Bilgimi Güncelle"),
                  content: Container(
                    height:MediaQuery.of(context).size.height/2,
                    child: Column(children: [
                      Divider(color: Colors.grey, height: 4),
                      Expanded(
                        child:TextField(
                          keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                          controller: verikullanici,
                          decoration:const InputDecoration(
                                      labelText: "Güncellenecek Veri",
                                    ),
                        ),
                      ),
                    ],),
                  ),
                    actions: [
                      IconButton(onPressed: ()async{
                    firestoreinstance.collection("Kullanicilar").doc(widget.credentials!.user!.uid).update({"username":verikullanici.text});
                     verikullanici.clear();
                      }, icon:const Icon(Icons.update_outlined))
                    ],
                );              
               });
                }, icon: Icon(Icons.change_circle)),),
                Container(width: double.infinity,padding: EdgeInsets.only(left: 20,right: 20),child: Divider(color: Colors.black,),),

                ListTile(leading:Icon(Icons.phone),
                title:Text("${liste2[0]["numara"]}"),
                trailing: IconButton(onPressed: (){     
               showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  title:const Text("Bilgimi Güncelle"),
                  content: Container(
                    height:MediaQuery.of(context).size.height/2,
                    child: Column(children: [
                      Divider(color: Colors.grey, height: 4),
                      Expanded(
                        child:TextField(
                          keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                          controller: verikullanici,
                          decoration:const InputDecoration(
                                      labelText: "Güncellenecek Veri",
                                    ),
                        ),
                      ),
                    ],),
                  ),
                    actions: [
                      IconButton(onPressed: ()async{
                    firestoreinstance.collection("Kullanicilar").doc(widget.credentials!.user!.uid).update({"numara":verikullanici.text});
                     verikullanici.clear();
                      }, icon:const Icon(Icons.update_outlined))
                    ],
                );              
               });
                }, icon: Icon(Icons.change_circle)),),
                Container(width: double.infinity,padding: EdgeInsets.only(left: 20,right: 20),child: Divider(color: Colors.black,),),
                

                ListTile(leading:Icon(Icons.book),
                title:Text("${liste2[0]["bio"]}"),
                trailing: IconButton(onPressed: (){     
               showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  title:const Text("Bilgimi Güncelle"),
                  content: Container(
                    height:MediaQuery.of(context).size.height/2,
                    child: Column(children: [
                      Divider(color: Colors.grey, height: 4),
                      Expanded(
                        child:TextField(
                          keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                          controller: verikullanici,
                          decoration:const InputDecoration(
                                      labelText: "Güncellenecek Veri",
                                    ),
                        ),
                      ),
                    ],),
                  ),
                    actions: [
                      IconButton(onPressed: ()async{
                    firestoreinstance.collection("Kullanicilar").doc(widget.credentials!.user!.uid).update({"bio":verikullanici.text});
                     verikullanici.clear();
                      }, icon:const Icon(Icons.update_outlined))
                    ],
                );              
               });
                }, icon: Icon(Icons.change_circle)),),
                Container(width: double.infinity,padding: EdgeInsets.only(left: 20,right: 20),child: Divider(color: Colors.black,),),




                    ],
                  ),
                ),    
             );
        },
      ),
      
      
      
      
      
      
      
      
      
      
      
      
      
       /*Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.lightBlueAccent,Colors.grey],begin: Alignment.topCenter,end: Alignment.bottomCenter),),
        child: SingleChildScrollView(
          child: Column(
            children: [
                 
                
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red),
                  margin: EdgeInsets.only(top:20,right: 20,left: 20),
                  width: double.infinity,
                  height: 400,
                  child:mapverisi["photourl"]==null?Image.asset("resimler/judgy.png"):Image(image: NetworkImage("${mapverisi["photourl"]}"),fit: BoxFit.cover,)
                ),
                ListTile(leading:Icon(Icons.person),
                title:Text("${mapverisi["username"]}"),
                trailing: IconButton(onPressed: (){

                    
               showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  title:const Text("Bilgimi Güncelle"),
                  content: Container(
                    height:MediaQuery.of(context).size.height/2,
                    child: Column(children: [
                      Divider(color: Colors.grey, height: 4),
                      Expanded(
                        child:TextField(
                          keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                          controller: verikullanici,
                          decoration:const InputDecoration(
                                      labelText: "Güncellenecek Veri",
                                    ),
                        ),

                      ),
                    ],),
                  ),
                    actions: [
                      IconButton(onPressed: ()async{
                    firestoreinstance.collection("Kullanicilar").doc(widget.credentials!.user!.uid).update({"username":verikullanici.text});
                     verikullanici.clear();
                      }, icon:const Icon(Icons.update_outlined))

                    ],
                );
               
               });


                }, icon: Icon(Icons.change_circle)),),
                Container(child: Divider(color: Colors.black,),padding: EdgeInsets.only(left: 20,right: 20),),


            ],
          ),
        ),
      
      
      ),*/
     );
  }
}