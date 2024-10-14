import 'package:f1_team/ui/listTeams.dart';
import 'package:flutter/material.dart';
import 'db/model/Team.dart';
import 'db/util/dbHelper.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    DbHelper helper = DbHelper();

    Team team = Team("Ferrari", "Charles Leclerc", "Carlos Sainz Jr.", "Ferrari", "Itália");
    Future id = helper.insertTeam(team);
    id.then( (value) => debugPrint(value.toString()) );

    team = Team("Aston Martin", "Fernando Alonso", "Lance Stroll", "Mercedes", "Reino Unido");
    Future id2 = helper.insertTeam(team);
    id2.then( (value) => debugPrint(value.toString()) );

    team = Team("McLaren", "Lando Norris", "Oscar Piastri", "Mercedes", "Reino Unido");
    Future id3 = helper.insertTeam(team);
    id3.then( (value) => debugPrint(value.toString()) );


    return MaterialApp(
      title: 'Equipes Formula 1',
      home: ListTeams(),
    );
  }
}