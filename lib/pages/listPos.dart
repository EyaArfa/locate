import 'package:find_me/models/position.dart';
import 'package:find_me/services/data.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: StreamBuilder(
        stream: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occured'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data![index].notes,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Latitude : ${snapshot.data![index].latitude}, Longitude: ${snapshot.data![index].longitude}',
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No data to be shown'));
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
