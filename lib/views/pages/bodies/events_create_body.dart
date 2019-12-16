import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../custom_icons.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class EventsCreateBody extends StatefulWidget {
  @override
  _EventsCreateBodyState createState() => _EventsCreateBodyState();
}

class _EventsCreateBodyState extends State<EventsCreateBody> {
  final Event event = Event(
    name: "Padel",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
        "Fusce condimentum augue vel vestibulum sodales. Donec consectetur, "
        "nisi a fringilla lobortis, arcu leo ultrices nunc, tincidunt "
        "interdum ex libero id diam.",
    image: "https://www.hotelbalnearivichycatalan.cat/uploads/galleries/que"
        "-fer/sense-sortir-del-balneari/padel/pista-padel-8.jpg",
  );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final offsetWidth = 32;
    final offsetHeight = 0.28 * height;

    return Padding(
        padding: new EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  EventEditCard(
                    height: height - offsetHeight,
                    width: width - offsetWidth,
                  ),
                ],
              ),
            ),
            Container(height: 8.0), // Acts as padding here
            Expanded(child: EventActions()),
            Container(height: 8.0), // Acts as padding here
          ],
        ));
  }
}

class EventEditCard extends StatelessWidget {
  final double width, height;

  EventEditCard({
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Card(
        shape: ContinuousRectangleBorder(),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TransitionToImage(
              height: height > 400 ? height / 2 : height / 4,
              width: double.maxFinite,
              fit: BoxFit.cover,
              image: AdvancedNetworkImage(
                'https://www.arbelecos.es/wp-content/uploads/2016/02/placeholder-9.jpg',
                useDiskCache: true,
                timeoutDuration: Duration(seconds: 5),
              ),
              placeholder: Container(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
              child: Text(
                'Prueba',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                  child: Text(
                    'Cambiar por inputs',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 64.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: PaintGradient(
              child: Icon(CustomIcons.cancel_1),
              colorA: Color(0xfffa6b40),
              colorB: Color(0xfffd1d1d),
            ),
            onPressed: () {
              // TODO
            },
          ),
        ),
        Container(
          height: 64.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: PaintGradient(
              child: Icon(CustomIcons.ok_1),
              colorA: Color(0xff7dd624),
              colorB: Color(0xff45b649),
            ),
            onPressed: () {
              // TODO
            },
          ),
        ),
      ],
    );
  }
}
