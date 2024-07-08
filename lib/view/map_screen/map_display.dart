import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Ensure you import latlong2 package
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:latlong2/latlong.dart';

class MapDisplay extends StatefulWidget {
  final double longitude;
  final double latitude;
  dynamic body;

  MapDisplay({required this.longitude, required this.latitude, required this.body});

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  late double lon;
  late double lat;

  @override
  void initState() {
    super.initState();
    lon = widget.longitude.isFinite ? widget.longitude : 25.3;
    lat = widget.latitude.isFinite ? widget.latitude : 51.52;
    debugPrint('Initial coordinates: lat=$lat, lon=$lon');
  }

  @override
  void didUpdateWidget(MapDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.longitude != oldWidget.longitude || widget.latitude != oldWidget.latitude) {
      setState(() {
        lat = widget.latitude.isFinite ? widget.latitude : 51.52;
        lon = widget.longitude.isFinite ? widget.longitude : 25.3;
        debugPrint('Updated coordinates: lat=$lat, lon=$lon');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.appValues.appSizePercent.w100,
      height: context.appValues.appSizePercent.h41,
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: AbsorbPointer(
        absorbing: true,
        child: FlutterLocationPicker(
          initPosition: LatLong(lat, lon),
          showSearchBar: false,
          showSelectLocationButton: false,
          showZoomController: false,
          showLocationController: false,
          trackMyPosition: false,
          selectLocationButtonLeadingIcon: const Icon(Icons.check),
          initZoom: 7,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          onError: (e) => debugPrint('Error: $e'),
          onPicked: (pickedData) {
            debugPrint('Location picked: $pickedData');
          },
        ),
      ),
    );
  }
}
