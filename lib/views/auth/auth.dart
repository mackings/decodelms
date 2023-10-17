import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/header.dart';
import '../../apis/authclass.dart';

class Signups extends ConsumerStatefulWidget {
  const Signups({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupsState();
}

class _SignupsState extends ConsumerState<Signups> {
  dynamic ata;
  final web = FutureProvider.autoDispose((ref) => Api().getdata());
  @override
  Widget build(BuildContext context) {
    final Datas = ref.watch(web);
    final mydata = ref.watch(Dataclass().Data.notifier);
    final shade = ref.read(Dataclass().Color.notifier);
    ref.listen(Dataclass().Data, (previous, next) {
      if (Dataclass().Data == 100) {
        print("Limit Exceeded");
      } else {
        print("Free Space");
      }
    });

    return Sizer(builder: (context, orientation, deviceType) {
      return Myheader(
          theback: () {
            Navigator.pop(context);
          },
          thefront: () {},
          title: "${mydata.state}",
          back: Icon(Icons.arrow_back),
          forward: Icon(
            Icons.notifications,
            color: shade.state == "red" ? Colors.yellow : Colors.blue,
          ),
          body: Datas.when(data: (data) {
            return Column(
              children: [
                Text("${data}"),
              ],
            );
          }, error: (error, StackTrace) {
            return Column(
              children: [
                SizedBox(height: 50,),
                Icon(Icons.error,size: 80, color: Colors.red,),
                SizedBox(height: 20,),
                Center(
                  child: Text("$error"),
                ),
              ], 
            );
          }, loading: () {
            return Column(
              children: [
                CircularProgressIndicator(),
              ],
            );
          }));
    });
  }
}
