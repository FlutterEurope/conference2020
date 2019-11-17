import 'dart:convert';

import 'package:conferenceapp/model/ticket.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketRepository {
  final UserRepository _userRepository;

  final String _ticketKey = 'ticket';

  TicketRepository(this._userRepository);

  Future<Ticket> getTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ticketString = prefs.getString(_ticketKey);
    if (ticketString != null) {
      final json = jsonDecode(ticketString);
      final ticket = Ticket.fromJson(json);
      return ticket;
    }
    return null;
  }

  Future<bool> addTicket(Ticket ticket) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result =
        await prefs.setString(_ticketKey, ticket.toJson().toString());
    return result;
  }

  Future<bool> removeTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await prefs.remove(_ticketKey);
    return result;
  }
}
