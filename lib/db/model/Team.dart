class Team {
  int? _id;
  String _name;
  String _fistPilot;
  String _secondPilot;
  String _motor;
  String _country;

  Team(this._name, this._fistPilot, this._secondPilot, this._motor,
      this._country);

  Team.withId(this._id, this._name, this._fistPilot, this._secondPilot,
      this._motor, this._country);

// Getters...
  String get name => _name;

  String get fistPilot => _fistPilot;

  String get secondPilot => _secondPilot;

  String get motor => _motor;

  String get country => _country;


  int? get id => _id;

// Setters...
  set name(String newName) {
    if (newName.length <= 255) {
      _name = newName;
    }
  }

  set fistPilot(String newFistPilot) {
    if (newFistPilot.length <= 255) {
      _fistPilot = newFistPilot;
    }
  }

  set secondPilot(String newSecondPilot) {
    if (newSecondPilot.length <= 255) {
      _secondPilot = newSecondPilot;
    }
  }

  set motor(String newMotor) {
    if (newMotor.length <= 255) {
      _motor = newMotor;
    }
  }

  set country(String newCountry) {
    if (newCountry.length <= 255) {
      _country = newCountry;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["fistPilot"] = _fistPilot;
    map["secondPilot"] = _secondPilot;
    map["motor"] = _motor;
    map["country"] = _country;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Team.fromMap(dynamic o)
      : _id = o["id"],
        _name = o["name"],
        _fistPilot = o["fistPilot"],
        _secondPilot = o["secondPilot"],
        _motor = o["motor"],
        _country = o["country"];
}
