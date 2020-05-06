class TripModel {
  int id;
  String departure;
  String depDate;
  String depTime;
  String tripType;
  String arrival;
  String arriDate;
  String arriTime;

  static final columns = [
    "id",
    "departure",
    "depDate",
    "depTime",
    "tripType",
    "arrival",
    "arriDate",
    "arriTime"
  ];

  TripModel(
      {this.id,
      this.departure,
      this.depDate,
      this.depTime,
      this.tripType,
      this.arrival,
      this.arriDate,
      this.arriTime});

  factory TripModel.fromMap(Map<String, dynamic> data) => new TripModel(
      departure: data["departure"],
      depDate: data["depDate"],
      depTime: data["depTime"],
      tripType: data["tripType"],
      arrival: data["arrival"],
      arriDate: data["arriDate"],
      arriTime: data["arriTime"]);

  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map['id'] = id;
    map['departure'] = departure;
    map['depDate'] = depDate;
    map['depTime'] = depTime;
    map['tripType'] = tripType;
    map['arrival'] = arrival;
    map['arriDate'] = arriDate;
    map['arriTime'] = arriTime;
    return map;
  }

  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map['departure'] = departure;
    map['depDate'] = depDate;
    map['depTime'] = depTime;
    map['tripType'] = tripType;
    map['arrival'] = arrival;
    map['arriDate'] = arriDate;
    map['arriTime'] = arriTime;
    return map;
  }
}
