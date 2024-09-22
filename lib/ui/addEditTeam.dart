import 'package:flutter/material.dart';
import '../db/model/Team.dart';
import '../db/util/dbHelper.dart';

class AddEditTeam extends StatefulWidget {
  final Team? team; // Adiciona uma propriedade para a equipe

  AddEditTeam({this.team}); // Modifica o construtor

  @override
  _AddEditTeamState createState() => _AddEditTeamState();
}

class _AddEditTeamState extends State<AddEditTeam> {
  DbHelper helper = DbHelper();

  final _formKey = GlobalKey<FormState>();
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
      _firstPilot = widget.team!.fistPilot;
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
      body: Padding(
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

      if (widget.team == null) {
        Team newTeam = Team(_name, _firstPilot, _secondPilot, _motor, _country);
        int result = await helper.insertTeam(newTeam);
        debugPrint("Equipe adicionada com ID: $result");
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
        await helper.updateTeam(updatedTeam);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Equipe editada com sucesso"),
            duration: Duration(seconds: 2),
          ),
        );
      }

      Navigator.pop(context);
    }
  }
}