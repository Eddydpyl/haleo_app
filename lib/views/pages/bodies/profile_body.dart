import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:haleo_app/blocs/user_events_bloc.dart';
import 'package:haleo_app/models/user.dart';

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
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: _userAvatar(user, width / 6),
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

Widget _userAvatar(User user, double radius) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ListTile(
          title: Text(
            event.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CardImage(
            image: event.image,
            asset: randomImage(event.name),
            height: 64,
            width: 64,
          ),
          trailing: Text(
            event.count.toString() + " / " + event.slots.toString(),
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatPage(eventKey),
            ));
          },
        ),
        Divider(),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }

  String randomImage(String eventName) {
    int assetNumber = eventName.length % 6;
    String asset = 'assets/images/event_' + assetNumber.toString() + ".png";
    return asset;
  }

  void leaveDialog(BuildContext context, String key, Event event,
      UserEventsBloc userEventsBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Salir de " + event.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          content: new Text("¿Seguro que quieres abandonar este evento?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "NO",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "SÍ, ¡SACAME DE AQUÍ!",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                userEventsBloc.leaveSink.add(eventKey);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
