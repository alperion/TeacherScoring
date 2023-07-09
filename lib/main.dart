import 'package:ensonproje/Sayfalar/Ogrenci.dart';
import 'package:ensonproje/Sayfalar/Ogretmen.dart';
import 'package:ensonproje/Servis/KayitMetotlari.dart';
import 'package:ensonproje/kayitekrani.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GirisSayfasi(),
    );
  }
}

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, Colors.grey],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Column(
            children: [
             const SizedBox(
                height: 100,
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 2)),
                child: Image.asset("resimler/judgy.png"),
              ),
             const SizedBox(
                height: 80,
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail), hintText: "email"),
              ),
             const SizedBox(
                height: 80,
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password), hintText: "şifre"),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                padding:const EdgeInsets.only(left: 20,right: 20),
                child: ElevatedButton(
                    onPressed: () async {
                      if (email.text.isEmpty || password.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (
                              context,
                            ) {
                              return AlertDialog(
                                content: Text(
                                    "Lütfen email ve şifre alanlarını doldurunuz"),
                              );
                            });
                      } else {
                        KayitIslemleri()
                            .girisyap(email.text, password.text)
                            .then((value) async {
                          int ilhal = 0;
                          int durum = await firestore
                              .collection("Kullanicilar")
                              .doc(value.user?.uid)
                              .get()
                              .then((deger) {
                            ilhal = deger["durum"];
                            return ilhal;
                          });
                          if (durum == 0) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ogrenci(
                                          credential: value,
                                        )),
                                (route) => false);
                          }
                          if (durum == 1) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ogretmen(
                                          credential: value,
                                        )),
                                (route) => false);
                          }
                        });
                      }
                    },
                    child: Text("Giriş")),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>KayitSayfasi()));
              }, child: Text("Kaydol"))
            ],
          ),
        ),
      ),
    );
  }
}
