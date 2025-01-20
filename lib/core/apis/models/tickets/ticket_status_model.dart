class TicketStatusModel {
  int? lookupId;
  String? type;
  String? value;

  TicketStatusModel({this.lookupId, this.type, this.value});

  TicketStatusModel.fromJson(Map<String, dynamic> json) {
    lookupId = json['lookupId'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lookupId'] = lookupId;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
