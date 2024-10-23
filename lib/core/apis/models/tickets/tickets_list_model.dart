import 'ticket_model.dart';

class TicketsListModel {
  List<Ticket>? tickets;
  int? totalTicketCount;
  int? urgentTicketCount;

  TicketsListModel(
      {this.tickets, this.totalTicketCount, this.urgentTicketCount});

  TicketsListModel.fromJson(Map<String, dynamic> json) {
    if (json['tickets'] != null) {
      tickets = <Ticket>[];
      json['tickets'].forEach((v) {
        tickets!.add(Ticket.fromJson(v));
      });
    }
    totalTicketCount = json['totalTicketCount'];
    urgentTicketCount = json['urgentTicketCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tickets != null) {
      data['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    data['totalTicketCount'] = totalTicketCount;
    data['urgentTicketCount'] = urgentTicketCount;
    return data;
  }
}

