class Weather {
  const Weather({
    required this.location,
    required this.current,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      current: Data.fromJson(json['current'] as Map<String, dynamic>),
    );
  }

  final Location location;
  final Data current;
}

class Location {
  const Location({
    required this.name,
    required this.region,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
    );
  }

  final String name;
  final String region;
  final String country;
}

class Data {
  const Data({
    required this.tempC,
    required this.condition,
    required this.feelsLikeC,
    required this.humidity,
    required this.windKph,
    required this.uv,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      tempC: json['temp_c'] as double,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
      feelsLikeC: json['feelslike_c'] as double,
      humidity: json['humidity'] as num,
      windKph: json['wind_kph'] as num,
      uv: json['uv'] as num,
    );
  }

  final num tempC;
  final Condition condition;
  final num feelsLikeC;
  final num humidity;
  final num windKph;
  final num uv;
}

class Condition {
  const Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'] as String,
      icon: json['icon'] as String,
      code: json['code'] as int,
    );
  }

  final String text;
  final String icon;
  final int code;

  String get imageUrl => 'https:$icon'.replaceAll('64x64', '128x128');
}
