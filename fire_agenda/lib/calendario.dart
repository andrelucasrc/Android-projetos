import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class Calendario {
  static const _scopes = const [CalendarApi.CalendarScope];

  Future<String> inserirEvento(String title, DateTime startTime, DateTime endTime, List<String> recurrency, String timeZone) async{
    String response;
    var _clientID = new ClientId("429964937324-fdf3jhlsmvc80eefsvlk71pv9bnue6ni.apps.googleusercontent.com", "");
    AuthClient client = await clientViaUserConsent(_clientID, _scopes, prompt);
    var calendar = CalendarApi(client);
    calendar.calendarList.list().then((value) => print("VAL________$value"));

    String calendarId = "primary";
    Event event = Event(); // Create object of event

    event.summary = title;

    EventDateTime start = new EventDateTime();
    start.dateTime = startTime;
    start.timeZone = timeZone;
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.dateTime = endTime;
    end.timeZone = timeZone;
    event.end = end;

    event.recurrence = recurrency;

    try {
      var value = await calendar.events.insert(event, calendarId);
      print("Adicionado_________________${value.status}");
      if (value.status == "confirmed") {
        response = 'Evento adicionado ao calendário';
      } else {
        response = "Não foi possível adicionar ao calendario";
      }//end of if
    } catch (e) {
      response = 'Erro ao criar evento $e';
      log(response);
    }//end of catch

    return response;
  }//end of inserirEvento

  Future<Events> retrieveEventList() async{
    var _clientID = new ClientId("429964937324-fdf3jhlsmvc80eefsvlk71pv9bnue6ni.apps.googleusercontent.com", "");
    AuthClient client = await clientViaUserConsent(_clientID, _scopes, prompt);
    var calendar = CalendarApi(client);
    calendar.calendarList.list().then((value) => print("VAL________$value"));

    String calendarId = "primary";

    return await calendar.events.list(calendarId);
  }//end of retrieveEventList

  Future<List<String>> retrieveEventsInfo() async{
    Events calendarEvents = await retrieveEventList();
    List<String> infos = [];
    String info;
    for(Event event in calendarEvents.items){
      info = "";
      info += event.summary;
      info += ": ";
      DateTime aux = event.start.dateTime;
      info += aux.day.toString() + "/" + aux.month.toString() + "/" + aux.year.toString();
      infos.add(info);
    }
    return infos;
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível acessar $url';
    }
  }
}//end of Calendario
