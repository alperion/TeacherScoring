import 'package:flutter/material.dart';

class OgretmenlerveDersler extends StatefulWidget {
  const OgretmenlerveDersler({Key? key}) : super(key: key);

  @override
  State<OgretmenlerveDersler> createState() => _OgretmenlerveDerslerState();
}

class _OgretmenlerveDerslerState extends State<OgretmenlerveDersler> {

  TextEditingController textEditingController = TextEditingController();
  String searching = "";
  List filterList = [];
  List hocalar=["sema servi","esma eryılmaz doğan","mustafa acaroğlu",
  "adem alparslan altun","nurettin doğan","mustafa zenginbaş",
  "bahar kunul","ezgi koçak ünsal","fatih başçiftçi","selahattin alan","ahmet cevahir çınar"
  ];
  List harfler=["aasd","bghk","cjlşj","dwrt","etukt","fsdgvs","gnılt","hrtusr","iqwrgh","jafdngh","dfgdfgk"];
  List<List<String>> dersler=[["matematik-1"],["fizik-1",],["iş sağlığı ve güvenliği"],
  ["bilgisayar mühendisliğine giriş"],["lineer cebir"],
  ["atatürk inkılapları tarihi"],["türk dili-1"],["yabancı dil-1"],["mantık devreleri-1"],["işletim sistemleri"],["istatistik ve olasılık"],];

  Map<String,List<String>> ogretmenvedersler={
    "sema servi":["matematik-1","chucky"],
    "esma eryılmaz doğan":["fizik-1"],
    "mustafa acaroğlu":["iş sağlığı ve güvenliği",],
    "adem alparslan altun":["bilgisayar mühendisliğine giriş"],
    "nurettin doğan":["lineer cebir"],
    "mustafa zenginbaş":["atatürk inkılapları tarihi"],
    "bahar kunul":["türk dili-1"],
    "ezgi koçak ünsal":["yabancı dil-1"],
    "fatih başçiftçi":["mantık devreleri-1"],
    "selahattin alan":["işletim sistemleri"],
    "ahmet cevahir çınar":["istatistik ve olasılık"],
    "ilker ali özkan":["veri yapıları"],
    "humar kahramanlı örnek":["sayısal yöntemler","blockzincir temelleri"],
    "mustafa gökmen":["nesneye yönelik programlama dili"],
    "gülnihal güğül":["elektronik devre elemanları ve ölçme"],
    "şakir taşdemir":["mikroişlemciler ve mikrodenetleyiciler"],
    "tahir sağ":["programlama dili-3"],
    "nevzat örnek":["veri haberleşmesi ve ağlar","kablosuz ağlar"],
    "murat köklü":["veri madenciliği","bilgisayar mimarisi ve organizasyonu"],
    "muhammet serdar başçıl":["biyomedikal sistemler","mühendislik ekonomisi","sayısal analiz","iş sağlıgı ve güvenliği-1",],
    "onur inan":["veri tabanı programlama","bulut bilişim"],
    "adem gölcük":["teknik ingilizce","veri iletişim teknikleri"],
    "kübra uyar":["veri bilimi"],
    "ibrahim uyanık":["kimya"],
    "kemal tütüncü":["elektrik elektronik mühendisliğine giriş",""],
    "mehmet akif şahman":["programlama"],
    "uğur taşkıran":["istatistik ve olasılık"],
    "fehmi sevilmiş":["devre analizi-1"],
    "hakan ışık":["elektronik-1"],
    "hakan terzioğlu":["kontrol sistemleri"],
    "mehmet çunkaş":["elektro mekanik enerji dönüşümü"],
    



  };

  List verilistesi=[];
  List ogretmenlistesi=[];
  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Öğretmenler ve Dersler"),),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
            children: [
              
              Expanded(
                child: Container(),
              ),
              
              Expanded(child: Container())
            ],
          ),

          ///
           Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 2),
            child: TextField(
              
              controller: textEditingController,
              onChanged: (value) {
                setState(() {
                  searching = value;
                });
                /*
                filterList = hocalar
                    .where((element) => element
                        .toString()
                        .toLowerCase()
                        .contains(searching.toLowerCase()))
                    .toList();
                  */
                
                ogretmenvedersler.forEach((key, value) {
                  if(key.contains(searching.toLowerCase())){
                  setState(() {
                    verilistesi=value;
                    print("value degeri ${value.length}");
                  });
                  }
                });
                
                setState(() {
                  ogretmenlistesi=ogretmenvedersler.keys.toList();
                });
                  
              },
              decoration: const InputDecoration(
                  hintText: 'Arama', border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  searching.isEmpty ? ogretmenlistesi.length : verilistesi.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  child: Card(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 5),
                    child:Text(
                        searching.isEmpty ? ogretmenlistesi[index] : verilistesi[index],
                      ),
                  ),
                );
              },
            ),
          ),



          ],
        ),
      ),
     );
  }
}