class Team {
  String? id;
  String name;
  String firstPilot;
  String secondPilot;
  String motor;
  String country;

  Team(this.name, this.firstPilot, this.secondPilot, this.motor, this.country);

  Team.withId(this.id, this.name, this.firstPilot, this.secondPilot, this.motor, this.country);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'firstPilot': firstPilot,
      'secondPilot': secondPilot,
      'motor': motor,
      'country': country,
    };
  }

  factory Team.fromMap(Map<dynamic, dynamic> map) {
    return Team(
      map['name'],
      map['firstPilot'],
      map['secondPilot'],
      map['motor'],
      map['country'],
    )..id = map['id'];
  }
}