import 'dart:math';
import 'package:f1_team/db/model/Team.dart';
import 'package:f1_team/ui/addEditTeam.dart';
import 'package:flutter/material.dart';
import '../db/util/dbHelper.dart';

class ListTeams extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListTeamsState();
}

class _ListTeamsState extends State<ListTeams> {
  DbHelper helper = DbHelper();
  List<Team>? teams;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await helper.initializeDb();
    List<Map<String, dynamic>> result = (await helper.getTeams()).cast<Map<String, dynamic>>();

    List<Team> teamList = [];
    setState(() {
      count = result.length;
      for (int i = 0; i < count; i++) {
        teamList.add(Team.fromMap(result[i]));
        debugPrint(teamList[i].name);
      }
      teams = teamList;
      debugPrint("Items $count");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (teams == null) {
      teams = [];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Equipes F1',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: teamListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddEditTeam();
          }));
          getData();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }

  ListView teamListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white70,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getRandomColor(),
            ),
            title: Text('${this.teams![position].name} (${this.teams![position].country})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.teams![position].motor),
                Text('${this.teams![position].fistPilot} / ${this.teams![position].secondPilot}'),
              ],
            ),
            onTap: () {
              _showOptionsDialog(position);
            },
          ),
        );
      },
    );
  }

  void _showOptionsDialog(int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ações'),
          content: Text('Selecione uma ação para ${teams![position].name}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddEditTeam(team: teams![position]);
                })).then((_) {
                  getData();
                });
              },
              child: Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTeam(position);
              },
              child: Text('Deletar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTeam(int position) async {
    await helper.deleteTeam(teams![position].id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Deletando ${teams![position].name}"),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      teams!.removeAt(position);
      count--;
    });
  }
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}