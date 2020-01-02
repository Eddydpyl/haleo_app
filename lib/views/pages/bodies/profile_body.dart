import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:haleo_app/blocs/user_events_bloc.dart';
import 'package:haleo_app/models/user.dart';
import 'package:share/share.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/user_events_provider.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';
import '../../pages/chat_page.dart';
import '../../../utility.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    // TODO: get current user instead of this
    final User user = new User(
        email: 'miestgo@gmail.com',
        name: 'Miguel Esteban',
        image:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
        description: 'Me gusta jugar a crear empresas.');
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    /*final TextEditingController nameController;
    final TextEditingController descriptionController;*/

    return StreamBuilder(
      // TODO: these should be events you've joined / created that haven't being filled up yet
      stream: UserEventsProvider.eventsBloc(context).eventsStream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          List<String> sorted = List.from(events.keys)
            ..sort((String a, String b) =>
                events[b].lastMessage?.compareTo(events[a].lastMessage ?? "") ??
                -1);
          if (sorted.isNotEmpty) {
            return Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(
                  child: _profileImage(user, width / 6),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: TextFormField(
                  initialValue: user.name,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(36),
                  ],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                    fontSize: 24.0,
                  ),
                  decoration: InputDecoration(
                    border: underlineInputBorder(Colors.transparent),
                    enabledBorder: underlineInputBorder(Colors.transparent),
                    focusedBorder: underlineInputBorder(Colors.transparent),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: TextFormField(
                  initialValue: user.description,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  maxLength: 70,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(70),
                  ],
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    border: underlineInputBorder(Colors.transparent),
                    enabledBorder: underlineInputBorder(Colors.transparent),
                    focusedBorder: underlineInputBorder(Colors.transparent),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                    children: sorted
                        .map((String key) =>
                            EventTile(eventKey: key, event: events[key]))
                        .toList()),
              ),
            ]);
          } else
            return EmptyWidget();
        } else {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

UnderlineInputBorder underlineInputBorder([Color color = Colors.grey]) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 2.0,
    ),
  );
}

Widget _profileImage(User user, double radius) {
  return GestureDetector(
    child: (user.image?.isNotEmpty ?? false)
        ? CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: TransitionToImage(
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(radius),
              placeholder: InitialsText(user.name),
              loadingWidget: InitialsText(user.name),
              image: AdvancedNetworkImage(
                user.image,
                useDiskCache: true,
                timeoutDuration: Duration(seconds: 5),
              ),
            ),
          )
        : CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: InitialsText(user.name),
          ),
    onTap: () {
      // TODO: change profile user image
    },
  );
}

class EventTile extends StatelessWidget {
  final String eventKey;
  final Event event;

  EventTile({
    @required this.eventKey,
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final String lastRead =
        ApplicationProvider.preferences(context).lastRead(eventKey).getValue();
    final bool hasMessages = event.lastMessage?.isNotEmpty ?? false;
    final bool unread = hasMessages &&
        (lastRead.isEmpty ||
            DateUtility.parseDate(lastRead)
                .isBefore(DateUtility.parseDate(event.lastMessage)));
    final UserEventsBloc userEventsBloc =
        UserEventsProvider.eventsBloc(context);

    // TODO: get current users instead of this
    final User user = new User(
        email: 'miestgo@gmail.com',
        name: 'Miguel Esteban',
        image:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
        description: 'Me gusta jugar a crear empresas.');

    return Column(
      children: <Widget>[
        SizedBox(
          height: 4.0,
        ),
        ExpansionTile(
          backgroundColor: Colors.white,
          leading: CardImage(
            image: event.image,
            asset: randomImage(event.name),
            height: 64,
            width: 64,
          ),
          title: Text(
            event.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // TODO: align trailing to the right so that it has the same padding as profile icon in bar
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                event.count.toString() + " / " + event.slots.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              FlatButton(
                shape: CircleBorder(),
                child: PaintGradient(
                  child: Icon(Icons.share),
                  colorA: Color(0xff7474bf),
                  colorB: Color(0xff348ac7),
                ),
                onPressed: () {
                  Share.share("¡Únete a este haleo! : *" +
                      event.name +
                      "* \n _" +
                      event.description +
                      "_  \n ¡Descarga ya la app en Google Play!"); // TODO: google play link
                },
              ),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xFF424242),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      event.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TODO: as many user tiles as attendees
            _userTile(user),
            _userTile(user),
            _userTile(user),

            SizedBox(height: 16.0),
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Divider(),
      ],
    );
  }

  Widget _userTile(User user) {
    return Padding(
      padding: EdgeInsets.only(left: 32.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.white,
          child: (user.image?.isNotEmpty ?? false)
              ? TransitionToImage(
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(24.0),
                  placeholder: InitialsText(user.name),
                  loadingWidget: InitialsText(user.name),
                  image: AdvancedNetworkImage(
                    user.image,
                    useDiskCache: true,
                    timeoutDuration: Duration(seconds: 5),
                  ),
                )
              : InitialsText(user.name),
        ),
        title: Text(user.name),
        subtitle: Text(user.description),
      ),
    );
  }

  String randomImage(String eventName) {
    int assetNumber = eventName.length % 6;
    String asset = 'assets/images/event_' + assetNumber.toString() + ".png";
    return asset;
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/having_fun.png'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '¡Ooops! \n Aun no se ha llenado ningún evento. ¡Sigue haciendo swipe right!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
