import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import '../../../models/event.dart';

class EventListingBody extends StatefulWidget {
  @override
  _EventListingBodyState createState() => _EventListingBodyState();
}

class _EventListingBodyState extends State<EventListingBody> {
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
    return ListView(
      children: <Widget>[
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
        _eventItem(event),
      ],
    );
  }

  Widget _eventItem(Event event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ListTile(
          title: Text(
            event.name,
            maxLines: 1,
          ),
          subtitle: Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          leading: TransitionToImage(
            width: 64.0,
            height: 64.0,
            borderRadius: BorderRadius.circular(12.0),
            fit: BoxFit.cover,
            image: AdvancedNetworkImage(
              event.image,
              useDiskCache: true,
              timeoutDuration: Duration(seconds: 5),
            ),
            placeholder: Container(),
          ),
          onTap: () {},
        ),
        Divider(),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }
}
