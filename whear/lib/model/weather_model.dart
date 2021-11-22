class WeatherModel {
  double degre;

  WeatherModel({
    required this.degre,
  });

  WeatherModel.fromJson(Map<String, dynamic> json) : degre = json['degre'];

  Map<String, dynamic> toJson() => {
        'degre': degre,
      };
}
