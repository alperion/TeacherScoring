import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SiralamaSayfasi extends StatefulWidget {
  const SiralamaSayfasi({Key? key}) : super(key: key);

  @override
  State<SiralamaSayfasi> createState() => _SiralamaSayfasiState();
}

class _SiralamaSayfasiState extends State<SiralamaSayfasi> {

   FirebaseFirestore ornekleme=FirebaseFirestore.instance;
   String urlveri="";
  @override
  Widget build(BuildContext context){
     return Scaffold(
      body: StreamBuilder(stream: ornekleme.collection("Kullanicilar").snapshots(),
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
            
            List datalar=snapshot.data!.docs.toList();
            List veridata=[];
            datalar.forEach((element) {
              if(element["durum"]==1){
                 veridata.add(element);
              }
             });
            
            Map<String,int> verisu={};
            //List veriurl=[];
            
            veridata.forEach((element) {

              verisu.addAll({element["id"]:element["begeni"]});
            
            });

          List<MapEntry<String, int>> mapEntries = verisu.entries.toList();
          mapEntries.sort((a, b) => a.value.compareTo(b.value));
          //final Map<String, int> sortedMapAsc = Map.fromEntries(mapEntries);
         // final Map<String,int> tersmap=LinkedHashMap.fromEntries(sortedMapAsc.entries.toList().reversed);
          
        
         return ListView.builder(itemCount: veridata.length,itemBuilder: (context,index){
            
              int data2=veridata[index]["begeni"];
              return ListTile(title: Text(veridata[index]["username"]),leading: CircleAvatar(backgroundImage: NetworkImage(veridata[index]["photourl"]),),subtitle: Text("skor :$data2"),);

         });
      }
      ),
     );
  }
}