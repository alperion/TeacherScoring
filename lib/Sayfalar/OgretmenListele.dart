
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'yorumlarilistele.dart';


class OgretmenListele extends StatefulWidget {
  UserCredential? credential;
  OgretmenListele({Key? key, this.credential}) : super(key: key);

  @override
  State<OgretmenListele> createState() => _OgretmenListeleState();
}

class _OgretmenListeleState extends State<OgretmenListele> {
  TextEditingController yorumtext = TextEditingController();
  FirebaseFirestore ornek = FirebaseFirestore.instance;
  bool anahtarlama = false;
  
  guncellefonksiyonu(String disid, String asid) async {
    List begenilistesi = [];
    List asilliste =
        await ornek.collection("Kullanicilar").doc(asid).get().then((value) {
      begenilistesi = value["begenenlistesi"];
      return begenilistesi;
    });
    int ornekbegeni = 0;
    int begeni =
        await ornek.collection("Kullanicilar").doc(asid).get().then((value) {
      ornekbegeni = value["begeni"];
      return ornekbegeni;
    });

    if (asilliste.length > 0) {
      if (asilliste.contains(disid)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("zaten begeni yapılmıs")));
      } else {
        asilliste.add(disid);
        begeni += 1;
        await ornek
            .collection("Kullanicilar")
            .doc(asid)
            .update({"begeni": begeni, "begenenlistesi": asilliste});
      }
    }
    if (asilliste.length == 0) {
      asilliste.add(disid);
      begeni += 1;
      await ornek
          .collection("Kullanicilar")
          .doc(asid)
          .update({"begeni": begeni, "begenenlistesi": asilliste});
    }
  }

  Future yorumla(String disid, String asid) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child:
                  Text("Yorum Yap", style: TextStyle(color: Colors.blueAccent)),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Divider(color: Colors.grey, height: 4),
                  Expanded(
                      child: TextField(
                    controller: yorumtext,
                    decoration: InputDecoration(
                      labelText: "Yorum",
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
                child: Text(
                  "Yorum Yap",
                ),
                onPressed: () async {
                Map<String,dynamic> anaveri=await ornek.collection("Kullanicilar").doc(asid).get().then((value){

                    return value["yorumlar"];

                  });
                  Map<String,dynamic> yanveri={};
                  List<dynamic> anayorumlar=[];
                  List<dynamic> yanyorumlar=[];


                  if(anaveri.isEmpty){
                        yanyorumlar.add(yorumtext.text);
                        yanveri.addAll({disid:anayorumlar});
                        ornek.collection("Kullanicilar").doc(asid).update({
                          "yorumlar":yanveri
                        });
                        yanveri.clear();
                        yanyorumlar.clear();
                  }
                  else{
                    yanveri=anaveri;
                    if(yanveri.containsKey(disid)){
                      yanyorumlar=yanveri[disid];
                      yanyorumlar.add(yorumtext.text);
                      yanveri[disid]=yanyorumlar;
                     await  ornek.collection("Kullanicilar").doc(asid).update({
                        "yorumlar":yanveri
                      });
                      yanveri.clear();
                      yanyorumlar.clear();
                    }
                    else{
                      yanyorumlar.add(yorumtext.text);
                      yanveri.addAll({disid:yanyorumlar});
                      await  ornek.collection("Kullanicilar").doc(asid).update({
                        "yorumlar":yanveri
                      });
                      yanveri.clear();
                      yanyorumlar.clear();

                    }
                    

                  }



                },
              ),
              TextButton(
                child: Text(
                  "Yorumları Gör",
                ),
                onPressed: () {

                    
             Navigator.push(context,MaterialPageRoute(builder: (context)=>YorumlariListele(disid: disid,asid: asid,)));
             yorumtext.clear();


                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğretmenler"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder(
          stream: ornek.collection("Kullanicilar").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return ListView.builder(
              itemBuilder: (context, index){
                if (liste[index]["durum"] == 0) {
                  return SizedBox(
                    width: 0,
                    height: 0,
                  );
                } else {
                  return Card(
                    
                    color: Colors.blue,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 12.0,right: 12.0,top: 10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                          height: 500,
                          width: double.infinity,
                          child: Image.network(liste[index]["photourl"],fit: BoxFit.cover,)//Text(liste[index]["email"]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(liste[index]["begeni"].toString()),
                            IconButton(
                                onPressed: () => guncellefonksiyonu(
                                    widget.credential!.user!.uid,
                                    liste[index]["id"]),
                                icon: Icon(Icons.heart_broken,color: Colors.red,)),
                            IconButton(
                                onPressed: () => yorumla(
                                    widget.credential!.user!.uid,
                                    liste[index]["id"]),
                                icon: Icon(Icons.comment,color: Colors.orange,))
                          ],
                        )
                      ],
                    )),
                  );
                }
              },
              itemCount: liste.length,
            );
          },
        ),
      ),
    );
  }
}
