class Cctv {
  String name;
  String url;
  double lat;
  double lng;
  int status;

  Cctv({this.name, this.url, this.lat, this.lng, this.status});

  static List<Cctv> fromJsonList(dynamic jsonList) {
      var data = new List<Cctv>();

      jsonList.forEach((v) {
        data.add(new Cctv.fromJson(v));
      });

      return data;
  }

  Cctv.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    lat = json['lat'];
    lng = json['lng'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['status'] = this.status;
    return data;
  }
}
