import 'package:flutter/material.dart';
import 'package:flutter_lang/core/dio_service.dart';
import 'package:flutter_lang/utils/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 10);

  late GoogleMapController _googleMapController;
  final Marker _origin = Marker(
    markerId: const MarkerId('origin'),
    infoWindow: const InfoWindow(title: 'Origin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    position: const LatLng(3.8609341882766546, 11.520488047821061),
  );
  final Marker _destination = Marker(
    markerId: const MarkerId('destination'),
    infoWindow: const InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: const LatLng(3.8267012615763103, 11.507724210443488),
  );
  DirectionsModel? _info;

  Future<void> _loadDirections() async {
    var directions =
        await DioService().getData(origin: _origin.position, destination: _destination.position);
    setState(() => _info = directions);
  }

  // Future<void> _addMarker(LatLng pos) async {
  //   print(pos);
  //   if ((_origin != null)) {
  //     setState(() {
  //       _origin = Marker(
  //         markerId: const MarkerId('origin'),
  //         infoWindow: const InfoWindow(title: 'Origin'),
  //         icon:
  //             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //         position: pos,
  //       );
  //       _destination = null;

  //       _info = null;
  //     });
  //   } else {
  //     setState(() {
  //       _destination = Marker(
  //         markerId: const MarkerId('destination'),
  //         infoWindow: const InfoWindow(title: 'Destination'),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //         position: pos,
  //       );
  //     });

  //     var directions = await DioService()
  //         .getData(origin: _origin!.position, destination: pos);
  //     setState(() => _info = directions);
  //   }
  // }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadDirections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tentee Google Maps"),
          actions: [
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 10.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination.position,
                    zoom: 10.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                _origin,
                _destination
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              // onLongPress: (pos) => _addMarker(pos),
            ),
            if (_info != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_info!.totalDistance}, ${_info!.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController.animateCamera(_info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition)),
          child: const Icon(Icons.center_focus_strong),
        ));
  }
}
