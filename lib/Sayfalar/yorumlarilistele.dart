import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YorumlariListele extends StatefulWidget {
  String? disid;
  String? asid;
  
  YorumlariListele({Key? key, this.disid,this.asid}) : super(key: key);

  @override
  State<YorumlariListele> createState() => _YorumlariListeleState();
}

class _YorumlariListeleState extends State<YorumlariListele> {
   
   FirebaseFirestore ornek1=FirebaseFirestore.instance;
    

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Yorumlar ve Hocalar"),),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child:StreamBuilder(stream: ornek1.collection("Kullanicilar").snapshots(),builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
             
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
            
         
            List liste1=snapshot.data!.docs.toList();
            List ogrtmntutucu=[];
            
            liste1.forEach((element) { 
              if(element["id"]==widget.asid){
                    ogrtmntutucu.add(element);
              }
            });

             Map yorumtutucular=ogrtmntutucu[0]["yorumlar"];
             List heptutucu=[];
             yorumtutucular.forEach((elemnt,index){
                  
                  for (var element in index) {
                       heptutucu.add(element);
                       print(element);
                  }
                 
             });
             print("liste sayisi ${yorumtutucular.values.length}");
             return  ListView.separated(itemBuilder:(context,index2){
                return ListTile(
                  title: Text("${heptutucu[index2]}"),
                  leading: Icon(Icons.arrow_circle_right),
                );
              }, separatorBuilder:(context,index)=>Divider(color: Colors.grey,), itemCount:heptutucu.length);

             /*
             return ListView.builder(itemCount:heptutucu.length ,itemBuilder:(context , indexyorum){

              return ListTile(
                title: Text("${heptutucu[indexyorum]}"),
              );
             });
             */






 //önce         //  List liste2=[];

           /* liste1.forEach((element) { 
              if(element["durum"]==1){
                liste2.add(element);
              }
            });
*/
          
         /*   önce 
            if(liste2.isEmpty){
                return Text("datalar");
            } 
            else{
              return Text("datasu ${liste2.length}");
            }
*/







        },), 
      ),
     );
  }
}