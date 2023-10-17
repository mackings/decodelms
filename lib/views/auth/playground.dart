import 'package:decodelms/apis/authclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Playground extends ConsumerStatefulWidget {
  const Playground({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaygroundState();
}

class _PlaygroundState extends ConsumerState<Playground> {
  final Mydata = FutureProvider((ref) => Api().getdata());
  List? Data1;

  @override
  Widget build(BuildContext context) {
    final basedata = ref.watch(Mydata);
     final mytheme = ref.watch(Api().themeprovider);
    return Scaffold(
      body: basedata.when(data: (data) {
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Data1 = data[index]["chapters"];
                    });
                    showModalBottomSheet(
                        context: context,
                        builder: (Buildcontext) {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(data[index]["chapters"]
                                                [index]["chaptertitle"]
                                            .toString()),
                                      ),

                                      GestureDetector(
                                          onTap: () {
                                          // ref.read(mytheme.)
                                          },
                                          child: Icon(
                                              Icons.switch_access_shortcut))

                                      //Text(data[index]["chapters"]["content"].toString()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Column(
                    children: [
                      Text(data[index]["title"].toString()),
                      Text(data[index]["synopsis"].toString()),
                    ],
                  ),
                ),
              );
            });
      }, error: (error, StackTrace) {
        return Center(child: Text(error.toString()));
      }, loading: () {
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
