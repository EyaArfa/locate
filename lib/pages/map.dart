import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:find_me/models/position.dart';
import '../services/data.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key});

  @override
  State<MapViewWidget> createState() => _MapState();
}

class _MapState extends State<MapViewWidget> {
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    _initialCameraPosition =
        CameraPosition(target: LatLng(35.7804474, 10.6309176), zoom: 15);

    super.initState();
  }

  double long = 35.7804474, lat = 10.6309176;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Stack(
      children: [
        Expanded(
          child: MapboxMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            accessToken:
                "pk.eyJ1IjoiZXlhYXJmYSIsImEiOiJjazQ1eWs2MXEwZGh5M2VwamU1bHhpY29hIn0.51fE4wQxysEZ44zsCajKEA",
            dragEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(25, 25),
            onMapLongClick: (point, coordinates) {
              setState(() {
                long = coordinates.longitude;
                lat = coordinates.latitude;
                print(long.toString() + lat.toString());
              });
            },
          ),
        ),
        Positioned(
          bottom: 70,
          left: MediaQuery.of(context).size.width / 15,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Form(
              key: _key,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Longitude: ${long.toString()}, \nLatitude: ${lat.toString()}',
                        ),
                        TextFormField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              label: Text("Enter description"),
                              constraints: BoxConstraints.tight(Size(
                                  MediaQuery.of(context).size.width / 1.5,
                                  50))),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'please fill this description';
                            }
                            return null;
                          },
                        ),
                      ]),
                  TextButton(
                      onPressed: () async {
                        String msg = "";
                        if (_key.currentState!.validate()) {
                          Position pos = Position(
                              notes: textEditingController.text,
                              latitude: lat,
                              longitude: long);

                          insert(pos).then((value) => {
                                if (value == 1)
                                  {
                                    msg =
                                        "your friend has been successfully inserted "
                                  }
                                else
                                  {
                                    msg =
                                        "couldn't insert the new position try again"
                                  },
                                Fluttertoast.showToast(msg: msg),
                                print(value)
                              });
                          textEditingController.clear();
                        }
                      },
                      child: Text('ADD')),
                ],
              ),
            ),
          ),
        )
      ],
    )));
  }
}
