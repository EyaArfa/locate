import 'package:find_me/functions/getPosition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  late GlobalKey<FormState> _key ;
  late TextEditingController textEditingController;
    double  long=0,lat=0;


  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  void initState()  {



    super.initState();
    textEditingController = TextEditingController();
    _key = GlobalKey<FormState>();
    _loadPosition();
    _initialCameraPosition =
        CameraPosition(target: LatLng(lat, long), zoom: 1);
  }
  Future<void> _loadPosition()async{

    var result =await determinePosition();
    setState(() {


      long=result.longitude;
      lat=result.latitude;

    });

    print("Test for location------------"+lat.toString()+long.toString());

  }
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
               dotenv.env['ACCESS_TOKEN'],
            
            dragEnabled: true,
            zoomGesturesEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(5,25),

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
          bottom: 20,
          width: MediaQuery.of(context).size.width ,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFF7F2F9)
            ),
            alignment: Alignment.center,
            child: Form(
              key: _key,
              child:
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Longitude: $long, Latitude: $lat)',style: TextStyle(
                            overflow: TextOverflow.clip
                          ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              TextFormField(
                                controller: textEditingController,
                                decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    label: Text("Enter description"),
                                    constraints: BoxConstraints.tight(Size(

                                        MediaQuery.of(context).size.width *0.65,
                                        MediaQuery.of(context).size.height /10),),),
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'please fill this description';
                                  }
                                  return null;
                                },
                              ),
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
                              child: Text('ADD',style: TextStyle(
                                  color: Color(0xFF9568AB),fontSize: 15,fontWeight: FontWeight.w900
                              ),)),
                            ],
                          ),
                        ]),
                  ),



            ),
          ),
        )
      ],
    )));
  }
}
