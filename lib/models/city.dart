class City {
  final int cityId;
  final String description;
  final String uf;
  final int ibge;

  City(
      {required this.cityId,
      required this.description,
      required this.uf,
      required this.ibge});

  factory City.fromMap(Map<String, dynamic> city) {
    return City(
        cityId: city['id'] ?? 0,
        description: city['description'] ?? '',
        uf: city['uf'] ?? '',
        ibge: city['ibge'] ?? 0);
  }

  static City getCity(int id, String description, String uf, int ibge) {
    Map<String, dynamic> mp = {"id": id, "description": description, "uf": uf, "ibge": ibge};
    City city = City.fromMap(mp);
    return city;
  }
}
