import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../db/model/Team.dart';

class AddEditTeam extends StatefulWidget {
  final Team? team;

  AddEditTeam({this.team});

  @override
  _AddEditTeamState createState() => _AddEditTeamState();
}

class _AddEditTeamState extends State<AddEditTeam> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _name = '';
  String _firstPilot = '';
  String _secondPilot = '';
  String _motor = '';
  String _country = '';

  @override
  void initState() {
    super.initState();
    if (widget.team != null) {
      _name = widget.team!.name;
      _firstPilot = widget.team!.firstPilot;
      _secondPilot = widget.team!.secondPilot;
      _motor = widget.team!.motor;
      _country = widget.team!.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team == null ? 'Adicionar Equipe' : 'Editar Equipe'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _firstPilot,
                decoration: InputDecoration(labelText: 'Primeiro Piloto'),
                onSaved: (value) => _firstPilot = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _secondPilot,
                decoration: InputDecoration(labelText: 'Segundo Piloto'),
                onSaved: (value) => _secondPilot = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _motor,
                decoration: InputDecoration(labelText: 'Motor'),
                onSaved: (value) => _motor = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _country,
                decoration: InputDecoration(labelText: 'País'),
                onSaved: (value) => _country = value!,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTeam,
                child: Text(widget.team == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTeam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        DatabaseReference teamsRef = FirebaseDatabase.instance.ref().child('teams');
        if (widget.team == null) {
          String newTeamId = teamsRef.push().key!;
          Team newTeam = Team.withId(
            newTeamId,
            _name,
            _firstPilot,
            _secondPilot,
            _motor,
            _country,
          );
          await teamsRef.child(newTeamId).set(newTeam.toMap());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Equipe adicionada com sucesso"),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          Team updatedTeam = Team.withId(
            widget.team!.id!,
            _name,
            _firstPilot,
            _secondPilot,
            _motor,
            _country,
          );
          await teamsRef.child(updatedTeam.id!).set(updatedTeam.toMap());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Equipe editada com sucesso"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar a equipe"),
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }
}