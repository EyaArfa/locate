import 'package:find_me/models/position.dart';
import 'package:find_me/services/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListBestPosition extends StatefulWidget {
  const ListBestPosition({super.key});

  @override
  State<ListBestPosition> createState() => _ListBestPositionState();
}

class _ListBestPositionState extends State<ListBestPosition> {
  List<Position> positions = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Text('Your Locations List',style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,

            color: Color(0xFF694881)),),
            StreamBuilder(
              stream: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error occured'),
                    );
                  } else  {


                    return snapshot.hasData?  Expanded(
                      child: Column(
                        children: [

                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data![index].notes,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Latitude : ${snapshot.data![index].latitude}, Longitude: ${snapshot.data![index].longitude}',
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) :  const Center(child: Text('No data to be shown',style: TextStyle(
                        fontWeight: FontWeight.w200,fontSize: 30
                    ),),);

                  }
                  }

                else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
