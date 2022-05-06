
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  Home(),
    );
  }
}

class Home extends StatelessWidget {
   Home({ Key? key }) : super(key: key);

  double? dxOrigin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Shimmer.fromColors(
                  direction: ShimmerDirection.rtl,
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,child: const Text('Slide to cancel')),
                Draggable(
                  childWhenDragging: const SizedBox(),
                  axis: Axis.horizontal,
                  onDragEnd: (details){
                    print(details.offset.dx);
                    if(MediaQuery.of(context).size.width/2 >= -(details.offset.dx)){
                      print('voice deleted');
                    }
                  },
                  feedback: const Icon(Icons.mic),
                  child: GestureDetector(onLongPress: (){
                    print("longPressed");
                  },child: const Icon(Icons.mic)),
                 
                  // // onLongPressMoveUpdate: (detail){
                  // //   print(detail.offsetFromOrigin.dx);
                  // //   print(MediaQuery.of(context).size.width);
                  // //   dxOrigin ??= detail.offsetFromOrigin.dx;
                  // //   if(MediaQuery.of(context).size.width/2 <= -(detail.offsetFromOrigin.dx)){
                    
                  // //   }
                    
                  // },
                  ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
