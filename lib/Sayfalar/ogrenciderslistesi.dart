import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
class OgrenciDersListesi extends StatefulWidget {
  String? hocaid;
   OgrenciDersListesi({Key? key,this.hocaid}) : super(key: key);

  @override
  State<OgrenciDersListesi> createState() => _OgrenciDersListesiState();
}

class _OgrenciDersListesiState extends State<OgrenciDersListesi> {
  FirebaseStorage storageornegi=FirebaseStorage.instance;


  var futureefiles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureefiles=storageornegi.ref("dersler").child(widget.hocaid!).child("photos").listAll();
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
           appBar: AppBar(title: Text(""),),
           body: Container(
            child: FutureBuilder<ListResult>(future: futureefiles,builder: (context,snapshot){

                      if(snapshot.hasData){
                         final files=snapshot.data!.items;
                         return ListView.builder(itemCount: files.length,itemBuilder: (context,index1){
                           final filename=files[index1];
                        
                           
                          
                           return Card(
                            child: Container(
                              padding: EdgeInsets.only(right: 10,left: 10),
                              height: 60,
                              child:ListTile(
                                title: Text(filename.name),
                                trailing: IconButton(onPressed: ()async{
                                  String datalink=await filename.getDownloadURL().then((value) => value);
                
                                 print("kaput -----------------${datalink}");
                                 
                                 
                                   showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop(true);
                                      });
                                        return Container(padding: EdgeInsets.only(top: 350,bottom: 350 ,left:158,right: 158),child: SizedBox(child:  CircularProgressIndicator()));
                                      });


                                  



                                 openfile(datalink, filename.name);
                                },icon: Icon(Icons.download),)
                              )
                              ),
                           );
                         }); 

                      }
                      else if(snapshot.hasError){
                         return AlertDialog(title: Text("hata var"),);
                      }
                      else{
                        return CircularProgressIndicator();
                      }



            },),
           ),
      );
  }
}