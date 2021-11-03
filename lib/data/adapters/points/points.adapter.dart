import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

List<Point> mapJsonToPoints(List<dynamic> json) {
  return json.map((part) {
    return Point(
        address: part['address'] ?? '',
        availability: part['available'] ?? false,
        latitude: part['latitude'],
        longitude: part['longitude'],
        id: part['point_number']);
  }).toList();
}

VoltageTypes mapStringToVoltage(String type) {
  switch (type) {
    case '7AC':
      return VoltageTypes.AC7;
    case '22AC':
      return VoltageTypes.AC22;
    case '50DC':
      return VoltageTypes.DC50;
    case '80DC':
      return VoltageTypes.DC80;
    case '90DC':
      return VoltageTypes.DC90;
    case '120DC':
      return VoltageTypes.DC120;
    case '150DC':
      return VoltageTypes.DC150;
    case '180DC':
      return VoltageTypes.DC180;
    default:
      return VoltageTypes.AC7;
  }
}

List<ConnectorInfo> mapJsonToConnector(List<dynamic> json) {
  return json.map((part) {
    return ConnectorInfo(
        available: part['available'] ?? false,
        type: part["connector_type"] == 'chademo'
            ? ConnectorTypes.CHADEMO
            : ConnectorTypes.TYPE2,
        id: part["number"] ?? 0);
  }).toList();
}


List<Tariff> mapJsonToTariff(List<dynamic> json) {
  return json.map((part) {
    return Tariff(
      from: part["operates_from"] ?? '',
      to: part["operates_to"] ?? '',
      price: part["cost"] ?? 0
    );
  }).toList();
}

PointInfo mapJsonToPointInfo(Map<String, dynamic> json) {
  return PointInfo(
    point: Point(
        address: json['address'] ?? '',
        availability: json['available'] ?? false,
        latitude: json['latitude'],
        longitude: json['longitude'],
        id: json['point_number']),
    voltage: json["evse"] != null && json["evse"].length > 0
        ? mapStringToVoltage(json["evse"][0]["power"])
        : VoltageTypes.AC7,
    connectors: json["evse"] != null &&
            json["evse"].length > 0 &&
            json["evse"][0]["connectors"] != null &&
            json["evse"][0]["connectors"].length > 0
        ? mapJsonToConnector(json["evse"][0]["connectors"])
        : [],
    price: 7.25,
    tariffs: json["tariffs"]!=null && json["tariffs"].length > 0 ? mapJsonToTariff(json["tariffs"]) : []
  );
}