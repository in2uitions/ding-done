import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressWidget extends StatefulWidget {
  var address;

  AddressWidget({super.key, required this.address});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
        vertical: context.appValues.appPadding.p10,
      ),
      child: SizedBox(
        width: context.appValues.appSizePercent.w90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Text(
                translate('formHints.location'),
                style: getPrimaryRegularStyle(
                  fontSize: 18,
                  color: const Color(0xff180B3C),
                ),
              ),
            ),
            SizedBox(
              width: context.appValues.appSizePercent.w100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.address['city'] != null ? widget.address['city'] : ''}, ${widget.address['street_number'] != null ? widget.address['street_number'] : ''}, ${widget.address['zone'] != null ? widget.address['zone'] : ''}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: getPrimaryRegularStyle(
                        fontSize: 16,
                        color: const Color(0xff71727A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.location_on,
                      color: const Color(0xff71727A),
                      size: 50,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return
                                //   MapLocationPicker(
                                //   apiKey: 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                                //   popOnNextButtonTaped: true,
                                //   currentLatLng: LatLng(
                                //       widget.address['latitude'],widget.address['longitude']
                                //   ),
                                //
                                // );
                                Scaffold(
                              backgroundColor: const Color(0xffFFFFFF),
                              appBar: AppBar(
                                title: Text(translate('map.map')),
                              ),
                              body: GoogleMap(
                                onMapCreated: null,
                                initialCameraPosition: CameraPosition(
                                  zoom: 16.0,
                                  target: LatLng(widget.address['latitude'],
                                      widget.address['longitude']),
                                ),
                                mapType: MapType.normal,
                                markers: <Marker>{
                                  Marker(
                                    markerId: const MarkerId('marker'),
                                    infoWindow: InfoWindow(
                                      title:
                                          '${translate('jobDetails.job')} 🚖',
                                      onTap: () => _showOptionsDialog(
                                          context,
                                          widget.address['latitude'],
                                          widget.address['longitude']),
                                    ),
                                    position: LatLng(
                                      widget.address['latitude'],
                                      widget.address['longitude'],
                                    ),
                                  ),
                                },
                                onCameraMove: null,
                                myLocationButtonEnabled: false,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(
      BuildContext context, double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ListTile(
              //   leading: Icon(Icons.directions),
              //   title: Text('Get Directions'),
              //   onTap: () {
              //     _launchGoogleMapsDirections(latitude, longitude);
              //     Navigator.of(context).pop();
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Open in Google Maps'),
                onTap: () {
                  _launchGoogleMaps(latitude, longitude);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchGoogleMapsDirections(double latitude, double longitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  void _launchGoogleMaps(double latitude, double longitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }
}
