import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:ensonproje/Sayfalar/bilgilerimsayfasi.dart';
import 'package:ensonproje/Sayfalar/derslerim.dart';
import 'package:ensonproje/Sayfalar/siralamalar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ensonproje/Servis/KayitMetotlari.dart';
import 'package:ensonproje/Servis/dosyametotlari.dart';
import 'package:ensonproje/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'ogrenxilistele.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Ogretmen extends StatefulWidget {
  UserCredential? credential;
  Ogretmen({Key? key, this.credential}) : super(key: key);

  @override
  State<Ogretmen> createState() => _OgretmenState();
}

class _OgretmenState extends State<Ogretmen> {
  FirebaseFirestore firestoreornek = FirebaseFirestore.instance;
  FirebaseFirestore cloudstore = FirebaseFirestore.instance;
  String photourl = "";
  TextEditingController klasoryolu = TextEditingController();
  Uint8List? imagedata;
  Map <String,String> kullanicidatalari={};
  
  
  Future<String> getirici() async {
    String photourls = await firestoreornek
        .collection("Kullanicilar")
        .doc(widget.credential!.user?.uid)
        .get()
        .then((value) {
      setState(() {
        photourl = value["photourl"];
      });
      return photourl;
    });
    return "";
  }

  resimsec(ImageSource source) async {
    final ImagePicker _imagepicker = ImagePicker();
    XFile? _file = await _imagepicker.pickImage(source: source);

    if (_file != null) {
      print("secilen resim kullanıldı");
      return await _file.readAsBytes();
    } else {
     print("object");
    }
  }

  resmidegiskeneaktar() async {
    Uint8List? im = await resimsec(ImageSource.gallery);
    if (im != null) {
      setState(() {
        imagedata = im;
      });
    } else {
      Navigator.pop(context);
    }
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
      appBar: AppBar(
        title: Text("Ogretmen"),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: ListView(
          children: [
            SizedBox(height: 30,),
            DrawerHeader(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(photourl),
                  radius: 80,
                ),
                
              ],
            ))),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.graduationCap),
              title: Text("Öğrenciler"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OgrenciListele(
                              
                            )));
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.sort),
              title: Text("sıralamalar"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SiralamaSayfasi(
                              
                            )));
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.bookAtlas),
              title: Text("Derslerim"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DerslerimSayfasi(
                              credential: widget.credential,
                            )));
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.outdent),
              title: Text("Çıkış Yap"),
              onTap: () async {
                await KayitIslemleri().cikisYap();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GirisSayfasi()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
      body: Container(
         
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueGrey,Colors.grey],begin: Alignment.topCenter,end: Alignment.bottomCenter),),
         height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
          SizedBox(height: 20,),
                Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.data_saver_off_rounded,
                        size: 60,
                      ),
                      Text("Bilgilerim")
                    ],
                  ),
                  onTap: () async{
                     Map <String,String> bilgilerimveriler=await firestoreornek.collection("Kullanicilar").doc(widget.credential!.user!.uid).get().then((value)async{
        Map<String,String> jack={};
        await value;
        jack.addAll({"bio":value["bio"]});
        jack.addAll({"numara":value["numara"]});
        jack.addAll({"username":value["username"]});
        jack.addAll({"photourl":value["photourl"]});


        return   jack;
   });
        print("son verinizin degeri     ${bilgilerimveriler.length}");





                     Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BilgilerimSayfasi(
                              credentials: widget.credential,
                             
                            )));
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ////////////////////////////////////////////////////////////// Resim Kısmı
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
                        size: 60,
                      ),
                      Text("Resim Yükle",style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Center(
                              child: Text("Klasör adı veriniz ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Divider(color: Colors.grey, height: 4),
                                  Expanded(
                                    child: TextField(
                                    controller: klasoryolu,
                                    decoration: InputDecoration(
                                      labelText: "Klasor yolu",
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                  ))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await resmidegiskeneaktar();
                                    await StorageMethods().dosyabirresim(
                                        "dersler",
                                        klasoryolu.text,
                                        imagedata,
                                        widget.credential!.user!.uid);
                                  },
                                  child: Text("görüntü seç"))
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),
         //////////////////////////////////////////// PDF KISMI
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.red, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        size: 60,
                      ),
                      Text("PDF Yükle",style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text("Klasör adı veriniz ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Divider(color: Colors.grey, height: 4),
                                  Expanded(
                                      child: TextField(
                                    controller: klasoryolu,
                                    decoration: InputDecoration(
                                      labelText: "Dosya Adı",
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                  ))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles();
                                    Io.File pick = Io.File(
                                        result!.files.single.path.toString());
                                    var file = await pick.readAsBytes();
        
                                    await StorageMethods().dosyaikipdf(
                                        "dersler",
                                        klasoryolu.text,
                                        file,
                                        widget.credential!.user!.uid);
                                  },
                                  child: Text("Pdf seç"))
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),
        
         ///////////////////////////////////////////////  Video YUKLE
        
             SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.blue, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_call,
                        size: 60,
                      ),
                      Text("Video Yükle",style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text("Klasör adı veriniz ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Divider(color: Colors.grey, height: 4),
                                  Expanded(
                                      child: TextField(
                                    controller: klasoryolu,
                                    decoration: InputDecoration(
                                      labelText: "Klasor yolu",
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                  ))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.video);
                                    Io.File pick = Io.File(
                                        result!.files.single.path.toString());
                                    var file = await pick.readAsBytes();
        
                                    await StorageMethods().dosyaikipdf(
                                        "dersler",
                                        klasoryolu.text,
                                        file,
                                        widget.credential!.user!.uid);
                                  },
                                  child: Text("görüntü seç"))
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),
        
        
        
        
         /////////////////////////////////////////// SES DOSYASI YUKLE
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.keyboard_voice_outlined,
                        size: 60,
                      ),
                      Text("Ses Dosyası Yükle",style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text("Klasör adı veriniz ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Divider(color: Colors.grey, height: 4),
                                  Expanded(
                                      child: TextField(
                                    controller: klasoryolu,
                                    decoration: InputDecoration(
                                      labelText: "Dosya Adı",
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                  ))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.audio);
                                    Io.File pick = Io.File(
                                        result!.files.single.path.toString());
                                    var file = await pick.readAsBytes();
        
                                    await StorageMethods().dosyaikipdf(
                                        "dersler",
                                        klasoryolu.text,
                                        file,
                                        widget.credential!.user!.uid);
                                  },
                                  child: Text("Ses Dosyası seç"))
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),
        
         SizedBox(height: 20,),
          ///////////////////////////////////////////WORD
          
        
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.blue, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     FaIcon(FontAwesomeIcons.fileWord,size: 60,),
                      Text("Word Dosyası Yükle",style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text("Klasör adı veriniz ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Divider(color: Colors.grey, height: 4),
                                  Expanded(
                                      child: TextField(
                                    controller: klasoryolu,
                                    decoration: InputDecoration(
                                      labelText: "Dosya Adı",
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                  ))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.audio);
                                    Io.File pick = Io.File(
                                        result!.files.single.path.toString());
                                    var file = await pick.readAsBytes();
        
                                    await StorageMethods().dosyaikipdf(
                                        "dersler",
                                        klasoryolu.text,
                                        file,
                                        widget.credential!.user!.uid);
                                  },
                                  child: Text("Word Dosyası seç"))
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),




          ////////////////////////////////////////////// EXCEL 
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 2,
              dashPattern: [
                5,
                5,
              ],
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.green, Colors.grey],
                )),
                width: double.infinity,
                height: 120,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.fileExcel,
                        size: 60,
                      ),SizedBox(width: 10,),
                      Text("Excel Dosyası Yükle",style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text("Klasör adı veriniz ",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  Divider(color: Colors.grey, height: 4),
                                  Expanded(
                                      child: TextField(
                                    controller: klasoryolu,
                                    decoration: InputDecoration(
                                      labelText: "Dosya Adı",
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                  ))
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.audio);
                                    Io.File pick = Io.File(
                                        result!.files.single.path.toString());
                                    var file = await pick.readAsBytes();
        
                                    await StorageMethods().dosyaikipdf(
                                        "dersler",
                                        klasoryolu.text,
                                        file,
                                        widget.credential!.user!.uid);
                                  },
                                  child: Text("Ses Dosyası seç"))
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),







        
            ],
          ),
        ),
      ),
    );
  }
}
