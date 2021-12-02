import 'package:add_2_calendar/add_2_calendar.dart' as add2Cal;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nss_tracker/model/event_model.dart';
import 'package:nss_tracker/model/user_model.dart';
import 'package:nss_tracker/services/Events/firestore_events.dart';
import 'package:nss_tracker/services/firebase/firebase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandedView extends StatelessWidget {
  ExpandedView({
    Key? key,
    required this.event,
    required this.isOngoing,
  }) : super(key: key);
  final bool isOngoing;
  final Event event;

  @override
  Widget build(BuildContext context) {
    // print(event.isOnline);
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        // floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light),
            backgroundColor:
                isOngoing ? Colors.lightGreenAccent[700] : Colors.blue[400],
            title: innerBoxIsScrolled
                ? Text(
                    isOngoing
                        ? "Ongoing Event".toUpperCase()
                        : "Upcoming Event".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.apply(color: Colors.white, fontSizeDelta: -5),
                  )
                : null,
            floating: true,
            // snap: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: event.id,
                child: Image.asset(
                  isOngoing
                      ? "assets/images/plant.jpg"
                      : "assets/images/webinar.jpg",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline5?.apply(
                          fontFamily: "Feather",
                          color: Theme.of(context).textTheme.headline6?.color,
                          fontSizeDelta: 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              DateFormat("d'th' MMM, y; h:mm aa")
                                  .format(event.startDateTime)
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.apply(fontSizeDelta: -1)),
                          Text(
                              DateFormat("d'th' MMM, y; h:mm aa")
                                  .format(event.endDateTime)
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.apply(fontSizeDelta: -1)),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.apply(fontWeightDelta: 2),
                      ),
                      SizedBox(height: 10),
                      Text(event.description),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Instruction",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.apply(fontWeightDelta: 2),
                      ),
                      SizedBox(height: 10),
                      Text(event.instruction),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          final event = add2Cal.Event(
                            title: this.event.name,
                            startDate: this.event.startDateTime,
                            endDate: this.event.endDateTime,
                            description: this.event.description,
                          );
                          add2Cal.Add2Calendar.addEvent2Cal(event);
                        },
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(5.0),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.green.shade50),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15.0)))),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Add to Calender".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.lightGreenAccent[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        event.isOnline
                            ? "You will be able to access the button to join the meeting 5 mins before event starts, until 10 mins into the meeting"
                            : "Fill the form and submit your entries",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.apply(color: Colors.grey.shade400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: isOngoing &&
                                  DateTime.now().isBefore(event.endDateTime)
                              ? () {
                                  // launch(event.link);
                                  final newAttendace = Provider.of<UserModel>(
                                              context,
                                              listen: false)
                                          .attendance +
                                      event.endDateTime
                                          .difference(event.startDateTime)
                                          .inHours;
                                  print(newAttendace);
                                  FirestoreEvents.updateAttendance(
                                      Provider.of<UserModel>(context,
                                              listen: false)
                                          .uid,
                                      newAttendace);

                                  launch(event.link);
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  event.isOnline
                                      ? "Join".toUpperCase()
                                      : "Submit".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                DateTime.now().isBefore(event.endDateTime)
                                    ? Colors.lightGreenAccent.shade700
                                    : Colors.grey.shade600),
                            elevation: MaterialStateProperty.all<double>(5.0),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
