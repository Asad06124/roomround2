class BaseModel {
  bool? succeeded;
  String? message;
  int? httpStatusCode;
  int? totalCounts;
  var data;

  BaseModel(
      {this.succeeded,
      this.message,
      this.httpStatusCode,
      this.totalCounts,
      this.data});

  BaseModel.fromJson(Map<String, dynamic> json) {
    succeeded = json['succeeded'];
    message = json['message'];
    httpStatusCode = json['httpStatusCode'];
    totalCounts = json['totalCounts'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succeeded'] = succeeded;
    data['message'] = message;
    data['httpStatusCode'] = httpStatusCode;
    data['totalCounts'] = totalCounts;

    data['data'] = this.data;

    return data;
  }
}
