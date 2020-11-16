

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// class DelayedList extends StatefulWidget {
//   @override
//   _DelayedListState createState() => _DelayedListState();
// }

// class _DelayedListState extends State<DelayedList> {
//   bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     Timer timer = Timer(Duration(seconds: 3), () {
//       setState(() {
//         isLoading = false;
//       });
//     });

//     return isLoading ? ShimmerList() : DataList(timer);
//   }
// }

// class DataList extends StatelessWidget {
//   final Timer timer;

//   DataList(this.timer);

//   @override
//   Widget build(BuildContext context) {
//     timer.cancel();
//     return ListView.builder(
//       itemCount: 8,
//       itemBuilder: (context, i) {
//         return Container(
//           padding: EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//           ),
//           child: Text(i.toString()),
//         );
//       },
//     );
//   }
// }

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          // print(time);

          return Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey[300],
            child: ShimmerLayout(),
            period: Duration(milliseconds: time),
          );
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double containerWidth = 280;
    // double containerHeight = 15;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[300],
    );
  }
}

// class ShimmerImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         height: 500,
//         width: 500,
//         child: Shimmer.fromColors(
//           baseColor: Colors.black,
//           highlightColor: Colors.white,
//           child: Image.asset("thecsguy.PNG"),
//           period: Duration(seconds: 3),
//         ),
//       ),
//     );
//   }
// }

// class WallpaperImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         wallpaper(context),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             margin: EdgeInsets.only(bottom: 25),
//             child: shimmerText(),
//           ),
//         )
//       ],
//     );
//   }

//   Widget shimmerText() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[500],
//       highlightColor: Colors.white,
//       child: Text(
//         "> Slide to unlock",
//         style: TextStyle(fontSize: 25),
//       ),
//     );
//   }

//   wallpaper(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: double.infinity,
//       child: Image.asset(
//         "wallpaper.jpg",
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
