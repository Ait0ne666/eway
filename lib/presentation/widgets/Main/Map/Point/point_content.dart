import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.state.dart';
import 'package:lseway/presentation/widgets/AvailabilityChip/availability_chip.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomSelect/custom_select.dart';
import 'package:lseway/presentation/widgets/Core/LabeledBox/labeled_box.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/RouteBuilder/route_view.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/point.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import 'package:lseway/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';

class PointContent extends StatefulWidget {
  final PointInfo point;
  final GeolocatorService geolocatorService;
  final BuildContext ctx;
  final void Function(BuildContext ctx, bool dismiss) charge;
  const PointContent(
      {Key? key,
      required this.point,
      required this.geolocatorService,
      required this.ctx,
      required this.charge
      })
      : super(key: key);

  @override
  _PointContentState createState() => _PointContentState();
}

class _PointContentState extends State<PointContent> {
  late ConnectorTypes connector;

  @override
  void initState() {
    if (widget.point.connectors.length > 0) {
      connector = widget.point.connectors[0].type;
    }
    connector = ConnectorTypes.CHADEMO;
    super.initState();
  }

  void onConnectorChange(ConnectorTypes selected) {
    setState(() {
      connector = selected;
    });
  }

  List<SelectOption<ConnectorTypes>> _buildConnectorOptions() {
    return widget.point.connectors.map((con) {
      return SelectOption<ConnectorTypes>(
          label: mapConnectorTypesToString(con.type), value: con.type);
    }).toList();
  }

  void handleBooking(BuildContext context) {}

  void buildRoute(BuildContext context, Coords destination) {
    widget.geolocatorService.determinePosition().then((value) {
      Coords coords = Coords(value.latitude, value.longitude);
      openMapsSheet(context, coords, destination);
    }).catchError((err) {
      print(err);
    });
  }

  openMapsSheet(BuildContext context, Coords coords, Coords destination) async {
    try {
      final title = "Маршрут";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showDirections(
                            destination: destination, origin: coords),
                        title: Text(
                          map.mapName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void charge(BuildContext context) {
    BlocProvider.of<ChargeBloc>(context).add(StartCharge(pointId: widget.point.point.id));
    
  }

  bool isAvailable(
      List<ConnectorInfo> connectors, ConnectorTypes currentConnector) {
    var connector = connectors.isNotEmpty
        ? connectors.firstWhere((element) => element.type == currentConnector)
        : null;

    if (connector == null) return false;
    return connector.available;
  }



  void chargeListener(BuildContext context, ChargeState state) {
    if (state is ChargeInProgressState && state.progress?.pointId == widget.point.point.id) {
      widget.charge(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var point = widget.point;
    return Container(
      padding: const EdgeInsets.only(top: 45, bottom: 35, left: 20, right: 20),
      child: Column(
        children: [
          BlocListener<ChargeBloc, ChargeState>(listener: chargeListener, child: const SizedBox(),),
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 80),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '№',
                            style: TextStyle(
                                color: Color(0xffFF4147),
                                fontSize: 15,
                                fontFamily: 'URWGeometricExt'),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            point.point.id.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Benzin',
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = Color(0xffFF4147),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Зарядка',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AvailabilityChip(
                          available: isAvailable(point.connectors, connector))
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 39,
          ),
          RouteView(info: point),
          const SizedBox(
            height: 30,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 80),
            child: Row(
              children: [
                LabeledBox(
                    label: 'Цена',
                    width: (MediaQuery.of(context).size.width - 94) / 2,
                    text: FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (getCurrentPriceFromTariffs(point.tariffs))
                                    .toString()
                                    .replaceAll('.', ','),
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              const Text('₽',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff1A1D21),
                                      fontFamily: 'Circe')),
                            ],
                          ),
                          const Text(
                            '/ 1 кВт',
                            style: TextStyle(
                                color: Color(0xff272A2E),
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Circe'),
                          )
                        ],
                      ),
                    ),
                    icon: Image.asset(
                      'assets/wallet.png',
                      width: 82 / 2.5,
                      height: 95 / 2.5,
                    )),
                const SizedBox(width: 14),
                LabeledBox(
                    label: 'Мощность',
                    width: (MediaQuery.of(context).size.width - 94) / 2,
                    text: Text(
                      mapVoltageToString(point.voltage!),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    icon: Image.asset(
                      'assets/bolt.png',
                      width: 82 / 3,
                      height: 95 / 3,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          CustomSelect<ConnectorTypes>(
            onChange: onConnectorChange,
            value: connector,
            options: _buildConnectorOptions(),
            label: 'Выберите тип разъема',
            iconWidth: 45,
            blackCaret: true,
            bgColor: const Color(0xffF6F6FA),
            paddingRight: 20,
            icon: Image.asset(
              'assets/fork.png',
              width: 82 / 3,
              height: 95 / 3,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomButton(
            text: 'Забронировать',
            onPress: () => handleBooking(context),
            type: ButtonTypes.SECONDARY,
            icon: SvgPicture.asset('assets/clock.svg'),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomButton(
            text: 'Проложить маршрут',
            onPress: () => buildRoute(
                context, Coords(point.point.latitude, point.point.longitude)),
            type: ButtonTypes.SECONDARY,
            icon: SvgPicture.asset('assets/route.svg'),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomButton(
            text: 'Начать зарядку',
            onPress: () => charge(context),
            type: ButtonTypes.PRIMARY,
            icon: SvgPicture.asset('assets/QR.svg'),
          ),
        ],
      ),
    );
  }
}