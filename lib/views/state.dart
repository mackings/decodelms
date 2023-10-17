import 'package:decodelms/apis/authclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class Statescreen extends ConsumerStatefulWidget {
  const Statescreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatescreenState();
}

class _StatescreenState extends ConsumerState<Statescreen> {
  final api = Api();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        final myvalue = ref.watch(api.demoprovider);
        final myread2 = ref.read(api.demoprovider.notifier);
        final pro = ref.watch(Apiprovider);
        final thecount = ref.watch(api.thefigures.notifier);

        return Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(myvalue.toString()),
                SizedBox(
                  height: 50,
                ),
                myvalue == "Macs" ? Text("Its macs") : Text("Its Nelson"),
                GestureDetector(
                  onTap: () {
                    myread2.state = "Macs";
                    print(myvalue.toString());
                  },
                  child: Container(
                    height: 20,
                    width: 60,
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      myread2.state = "nelson";
                      print(myvalue.toString());
                    },
                    child: Container(
                      height: 20,
                      width: 60,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Text("${thecount.state}"),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                    //  print(thecount.state.toString());
                      ref.read(api.thefigures.notifier).increase();
                      // ref.read(api.thefigures.notifier).increase();
                    },
                    child: Container(
                      height: 20,
                      width: 60,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
