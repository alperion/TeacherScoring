





import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class DerslerimSayfasi extends StatefulWidget {
   final UserCredential? credential;
   DerslerimSayfasi({Key? key,this.credential}) : super(key: key);

  @override
  State<DerslerimSayfasi> createState() => _DerslerimSayfasiState();
}

class _DerslerimSayfasiState extends State<DerslerimSayfasi> {

   FirebaseStorage storageornek=FirebaseStorage.instance;
   FirebaseFirestore storedata=FirebaseFirestore.instance;
   String idver="";
    

   
   var futurefiles;
   

    
    @override
  void initState() {
    
    super.initState();
    idver=widget.credential!.user!.uid;
    futurefiles=storageornek.ref("dersler").child(idver).child("photos").listAll();
   

  }
  
  Future openfile(String url,String filename)async{
     final file= await downloadfile(url,filename);
      if(file==null){
        return ;
      }
      print('pahtler ${file.path}');
      OpenFile.open(file.path);
  }

  Future<File?>downloadfile(String url,String name)async{
    await url;
      final appstorage=await getApplicationDocumentsDirectory();
      final file=File('${appstorage.path}/${name}');
       
       final response=await Dio().get(
        url,  
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0
        )
       );
       
       
       final raf =file.openSync(mode: FileMode.write);
       raf.writeFromSync(response.data);
       await raf.close();
       return file ;
  
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Yüklediğim Dersler"),),
      body: Container(
        
       child: FutureBuilder<ListResult>(
        future: futurefiles,
        builder: (context,snapshot){
         if(snapshot.hasData){
            final files=snapshot.data!.items;
            return ListView.separated( separatorBuilder: ((context, index) => const Divider(thickness: 1,)), 
            itemCount: files.length,
            itemBuilder: (context,index){
              final filename=files[index];
              return Slidable(
                endActionPane: ActionPane(motion: Row(children: [
                  IconButton(onPressed: ()async{
                      String datalink=await filename.getDownloadURL().then((value) => value);
                     
                      print("kaput -----------------${datalink}");
                      
                      openfile(datalink, filename.name);
                    }, icon: Icon(Icons.download),
                    ),
                    IconButton(onPressed: ()async{

                     String datalink=await filename.getDownloadURL().then((value) => value);
                     filename.delete();
                     List datatutucu=[];
                     List datatutucu2=[];
                     datatutucu2=await storedata.collection("Kullanicilar").doc(widget.credential!.user!.uid).get().then((value) => value["belgeurl"]);
                     datatutucu2.forEach((element) { 
                      if(datalink!=element){
                       datatutucu.add(element);
                      }
                     });
                     await storedata.collection("Kullanicilar").doc(widget.credential!.user!.uid).update({"belgeurl":datatutucu});
                     print(filename);
                     print(datalink);
                     
                    }, icon:Icon(Icons.delete))
                ],), children:[Icon(Icons.download),Icon(Icons.delete)]),
                child: ListTile(title: Text(filename.name)),
              );
            },
            );
            
            
            
             /*ListView.builder(itemCount: files.length,itemBuilder:(context,index){
               final filename=files[index];
               
               
              
              return ListTile(title: Text(filename.name),
              subtitle:Text("${"alperen efsaendir"}"),
              trailing: Slidable(
                child: Row(
                  children: [
                    IconButton(onPressed: ()async{
                      String datalink=await filename.getDownloadURL().then((value) => value);
                      
                      print("kaput -----------------${datalink}");
                      
                      openfile(datalink, filename.name);
                    }, icon: Icon(Icons.download)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.abc))
                  ],
                ),
              ),
            
             );
            }); */ 
         }
         else if(snapshot.hasError){
               return Center(child: Text("veri gelmedi "),);
         }else{
          return Center(child: CircularProgressIndicator());
         }
        },
       ),
        /*StreamBuilder(
         stream:storedata.collection("Kullanicilar").snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

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

             String idver=widget.credential!.user!.uid;
             /*List listem = snapshot.data!.docs.toList();
             
             var yenilist=[];
             var belgeler=[];
            
              for (var element in listem) {
                 print(element["id"]);
                 if(element["id"]==idver){
                  yenilist.add(element);
                 }
              }
              belgeler=yenilist[0]["belgeurl"];
              return ListView.builder(itemCount:belgeler.length,itemBuilder:(context,index1){
                return ListTile(title: Text("${belgeler[index1]}"),);
              } );*/


         },
        ),*/
      ),
     ) ;
  }
}