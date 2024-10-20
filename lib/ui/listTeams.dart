import 'dart:math';
import 'package:f1_team/db/model/Team.dart';
import 'package:f1_team/ui/addEditTeam.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ListTeams extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListTeamsState();
}

class _ListTeamsState extends State<ListTeams> {
  List<Team>? teams;
  int count = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      DatabaseReference teamsRef = FirebaseDatabase.instance.ref().child('teams');

      teamsRef.once().then((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          List<Team> teamList = [];
          data.forEach((key, value) {
            Team team = Team.fromMap(value)..id = key;
            teamList.add(team);
          });
          setState(() {
            teams = teamList;
            count = teamList.length;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      print('Erro ao buscar equipes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : teamListItems(),
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
                Text('${this.teams![position].firstPilot} / ${this.teams![position].secondPilot}'),
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
                Navigator.pop(context);
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
    AlertDialog(
        title: Text('Ações'),
        content: Text('Selecionado ${position}')
    );
    if (teams == null || position < 0 || position >= teams!.length) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: Equipe não encontrada"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String teamId = teams![position].id!;
    print('Tentando deletar a equipe com ID: $teamId');

    DatabaseReference teamRef = FirebaseDatabase.instance.ref().child('teams/$teamId');

    try {
      await teamRef.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Equipe deletada com sucesso"),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        teams!.removeAt(position);
        count--;
      });
    } catch (error) {
      print('Erro ao deletar a equipe: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao deletar a equipe"),
          duration: Duration(seconds: 2),
        ),
      );
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
}