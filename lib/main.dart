import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fading_image_button/fading_image_button.dart';
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
    );
    return MaterialApp(
      title: '테트리스',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        color: Colors.black,
        child: DatabaseApp(),
      ),
    );
  }
}

class DatabaseApp extends StatefulWidget {
  const DatabaseApp({Key? key}) : super(key: key);

  @override
  State<DatabaseApp> createState() => _DatabaseAppState();
}

class _DatabaseAppState extends State<DatabaseApp> {

  late int v_lineNext;
  late int v_lineMove;




  bool? v_flagButtonPlay = true;
  bool? v_flagButtonStop = false;
  bool? v_flagButtonPause = false;
  bool? v_flagButtonArrow = false;
  bool? v_flagNext = true;
  bool? v_flagStartGame = true;


  int v_countItem = 0;
  late int i;
  late int j;
  late int k;
  late int l;
  late int ii;
  late int jj;

  int v_atr = 5;
  int v_rowBox=20;
  int v_colBox = 10;
  int v_rowNext = 4;
  int v_colNext = 4;
  int v_itemNo = 0;


  late Timer _timer;
  int v_timeInterval_base = 400;
  int v_timeInterval = 0;


  //변수 설정
  String v_image_volume = '';
  bool v_volume = true;

  final v_listBox = List.generate(20, (i) => List.generate(10, (j) => List.generate(5, (k) => 0)));

  final v_listN1Box = List.generate(4, (i) => List.generate(4, (j) => List.generate(5, (k) => 0)));

  final v_listN2Box = List.generate(4, (i) => List.generate(4, (j) => List.generate(5, (k) => 0)));

  final v_listItem = List.generate(16, (i) => List.generate(4, (i) => List.generate(4, (k) => List.generate(5, (l) => 0))));

  final v_listN0Box = List.generate(4, (i) => List.generate(4, (j) => List.generate(5, (k)=>0)));

  final v_listMove = List.generate(4, (i) => List.generate(3, (j) => 0));

  final v_listMoveTarget = List.generate(4, (i) => List.generate(2, (j) => 0));


  int v_level = 0; //레벨
  int v_score = 0; //점수
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('테트리스'
        ,style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),),
        actions: [
          ElevatedButton(onPressed: () async{
            if(v_flagButtonPlay == false){
              flutter_toast(1, '재미 없어!');
            }else{
              const url = 'https://blog.naver.com/qlqlxks123';
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            }
          }, child: Text('버튼')),
          ElevatedButton(onPressed: ()async{
            if(v_flagButtonPlay == false){
              flutter_toast(1, 'not executed!');
            }else{
              const url = 'https://www.samsung.com/sec/sustainability/main/';
              await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
            }
          }, child: Text('플레이스토어 아이콘')),

          ElevatedButton(onPressed: ()async{
            if(v_volume == true){
              v_image_volume = '';
              v_volume = false;
              if(v_flagButtonPlay == false){
                _playerLoop.pause();
              }
            }else{
              v_image_volume = '';
              v_volume = true;
              if(v_flagButtonPlay == false){
                _playerLoop.play();
              }
            };setState(() {
              
            });
          }, child: Text('소리 끄고 켜기')),
          
          ElevatedButton(onPressed: ()async{
            if(v_flagButtonPlay == true){
              //렝크 게임 이동
            }else{
              flutter_toast(1, '실행 중이 아닙니다');
            }
          }, child: Text('rank')),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: Container(
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                      flex: 14,
                      child: Container(  // 상단 왼쪽 보드판
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][0][0], v_listBox[0][0][1], v_listBox[0][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][1][0], v_listBox[0][1][1], v_listBox[0][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][2][0], v_listBox[0][2][1], v_listBox[0][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][3][0], v_listBox[0][3][1], v_listBox[0][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][4][0], v_listBox[0][4][1], v_listBox[0][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][5][0], v_listBox[0][5][1], v_listBox[0][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][6][0], v_listBox[0][6][1], v_listBox[0][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][7][0], v_listBox[0][7][1], v_listBox[0][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][8][0], v_listBox[0][8][1], v_listBox[0][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[0][9][0], v_listBox[0][9][1], v_listBox[0][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][0][0], v_listBox[1][0][1], v_listBox[1][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][1][0], v_listBox[1][1][1], v_listBox[1][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][2][0], v_listBox[1][2][1], v_listBox[1][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][3][0], v_listBox[1][3][1], v_listBox[1][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][4][0], v_listBox[1][4][1], v_listBox[1][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][5][0], v_listBox[1][5][1], v_listBox[1][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][6][0], v_listBox[1][6][1], v_listBox[1][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][7][0], v_listBox[1][7][1], v_listBox[1][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][8][0], v_listBox[1][8][1], v_listBox[1][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[1][9][0], v_listBox[1][9][1], v_listBox[1][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][0][0], v_listBox[2][0][1], v_listBox[2][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][1][0], v_listBox[2][1][1], v_listBox[2][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][2][0], v_listBox[2][2][1], v_listBox[2][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][3][0], v_listBox[2][3][1], v_listBox[2][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][4][0], v_listBox[2][4][1], v_listBox[2][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][5][0], v_listBox[2][5][1], v_listBox[2][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][6][0], v_listBox[2][6][1], v_listBox[2][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][7][0], v_listBox[2][7][1], v_listBox[2][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][8][0], v_listBox[2][8][1], v_listBox[2][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[2][9][0], v_listBox[2][9][1], v_listBox[2][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][0][0], v_listBox[3][0][1], v_listBox[3][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][1][0], v_listBox[3][1][1], v_listBox[3][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][2][0], v_listBox[3][2][1], v_listBox[3][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][3][0], v_listBox[3][3][1], v_listBox[3][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][4][0], v_listBox[3][4][1], v_listBox[3][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][5][0], v_listBox[3][5][1], v_listBox[3][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][6][0], v_listBox[3][6][1], v_listBox[3][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][7][0], v_listBox[3][7][1], v_listBox[3][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][8][0], v_listBox[3][8][1], v_listBox[3][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[3][9][0], v_listBox[3][9][1], v_listBox[3][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][0][0], v_listBox[4][0][1], v_listBox[4][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][1][0], v_listBox[4][1][1], v_listBox[4][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][2][0], v_listBox[4][2][1], v_listBox[4][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][3][0], v_listBox[4][3][1], v_listBox[4][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][4][0], v_listBox[4][4][1], v_listBox[4][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][5][0], v_listBox[4][5][1], v_listBox[4][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][6][0], v_listBox[4][6][1], v_listBox[4][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][7][0], v_listBox[4][7][1], v_listBox[4][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][8][0], v_listBox[4][8][1], v_listBox[4][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[4][9][0], v_listBox[4][9][1], v_listBox[4][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][0][0], v_listBox[5][0][1], v_listBox[5][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][1][0], v_listBox[5][1][1], v_listBox[5][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][2][0], v_listBox[5][2][1], v_listBox[5][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][3][0], v_listBox[5][3][1], v_listBox[5][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][4][0], v_listBox[5][4][1], v_listBox[5][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][5][0], v_listBox[5][5][1], v_listBox[5][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][6][0], v_listBox[5][6][1], v_listBox[5][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][7][0], v_listBox[5][7][1], v_listBox[5][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][8][0], v_listBox[5][8][1], v_listBox[5][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[5][9][0], v_listBox[5][9][1], v_listBox[5][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][0][0], v_listBox[6][0][1], v_listBox[6][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][1][0], v_listBox[6][1][1], v_listBox[6][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][2][0], v_listBox[6][2][1], v_listBox[6][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][3][0], v_listBox[6][3][1], v_listBox[6][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][4][0], v_listBox[6][4][1], v_listBox[6][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][5][0], v_listBox[6][5][1], v_listBox[6][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][6][0], v_listBox[6][6][1], v_listBox[6][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][7][0], v_listBox[6][7][1], v_listBox[6][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][8][0], v_listBox[6][8][1], v_listBox[6][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[6][9][0], v_listBox[6][9][1], v_listBox[6][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][0][0], v_listBox[7][0][1], v_listBox[7][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][1][0], v_listBox[7][1][1], v_listBox[7][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][2][0], v_listBox[7][2][1], v_listBox[7][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][3][0], v_listBox[7][3][1], v_listBox[7][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][4][0], v_listBox[7][4][1], v_listBox[7][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][5][0], v_listBox[7][5][1], v_listBox[7][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][6][0], v_listBox[7][6][1], v_listBox[7][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][7][0], v_listBox[7][7][1], v_listBox[7][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][8][0], v_listBox[7][8][1], v_listBox[7][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[7][9][0], v_listBox[7][9][1], v_listBox[7][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][0][0], v_listBox[8][0][1], v_listBox[8][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][1][0], v_listBox[8][1][1], v_listBox[8][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][2][0], v_listBox[8][2][1], v_listBox[8][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][3][0], v_listBox[8][3][1], v_listBox[8][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][4][0], v_listBox[8][4][1], v_listBox[8][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][5][0], v_listBox[8][5][1], v_listBox[8][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][6][0], v_listBox[8][6][1], v_listBox[8][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][7][0], v_listBox[8][7][1], v_listBox[8][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][8][0], v_listBox[8][8][1], v_listBox[8][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[8][9][0], v_listBox[8][9][1], v_listBox[8][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][0][0], v_listBox[9][0][1], v_listBox[9][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][1][0], v_listBox[9][1][1], v_listBox[9][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][2][0], v_listBox[9][2][1], v_listBox[9][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][3][0], v_listBox[9][3][1], v_listBox[9][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][4][0], v_listBox[9][4][1], v_listBox[9][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][5][0], v_listBox[9][5][1], v_listBox[9][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][6][0], v_listBox[9][6][1], v_listBox[9][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][7][0], v_listBox[9][7][1], v_listBox[9][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][8][0], v_listBox[9][8][1], v_listBox[9][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[9][9][0], v_listBox[9][9][1], v_listBox[9][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][0][0], v_listBox[10][0][1], v_listBox[10][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][1][0], v_listBox[10][1][1], v_listBox[10][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][2][0], v_listBox[10][2][1], v_listBox[10][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][3][0], v_listBox[10][3][1], v_listBox[10][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][4][0], v_listBox[10][4][1], v_listBox[10][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][5][0], v_listBox[10][5][1], v_listBox[10][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][6][0], v_listBox[10][6][1], v_listBox[10][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][7][0], v_listBox[10][7][1], v_listBox[10][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][8][0], v_listBox[10][8][1], v_listBox[10][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[10][9][0], v_listBox[10][9][1], v_listBox[10][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][0][0], v_listBox[11][0][1], v_listBox[11][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][1][0], v_listBox[11][1][1], v_listBox[11][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][2][0], v_listBox[11][2][1], v_listBox[11][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][3][0], v_listBox[11][3][1], v_listBox[11][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][4][0], v_listBox[11][4][1], v_listBox[11][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][5][0], v_listBox[11][5][1], v_listBox[11][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][6][0], v_listBox[11][6][1], v_listBox[11][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][7][0], v_listBox[11][7][1], v_listBox[11][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][8][0], v_listBox[11][8][1], v_listBox[11][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[11][9][0], v_listBox[11][9][1], v_listBox[11][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][0][0], v_listBox[12][0][1], v_listBox[12][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][1][0], v_listBox[12][1][1], v_listBox[12][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][2][0], v_listBox[12][2][1], v_listBox[12][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][3][0], v_listBox[12][3][1], v_listBox[12][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][4][0], v_listBox[12][4][1], v_listBox[12][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][5][0], v_listBox[12][5][1], v_listBox[12][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][6][0], v_listBox[12][6][1], v_listBox[12][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][7][0], v_listBox[12][7][1], v_listBox[12][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][8][0], v_listBox[12][8][1], v_listBox[12][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[12][9][0], v_listBox[12][9][1], v_listBox[12][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][0][0], v_listBox[13][0][1], v_listBox[13][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][1][0], v_listBox[13][1][1], v_listBox[13][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][2][0], v_listBox[13][2][1], v_listBox[13][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][3][0], v_listBox[13][3][1], v_listBox[13][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][4][0], v_listBox[13][4][1], v_listBox[13][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][5][0], v_listBox[13][5][1], v_listBox[13][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][6][0], v_listBox[13][6][1], v_listBox[13][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][7][0], v_listBox[13][7][1], v_listBox[13][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][8][0], v_listBox[13][8][1], v_listBox[13][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[13][9][0], v_listBox[13][9][1], v_listBox[13][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][0][0], v_listBox[14][0][1], v_listBox[14][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][1][0], v_listBox[14][1][1], v_listBox[14][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][2][0], v_listBox[14][2][1], v_listBox[14][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][3][0], v_listBox[14][3][1], v_listBox[14][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][4][0], v_listBox[14][4][1], v_listBox[14][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][5][0], v_listBox[14][5][1], v_listBox[14][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][6][0], v_listBox[14][6][1], v_listBox[14][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][7][0], v_listBox[14][7][1], v_listBox[14][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][8][0], v_listBox[14][8][1], v_listBox[14][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[14][9][0], v_listBox[14][9][1], v_listBox[14][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][0][0], v_listBox[15][0][1], v_listBox[15][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][1][0], v_listBox[15][1][1], v_listBox[15][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][2][0], v_listBox[15][2][1], v_listBox[15][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][3][0], v_listBox[15][3][1], v_listBox[15][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][4][0], v_listBox[15][4][1], v_listBox[15][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][5][0], v_listBox[15][5][1], v_listBox[15][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][6][0], v_listBox[15][6][1], v_listBox[15][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][7][0], v_listBox[15][7][1], v_listBox[15][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][8][0], v_listBox[15][8][1], v_listBox[15][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[15][9][0], v_listBox[15][9][1], v_listBox[15][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][0][0], v_listBox[16][0][1], v_listBox[16][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][1][0], v_listBox[16][1][1], v_listBox[16][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][2][0], v_listBox[16][2][1], v_listBox[16][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][3][0], v_listBox[16][3][1], v_listBox[16][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][4][0], v_listBox[16][4][1], v_listBox[16][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][5][0], v_listBox[16][5][1], v_listBox[16][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][6][0], v_listBox[16][6][1], v_listBox[16][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][7][0], v_listBox[16][7][1], v_listBox[16][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][8][0], v_listBox[16][8][1], v_listBox[16][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[16][9][0], v_listBox[16][9][1], v_listBox[16][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][0][0], v_listBox[17][0][1], v_listBox[17][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][1][0], v_listBox[17][1][1], v_listBox[17][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][2][0], v_listBox[17][2][1], v_listBox[17][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][3][0], v_listBox[17][3][1], v_listBox[17][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][4][0], v_listBox[17][4][1], v_listBox[17][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][5][0], v_listBox[17][5][1], v_listBox[17][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][6][0], v_listBox[17][6][1], v_listBox[17][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][7][0], v_listBox[17][7][1], v_listBox[17][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][8][0], v_listBox[17][8][1], v_listBox[17][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[17][9][0], v_listBox[17][9][1], v_listBox[17][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][0][0], v_listBox[18][0][1], v_listBox[18][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][1][0], v_listBox[18][1][1], v_listBox[18][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][2][0], v_listBox[18][2][1], v_listBox[18][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][3][0], v_listBox[18][3][1], v_listBox[18][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][4][0], v_listBox[18][4][1], v_listBox[18][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][5][0], v_listBox[18][5][1], v_listBox[18][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][6][0], v_listBox[18][6][1], v_listBox[18][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][7][0], v_listBox[18][7][1], v_listBox[18][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][8][0], v_listBox[18][8][1], v_listBox[18][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[18][9][0], v_listBox[18][9][1], v_listBox[18][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][0][0], v_listBox[19][0][1], v_listBox[19][0][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][1][0], v_listBox[19][1][1], v_listBox[19][1][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][2][0], v_listBox[19][2][1], v_listBox[19][2][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][3][0], v_listBox[19][3][1], v_listBox[19][3][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][4][0], v_listBox[19][4][1], v_listBox[19][4][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][5][0], v_listBox[19][5][1], v_listBox[19][5][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][6][0], v_listBox[19][6][1], v_listBox[19][6][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][7][0], v_listBox[19][7][1], v_listBox[19][7][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][8][0], v_listBox[19][8][1], v_listBox[19][8][2], 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        color:
                                        Color.fromRGBO(v_listBox[19][9][0], v_listBox[19][9][1], v_listBox[19][9][2], 1),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Expanded( // 상단 우측 다비
                      flex: 6,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 6,
                                child: Container(
                                  // color: Colors.red,
                                  child: Column(
                                      children: [
                                        Expanded(
                                          flex:2,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              '다음 블록',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                          )
                                        ),
                                        Expanded(
                                            flex:5,
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                              color: Colors.white24,
                                               child: Column(
                                                children:[
                                                  Expanded(flex:1,
                                                  child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[0][0][0], v_listN1Box[0][0][1], v_listN1Box[0][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[0][1][0], v_listN1Box[0][1][1], v_listN1Box[0][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[0][2][0], v_listN1Box[0][2][1], v_listN1Box[0][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[0][3][0], v_listN1Box[0][3][1], v_listN1Box[0][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ),),
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[1][0][0], v_listN1Box[1][0][1], v_listN1Box[1][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[1][1][0], v_listN1Box[1][1][1], v_listN1Box[1][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[1][2][0], v_listN1Box[1][2][1], v_listN1Box[1][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[1][3][0], v_listN1Box[1][3][1], v_listN1Box[1][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[2][0][0], v_listN1Box[2][0][1], v_listN1Box[2][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[2][1][0], v_listN1Box[2][1][1], v_listN1Box[2][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[2][2][0], v_listN1Box[2][2][1], v_listN1Box[2][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[2][3][0], v_listN1Box[2][3][1], v_listN1Box[2][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[3][0][0], v_listN1Box[3][0][1], v_listN1Box[3][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[3][1][0], v_listN1Box[3][1][1], v_listN1Box[3][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[3][2][0], v_listN1Box[3][2][1], v_listN1Box[3][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN1Box[3][3][0], v_listN1Box[3][3][1], v_listN1Box[3][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                ]
                                            )
                                          )
                                        )
                                      ],
                                  ),
                                ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                // color: Colors.red,
                                child: Column(
                                  children: [
                                    Expanded(
                                        flex:2,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '다음 블록2',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        flex:5,
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                            color: Colors.white24,
                                            child: Column(
                                                children:[
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[0][0][0], v_listN2Box[0][0][1], v_listN2Box[0][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[0][1][0], v_listN2Box[0][1][1], v_listN2Box[0][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[0][2][0], v_listN2Box[0][2][1], v_listN2Box[0][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[0][3][0], v_listN2Box[0][3][1], v_listN2Box[0][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[1][0][0], v_listN2Box[1][0][1], v_listN2Box[1][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[1][1][0], v_listN2Box[1][1][1], v_listN2Box[1][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[1][2][0], v_listN2Box[1][2][1], v_listN2Box[1][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[1][3][0], v_listN2Box[1][3][1], v_listN2Box[1][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[2][0][0], v_listN2Box[2][0][1], v_listN2Box[2][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[2][1][0], v_listN2Box[2][1][1], v_listN2Box[2][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[2][2][0], v_listN2Box[2][2][1], v_listN2Box[2][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[2][3][0], v_listN2Box[2][3][1], v_listN2Box[2][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                  Expanded(flex:1,
                                                    child: Container(
                                                      child:Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[3][0][0], v_listN2Box[3][0][1], v_listN2Box[3][0][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[3][1][0], v_listN2Box[3][1][1], v_listN2Box[3][1][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[3][2][0], v_listN2Box[3][2][1], v_listN2Box[3][2][2], 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              margin : EdgeInsets.all(1),
                                                              color: Color.fromRGBO(v_listN2Box[3][3][0], v_listN2Box[3][3][1], v_listN2Box[3][3][2], 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),
                                                ]
                                            )
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                //color: Colors.white,
                                margin: EdgeInsets.fromLTRB(0, 50, 5, 0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                    ),
                                    child: Column(
                                        children : [
                                          Expanded(
                                              flex:1,
                                              child: Container(
                                                alignment : Alignment.center,
                                                margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                                  child: Text('레벨', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  decoration: BoxDecoration(color: Colors.yellow),
                                              )
                                          ),
                                          Expanded(
                                              flex:1,
                                              child: Container(
                                                alignment : Alignment.center,
                                                margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                                                child: Text(v_level.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                decoration: BoxDecoration(color: Colors.yellow),
                                              )
                                          ),
                                          SizedBox(height:  2,),
                                          Expanded(
                                              flex:1,
                                              child: Container(
                                                alignment : Alignment.center,
                                                margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                                                child: Text('점수', style: TextStyle( fontWeight: FontWeight.bold)),
                                                decoration: BoxDecoration(color: Colors.yellow),
                                              )
                                          ),
                                          Expanded(
                                              flex:1,
                                              child: Container(
                                                alignment : Alignment.center,
                                                margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                                                child: Text(v_score.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                decoration: BoxDecoration(color: Colors.yellow),
                                              )
                                          ),
                                        ]
                                    )
                                )
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),

                      ),
                    ),

                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.blue,
                child: Row(
                  children: [
                    Expanded(
                      flex: 14,
                      child: Container(
                        color: Colors.pink,
                        child: Column(
                            children:[
                              Container(
                                  child: Expanded(
                                    flex: 1,
                                      child: Row(
                                          children:[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                  color: Colors.green
                                              ),),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                color: Colors.blue,
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    if(v_flagButtonArrow == true){
                                                      press_arrow_rotate();
                                                    }else{
                                                      flutter_toast(0.5, '게임 중이 아닙니다!');
                                                    }
                                                  },
                                                  child: Text('돌리기'),
                                                ),
                                              ),),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                  color: Colors.blue
                                              ),)
                                          ]
                                      ),
                                  ),
                              ),
                              Container(
                                child: Expanded(
                                  flex: 1,
                                  child: Row(
                                      children:[
                                        Expanded(
                                          flex: 1,
                                          child: Container(

                                              color: Colors.green,
                                            child: ElevatedButton(
                                                onPressed: (){
                                                  if(v_flagButtonArrow == true){
                                                    press_arrow_left();
                                                  }else{
                                                    flutter_toast(0.5, '게임 중이 아닙니다!');
                                                  }
                                                },
                                                child: Text('왼쪽'),
                                              ),
                                          ),),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            color: Colors.blue,
                                            child: ElevatedButton(
                                              onPressed: (){
                                                if(v_flagButtonArrow == true){
                                                  press_arrow_down();
                                                }else{
                                                  flutter_toast(0.5, '게임 중이 아닙니다!');
                                                }
                                              },
                                              child: Text('아래'),
                                            ),
                                          ),),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              color: Colors.blue,
                                              child:ElevatedButton(
                                              onPressed: (){
                                                if(v_flagButtonArrow==true){
                                                  press_arrow_right();
                                                }else{
                                                  flutter_toast(0.5, '게임 중이 아닙니다!');
                                                }
                                              },
                                          child: Text('오른쪽'),
                                        ),
                                          ),)
                                      ]
                                  ),
                                ),
                              ),

                              
                            ],
                        ),

                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.amber,
                          child: ElevatedButton(
                              onPressed: (){
                                if(v_flagButtonPlay == true){
                                  press_play();
                                }else{
                                  flutter_toast(1, '시작안함!');
                                }
                              },
                            child:Text('게임시작'),
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 63,
      ),
    );
  }

  void press_arrow_rotate(){
    if(v_lineMove <= v_listN0Box[0][0][0]){
      return;
    }

    for (i=0 ;i<v_rowNext;i++){
      for(j=0; j < 3;j++){
        v_listMove[i][j] = 0;
      }
    }

    int _color_R = 0;
    int _color_G = 0;
    int _color_B = 0;

    for(i = v_lineMove; i>0 ; i--){
      for(j=0 ; j< v_colBox ;j++){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr-1] ==0 ){
          _color_R = v_listBox[i-1][j][0];
          _color_G = v_listBox[i-1][j][1];
          _color_B = v_listBox[i-1][j][2];

          for(ii = 0;ii<v_rowNext; ii++){
            if(v_listMove[ii][0] + v_listMove[ii][1] == 0){
              v_listMove[ii][0] = i-1;
              v_listMove[ii][1] = j-0;
              break;
            }
          }
        }
      }
    }

    num _sum_h = 0;
    num _sum_v = 0;
    num _avr_h = 0;
    num _avr_v = 0;

    for(ii = 0 ; ii < v_rowNext;ii++){
      _sum_h = _sum_h + v_listMove[ii][0];
      _sum_v = _sum_v + v_listMove[ii][1];
    }
    _avr_h = _sum_h / v_rowNext;
    _avr_v = _sum_v / v_colNext;

    for(ii = 0;ii<v_rowNext;ii++){
      v_listMove[ii][2] = (((_avr_h - v_listMove[ii][0]).abs() + (_avr_v - v_listMove[ii][1]).abs())*100).toInt();

    }
    int _center = 0;
    for(ii =0;ii<v_rowNext - 1;ii++){
      if(v_listMove[_center][2] > v_listMove[ii+1][2]){
        _center = ii + 1;
      }
    }
    if(v_listMove[0][2] == v_listMove[1][2] &&
        v_listMove[1][2] == v_listMove[2][2] &&
        v_listMove[2][2] == v_listMove[3][2]){
      return;
    }
    for(ii = 0 ; ii<v_rowNext ;ii++){
      if(ii == _center){
        v_listMoveTarget[ii][0] = v_listMove[ii][0];
        v_listMoveTarget[ii][1] = v_listMove[ii][1];
      }else if(v_listMove[_center][0] == v_listMove[ii][0]){

        v_listMoveTarget[ii][0] =
            v_listMove[_center][0] - v_listMove[_center][1] + v_listMove[ii][1];
        v_listMoveTarget[ii][1] = v_listMove[_center][1];
      }else if(v_listMove[_center][1] == v_listMove[ii][1]){

        v_listMoveTarget[ii][0] = v_listMove[_center][0];
        v_listMoveTarget[ii][1] = v_listMove[_center][1] + v_listMove[_center][0] - v_listMove[ii][0];


      }else if((v_listMove[_center][0] > v_listMove[ii][0] &&
          v_listMove[_center][1] > v_listMove[ii][1]) ||
          (v_listMove[_center][0] < v_listMove[ii][0] &&
              v_listMove[_center][1] < v_listMove[ii][1])){

        v_listMoveTarget[ii][0] = v_listMove[ii][0];
        v_listMoveTarget[ii][1] = v_listMove[_center][1] + v_listMove[_center][1] - v_listMove[ii][1];

      }else{
        v_listMoveTarget[ii][0] = v_listMove[_center][0] + v_listMove[_center][0] - v_listMove[ii][0];
        v_listMoveTarget[ii][1] = v_listMove[ii][1];
      }
    }

    for(ii = 0; ii< v_rowNext; ii++){
      if(v_listBox[v_listMoveTarget[ii][0]][v_listMoveTarget[ii][1]][4] == 1){
        return;
      }
      if(v_listMoveTarget[ii][0] < 0 || v_listMoveTarget[ii][0] > v_rowBox - 1 || v_listMoveTarget[ii][1]<0 || v_listMoveTarget[ii][1]> v_colBox - 1){
        return;
      }
    }

    for (ii=0;ii<v_rowNext;ii++){
      for(k=0;k<v_atr;k++){
        v_listBox[v_listMove[ii][0]][v_listMove[ii][1]][k] =0;
      }
    }

    for(ii=0;ii<v_rowNext;ii++){
      v_listBox[v_listMoveTarget[ii][0]][v_listMoveTarget[ii][1]][0] = _color_R;
      v_listBox[v_listMoveTarget[ii][0]][v_listMoveTarget[ii][1]][1] = _color_G;
      v_listBox[v_listMoveTarget[ii][0]][v_listMoveTarget[ii][1]][2] = _color_B;
      v_listBox[v_listMoveTarget[ii][0]][v_listMoveTarget[ii][1]][3] = 1;
      v_listBox[v_listMoveTarget[ii][0]][v_listMoveTarget[ii][1]][4] = 0;
    }
    setState(() {

    });

    switch (v_listN0Box[0][0][0]){
      case 1:
        v_listN0Box[0][0][0] = 4;
        break;
      case 2:
        v_listN0Box[0][0][0] = 3;
        break;
      case 3:
        v_listN0Box[0][0][0] = 2;
        break;
      case 4:
        v_listN0Box[0][0][0] = 1;
        break;
    }
    for(i=v_rowBox-1; i>0;i--){
      for(j=0; j<v_colBox;j++){
        if(v_listBox[i][j][v_atr-2] == 1 && v_listBox[i][j][v_atr - 1] == 0){
          v_lineMove = i+1;
          return;
        }
      }
    }
  }

  void press_arrow_down(){
    if(v_lineMove >= v_listN0Box[0][0][0]){
      while(v_flagNext == false){
        step_lineDown_listBox();
      }
      setState(() {

      });
    }
  }
  void press_arrow_right(){
    if(v_lineMove <= v_listN0Box[0][0][0]){
      return;
    }

    for(j= v_colBox-1;j>=0;j--){
      for(i = v_lineMove; i>0; i--){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr-1] ==0){
          if(j==9) return;
          if(v_listBox[i-1][j+1][v_atr-1] == 1) return;
        }
      }
    }

    for(j= v_colBox-1; j>=0 ; j--){
      for(i = v_lineMove; i>0; i--){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr-1] ==0){
          for(k=0;k<v_atr;k++){
            v_listBox[i-1][j+1][k] = v_listBox[i-1][j][k];
            v_listBox[i-1][j][k] = 0;
          }
        }
      }
    }
    setState(() {

    });

  }

  void press_arrow_left(){
    if(v_lineMove <= v_listN0Box[0][0][0]){
      return;
    }

    for(j= 0;j < v_colBox;j++){
      for(i = v_lineMove; i>0; i--){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr-1] ==0){
          if(j==0) return;
          if(v_listBox[i-1][j-1][v_atr-1] == 1) return;
        }
      }
    }

    for(j= 1; j < v_colBox ; j++){
      for(i = v_lineMove; i>0; i--){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr-1] ==0){
          for(k=0;k<v_atr;k++){
            v_listBox[i-1][j-1][k] = v_listBox[i-1][j][k];
            v_listBox[i-1][j][k] = 0;
          }
        }
      }
    }
    setState(() {

    });

  }

  void press_play(){
    v_flagButtonPlay = false;
    v_flagButtonStop = true;
    v_flagButtonPause = true;
    v_flagButtonArrow = true;

    step_initial();
    step_initial_next1();
    step_initial_next2();

    setState(() {

    });

    v_timeInterval = v_timeInterval_base - ((v_level - 1) * 50);
    v_timeInterval < 50 ? 50: v_timeInterval;
    step_timer();
  }

  void step_timer(){
    _timer = Timer.periodic(Duration(milliseconds: v_timeInterval), (_timer) {
      //step_create_Next();

      if(v_flagNext == true){
        step_create_Next();
        v_flagNext = false;
      }else{
        step_lineDown_listBox();
      }

      step_get_listNBox();
      setState(() {

      });
    });
  }

  void step_create_Next(){
    for(i =0;i< v_rowNext;i++){
      for (j=0;j<v_colNext;j++){
        for(k=0;k<v_atr;k++){
          v_listN0Box[i][j][k] = v_listN1Box[i][j][k];
        }
      }
    }

    for(i =0;i< v_rowNext;i++){
      for (j=0;j<v_colNext;j++){
        for(k=0;k<v_atr;k++){
          v_listN1Box[i][j][k] = v_listN2Box[i][j][k];
        }
      }
    }
    step_initial_next2();

    v_lineNext=1;
    v_lineMove = 1;
    v_countItem++;
    v_score = v_score + 10;

  }

  void step_get_listNBox(){
    if(v_listN0Box[0][0][0] >= v_lineNext){
      for(i =0;i< v_colNext;i++){
        for (j=0;j<v_atr;j++){
          v_listBox[0][i+3][j] = v_listN0Box[v_rowNext - v_lineNext][i][j];
        }
      }
      v_lineNext++;
    }
  }

  void step_initial(){
    v_flagNext = true;
    v_countItem = 0;
    if(v_flagStartGame == true){
      v_level = 1;
      v_score = 0;
      v_flagStartGame = false;
    }else{
      v_level++;
    }

    for(i =0;i< v_rowBox;i++){
      for (j=0;j<v_colBox;j++){
        for(k=0;k<v_atr;k++){
          v_listBox[i][j][k] = 0;
        }
      }
    }
  }

  void step_initial_next1(){
    if(v_listN2Box[0][0][0] == 0){
      v_itemNo = Random().nextInt(16);
      for(i =0;i< v_rowNext;i++){
        for (j=0;j<v_colNext;j++){
          for(k=0;k<v_atr;k++){
            v_listN1Box[i][j][k] = v_listItem[v_itemNo][i][j][k];
          }
        }
      }
    }else{
      for(i =0;i< v_rowNext;i++){
        for (j=0;j<v_colNext;j++){
          for(k=0;k<v_atr;k++){
            v_listN1Box[i][j][k] = v_listN2Box[i][j][k];
          }
        }
      }
    }
  }

  void step_initial_next2(){
    v_itemNo = Random().nextInt(16);

    for(i =0;i< v_rowNext;i++){
      for (j=0;j<v_colNext;j++){
        for(k=0;k<v_atr;k++){
          v_listN2Box[i][j][k] = v_listItem[v_itemNo][i][j][k];
        }
      }
    }
  }

  void step_lineDown_listBox(){
    if(v_lineMove >= v_rowBox){
      step_lineFix_listBox();
      v_flagNext = true;
      return;
    }

    for (i = v_lineMove;i>0;i--){
      for(j=0;j<v_colBox;j++){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr - 1] == 0){
          if(v_listBox[i][j][v_atr-1] == 1){
            step_lineFix_listBox();
            v_flagNext = true;
            return;
          }
        }
      }
    }

    for (i = v_lineMove;i>0;i--){
      for(j=0;j<v_colBox;j++){
        if(v_listBox[i-1][j][v_atr-2] == 1 && v_listBox[i-1][j][v_atr - 1] == 0){
          for(k=0;k<v_atr;k++){
            v_listBox[i][j][k] = v_listBox[i-1][j][k];
            v_listBox[i-1][j][k] = 0;
          }
        }
      }
    }
    v_lineMove++;
  }
  void step_lineFix_listBox(){
    for(i=v_lineMove;i>0;i--){
      for(j=0;j<v_colBox;j++){
        if(v_listBox[i-1][j][v_atr-2] ==1 ){
          v_listBox[i-1][j][v_atr-1] =1;
        }
      }
    }
  }

  @override
  void dispose(){
    _player.stop();
    _playerLoop.stop();
    _player.dispose();
    _playerLoop.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    // [아이템 번호][세로][가로][특성]
    // ---- <- 모양

    v_listItem[0][0][0][0] = 4;
    v_listItem[0][0][1][0] = 255;
    v_listItem[0][0][1][1] = 0;
    v_listItem[0][0][1][2] = 0;
    v_listItem[0][0][1][3] = 1;
    v_listItem[0][1][1][0] = 255;
    v_listItem[0][1][1][1] = 0;
    v_listItem[0][1][1][2] = 0;
    v_listItem[0][1][1][3] = 1;
    v_listItem[0][2][1][0] = 255;
    v_listItem[0][2][1][1] = 0;
    v_listItem[0][2][1][2] = 0;
    v_listItem[0][2][1][3] = 1;
    v_listItem[0][3][1][0] = 255;
    v_listItem[0][3][1][1] = 0;
    v_listItem[0][3][1][2] = 0;
    v_listItem[0][3][1][3] = 1;

    // --
    //   --   <- 모양

    v_listItem[1][0][0][0] = 2;
    v_listItem[1][2][0][0] = 255;
    v_listItem[1][2][0][1] = 228;
    v_listItem[1][2][0][2] = 0;
    v_listItem[1][2][0][3] = 1;
    v_listItem[1][2][1][0] = 255;
    v_listItem[1][2][1][1] = 228;
    v_listItem[1][2][1][2] = 0;
    v_listItem[1][2][1][3] = 1;
    v_listItem[1][3][1][0] = 255;
    v_listItem[1][3][1][1] = 228;
    v_listItem[1][3][1][2] = 0;
    v_listItem[1][3][1][3] = 1;
    v_listItem[1][3][2][0] = 255;
    v_listItem[1][3][2][1] = 228;
    v_listItem[1][3][2][2] = 0;
    v_listItem[1][3][2][3] = 1;

    // ---
    //  -   <- 모양
    v_listItem[2][0][0][0] = 2;
    v_listItem[2][2][0][0] = 29;
    v_listItem[2][2][0][1] = 219;
    v_listItem[2][2][0][2] = 22;
    v_listItem[2][2][0][3] = 1;
    v_listItem[2][2][1][0] = 29;
    v_listItem[2][2][1][1] = 219;
    v_listItem[2][2][1][2] = 22;
    v_listItem[2][2][1][3] = 1;
    v_listItem[2][3][1][0] = 29;
    v_listItem[2][3][1][1] = 219;
    v_listItem[2][3][1][2] = 22;
    v_listItem[2][3][1][3] = 1;
    v_listItem[2][3][2][0] = 29;
    v_listItem[2][3][2][1] = 219;
    v_listItem[2][3][2][2] = 22;
    v_listItem[2][3][2][3] = 1;

    //   -
    // ---  <- 모양

    v_listItem[3][0][0][0] = 3;
    v_listItem[3][2][0][0] = 76;
    v_listItem[3][2][0][1] = 76;
    v_listItem[3][2][0][2] = 76;
    v_listItem[3][2][0][3] = 1;
    v_listItem[3][2][1][0] = 76;
    v_listItem[3][2][1][1] = 76;
    v_listItem[3][2][1][2] = 76;
    v_listItem[3][2][1][3] = 1;
    v_listItem[3][3][1][0] = 76;
    v_listItem[3][3][1][1] = 76;
    v_listItem[3][3][1][2] = 76;
    v_listItem[3][3][1][3] = 1;
    v_listItem[3][3][2][0] = 76;
    v_listItem[3][3][2][1] = 76;
    v_listItem[3][3][2][2] = 76;
    v_listItem[3][3][2][3] = 1;

    // ---- <- 모양

    v_listItem[4][0][0][0] = 1;
    v_listItem[4][2][0][0] = 171;
    v_listItem[4][2][0][1] = 242;
    v_listItem[4][2][0][2] = 0;
    v_listItem[4][2][0][3] = 1;
    v_listItem[4][2][1][0] = 171;
    v_listItem[4][2][1][1] = 242;
    v_listItem[4][2][1][2] = 0;
    v_listItem[4][2][1][3] = 1;
    v_listItem[4][3][1][0] = 171;
    v_listItem[4][3][1][1] = 242;
    v_listItem[4][3][1][2] = 0;
    v_listItem[4][3][1][3] = 1;
    v_listItem[4][3][2][0] = 171;
    v_listItem[4][3][2][1] = 242;
    v_listItem[4][3][2][2] = 0;
    v_listItem[4][3][2][3] = 1;

    // --
    // -- -< 모양

    v_listItem[5][0][0][0] = 2;
    v_listItem[5][2][0][0] = 95;
    v_listItem[5][2][0][1] = 0;
    v_listItem[5][2][0][2] = 255;
    v_listItem[5][2][0][3] = 1;
    v_listItem[5][2][1][0] = 95;
    v_listItem[5][2][1][1] = 0;
    v_listItem[5][2][1][2] = 255;
    v_listItem[5][2][1][3] = 1;
    v_listItem[5][3][1][0] = 95;
    v_listItem[5][3][1][1] = 0;
    v_listItem[5][3][1][2] = 255;
    v_listItem[5][3][1][3] = 1;
    v_listItem[5][3][2][0] = 95;
    v_listItem[5][3][2][1] = 0;
    v_listItem[5][3][2][2] = 255;
    v_listItem[5][3][2][3] = 1;

    //  -
    // --
    //  - <- 모양

    v_listItem[6][0][0][0] = 3;
    v_listItem[6][2][0][0] = 0;
    v_listItem[6][2][0][1] = 84;
    v_listItem[6][2][0][2] = 255;
    v_listItem[6][2][0][3] = 1;
    v_listItem[6][2][1][0] = 0;
    v_listItem[6][2][1][1] = 84;
    v_listItem[6][2][1][2] = 255;
    v_listItem[6][2][1][3] = 1;
    v_listItem[6][3][1][0] = 0;
    v_listItem[6][3][1][1] = 84;
    v_listItem[6][3][1][2] = 255;
    v_listItem[6][3][1][3] = 1;
    v_listItem[6][3][2][0] = 0;
    v_listItem[6][3][2][1] = 84;
    v_listItem[6][3][2][2] = 255;
    v_listItem[6][3][2][3] = 1;

    // ---
    // -     <- 모양

    v_listItem[7][0][0][0] = 2;
    v_listItem[7][2][0][0] = 255;
    v_listItem[7][2][0][1] = 94;
    v_listItem[7][2][0][2] = 0;
    v_listItem[7][2][0][3] = 1;
    v_listItem[7][2][1][0] = 255;
    v_listItem[7][2][1][1] = 94;
    v_listItem[7][2][1][2] = 0;
    v_listItem[7][2][1][3] = 1;
    v_listItem[7][3][1][0] = 255;
    v_listItem[7][3][1][1] = 94;
    v_listItem[7][3][1][2] = 0;
    v_listItem[7][3][1][3] = 1;
    v_listItem[7][3][2][0] = 255;
    v_listItem[7][3][2][1] = 94;
    v_listItem[7][3][2][2] = 0;
    v_listItem[7][3][2][3] = 1;


    //  -
    // ---

    v_listItem[8][0][0][0] = 2;
    v_listItem[8][2][0][0] = 255;
    v_listItem[8][2][0][1] = 187;
    v_listItem[8][2][0][2] = 0;
    v_listItem[8][2][0][3] = 1;
    v_listItem[8][2][1][0] = 255;
    v_listItem[8][2][1][1] = 187;
    v_listItem[8][2][1][2] = 0;
    v_listItem[8][2][1][3] = 1;
    v_listItem[8][3][1][0] = 255;
    v_listItem[8][3][1][1] = 187;
    v_listItem[8][3][1][2] = 0;
    v_listItem[8][3][1][3] = 1;
    v_listItem[8][3][2][0] = 255;
    v_listItem[8][3][2][1] = 187;
    v_listItem[8][3][2][2] = 0;
    v_listItem[8][3][2][3] = 1;


    //  --
    // --

    v_listItem[9][0][0][0] = 2;
    v_listItem[9][2][0][0] = 0;
    v_listItem[9][2][0][1] = 216;
    v_listItem[9][2][0][2] = 255;
    v_listItem[9][2][0][3] = 1;
    v_listItem[9][2][1][0] = 0;
    v_listItem[9][2][1][1] = 216;
    v_listItem[9][2][1][2] = 255;
    v_listItem[9][2][1][3] = 1;
    v_listItem[9][3][1][0] = 0;
    v_listItem[9][3][1][1] = 216;
    v_listItem[9][3][1][2] = 255;
    v_listItem[9][3][1][3] = 1;
    v_listItem[9][3][2][0] = 0;
    v_listItem[9][3][2][1] = 216;
    v_listItem[9][3][2][2] = 255;
    v_listItem[9][3][2][3] = 1;

    // -
    // --
    // -

    v_listItem[10][0][0][0] = 3;
    v_listItem[10][2][0][0] = 200;
    v_listItem[10][2][0][1] = 200;
    v_listItem[10][2][0][2] = 200;
    v_listItem[10][2][0][3] = 1;
    v_listItem[10][2][1][0] = 200;
    v_listItem[10][2][1][1] = 200;
    v_listItem[10][2][1][2] = 200;
    v_listItem[10][2][1][3] = 1;
    v_listItem[10][3][1][0] = 200;
    v_listItem[10][3][1][1] = 200;
    v_listItem[10][3][1][2] = 200;
    v_listItem[10][3][1][3] = 1;
    v_listItem[10][3][2][0] = 200;
    v_listItem[10][3][2][1] = 200;
    v_listItem[10][3][2][2] = 200;
    v_listItem[10][3][2][3] = 1;

    // -
    // ---

    v_listItem[11][0][0][0] = 2;
    v_listItem[11][2][0][0] = 191;
    v_listItem[11][2][0][1] = 33;
    v_listItem[11][2][0][2] = 243;
    v_listItem[11][2][0][3] = 1;
    v_listItem[11][2][1][0] = 191;
    v_listItem[11][2][1][1] = 33;
    v_listItem[11][2][1][2] = 254;
    v_listItem[11][2][1][3] = 1;
    v_listItem[11][3][1][0] = 191;
    v_listItem[11][3][1][1] = 33;
    v_listItem[11][3][1][2] = 243;
    v_listItem[11][3][1][3] = 1;
    v_listItem[11][3][2][0] = 191;
    v_listItem[11][3][2][1] = 33;
    v_listItem[11][3][2][2] = 243;
    v_listItem[11][3][2][3] = 1;

    // --
    // --

    v_listItem[12][0][0][0] = 2;
    v_listItem[12][2][0][0] = 243;
    v_listItem[12][2][0][1] = 72;
    v_listItem[12][2][0][2] = 33;
    v_listItem[12][2][0][3] = 1;
    v_listItem[12][2][1][0] = 243;
    v_listItem[12][2][1][1] = 72;
    v_listItem[12][2][1][2] = 33;
    v_listItem[12][2][1][3] = 1;
    v_listItem[12][3][1][0] = 243;
    v_listItem[12][3][1][1] = 72;
    v_listItem[12][3][1][2] = 33;
    v_listItem[12][3][1][3] = 1;
    v_listItem[12][3][2][0] = 243;
    v_listItem[12][3][2][1] = 72;
    v_listItem[12][3][2][2] = 33;
    v_listItem[12][3][2][3] = 1;

    // -
    // -
    // --

    v_listItem[13][0][0][0] = 3;
    v_listItem[13][2][0][0] = 33;
    v_listItem[13][2][0][1] = 243;
    v_listItem[13][2][0][2] = 225;
    v_listItem[13][2][0][3] = 1;
    v_listItem[13][2][1][0] = 33;
    v_listItem[13][2][1][1] = 243;
    v_listItem[13][2][1][2] = 225;
    v_listItem[13][2][1][3] = 1;
    v_listItem[13][3][1][0] = 33;
    v_listItem[13][3][1][1] = 243;
    v_listItem[13][3][1][2] = 225;
    v_listItem[13][3][1][3] = 1;
    v_listItem[13][3][2][0] = 33;
    v_listItem[13][3][2][1] = 243;
    v_listItem[13][3][2][2] = 225;
    v_listItem[13][3][2][3] = 1;

    // -
    // --
    //  -

    v_listItem[14][0][0][0] = 3;
    v_listItem[14][2][0][0] = 215;
    v_listItem[14][2][0][1] = 243;
    v_listItem[14][2][0][2] = 33;
    v_listItem[14][2][0][3] = 1;
    v_listItem[14][2][1][0] = 215;
    v_listItem[14][2][1][1] = 243;
    v_listItem[14][2][1][2] = 33;
    v_listItem[14][2][1][3] = 1;
    v_listItem[14][3][1][0] = 215;
    v_listItem[14][3][1][1] = 243;
    v_listItem[14][3][1][2] = 33;
    v_listItem[14][3][1][3] = 1;
    v_listItem[14][3][2][0] = 215;
    v_listItem[14][3][2][1] = 243;
    v_listItem[14][3][2][2] = 33;
    v_listItem[14][3][2][3] = 1;

    //  -
    // --
    // -
    v_listItem[15][0][0][0] = 3;
    v_listItem[15][2][0][0] = 243;
    v_listItem[15][2][0][1] = 33;
    v_listItem[15][2][0][2] = 239;
    v_listItem[15][2][0][3] = 1;
    v_listItem[15][2][1][0] = 243;
    v_listItem[15][2][1][1] = 33;
    v_listItem[15][2][1][2] = 239;
    v_listItem[15][2][1][3] = 1;
    v_listItem[15][3][1][0] = 243;
    v_listItem[15][3][1][1] = 33;
    v_listItem[15][3][1][2] = 239;
    v_listItem[15][3][1][3] = 1;
    v_listItem[15][3][2][0] = 243;
    v_listItem[15][3][2][1] = 33;
    v_listItem[15][3][2][2] = 239;
    v_listItem[15][3][2][3] = 1;

  }

  void flutter_toast(_toasttime, _toastMsg){
    Fluttertoast.showToast(
        msg:_toastMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: _toasttime,
      backgroundColor: Colors.limeAccent,
      textColor: Colors.black87,
      fontSize: 18.0,
    );
  }

  final _player = AudioPlayer();
  Future audioPlayer(parm_mp3) async{
    await _player.setAsset(parm_mp3);
    _player.play();
  }

  final _playerLoop = AudioPlayer();
  Future audioPlayerLoop(parm_mp3) async {
    await _playerLoop.setLoopMode(LoopMode.one);
    await _playerLoop.setAsset(parm_mp3);
    _playerLoop.play();
  }
}


