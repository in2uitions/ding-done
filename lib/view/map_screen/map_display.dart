import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dingdone/res/app_context_extension.dart';

class MapDisplay extends StatefulWidget {
  final double longitude;
  final double latitude;
  final dynamic body;
  final ValueChanged<LatLng>? onPicked; // 🔥 replacement

  const MapDisplay({
    super.key,
    required this.longitude,
    required this.latitude,
    required this.body,
    this.onPicked,
  });

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  late LatLng selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = _safeLatLng(widget.latitude, widget.longitude);
  }

  @override
  void didUpdateWidget(covariant MapDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      setState(() {
        selectedLocation =
            _safeLatLng(widget.latitude, widget.longitude);
      });
    }
  }

  LatLng _safeLatLng(double lat, double lon) {
    final safeLat = lat.isFinite ? lat : 51.52;
    final safeLon = lon.isFinite ? lon : 25.3;
    return LatLng(safeLat, safeLon);
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
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: selectedLocation,
            initialZoom: 7,
            minZoom: 5,
            maxZoom: 16,

            // 🔁 SAME as onPicked
            onTap: (tapPosition, latLng) {
              setState(() {
                selectedLocation = latLng;
              });

              if (widget.onPicked != null) {
                widget.onPicked!(latLng);
              }
            },

            // 🔒 Same effect as AbsorbPointer when needed
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.in2uitions.dingdone',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedLocation,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
