import 'package:scrap_app/models/items.dart';

class Orders {
  final String id;
  final String status;
  final String date;
  final String address;
  final String weight;
  final String paymentMode;
  final String scrapImage;
  final String paymentProofImage;
  final Map paymentDetails;
  final String userId;
  final String agentId;
  final List<Items> items;
  final String amount;
  final int paymentDate;

  Orders(
      {required this.id,
      required this.status,
      required this.date,
      required this.address,
      required this.weight,
      required this.paymentMode,
      required this.scrapImage,
      required this.paymentProofImage,
      required this.paymentDetails,
      required this.userId,
      required this.agentId,
      required this.items,
      required this.amount,
      required this.paymentDate});

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
      id: json['id'],
      status: json['status'],
      date: json['date'],
      address: json['address'],
      weight: json['weight'],
      paymentMode: json['paymentMode'],
      scrapImage: json['scrapImage'],
      paymentProofImage: json['paymentProofImage'],
      paymentDetails: json['paymentDetails'],
      userId: json['userId'],
      agentId: json['agentId'],
      items: List<Items>.from(json['items'].map((e) => Items.fromJson(e))),
      amount: json['amount'],
      paymentDate: json['paymentDate']);

  Map<String, dynamic> tojson() => {
        'status': status,
        'date': date,
        'address': address,
        'weight': weight,
        'paymentMode': paymentMode,
        'scrapImage': scrapImage,
        'paymentProofImage': paymentProofImage,
        'paymentDetails': paymentDetails,
        'userId': userId,
        'agentId': agentId,
        'items': items.map((e) => e.toJson()),
        'amount': amount,
        'paymentDate': paymentDate,
      };
}
