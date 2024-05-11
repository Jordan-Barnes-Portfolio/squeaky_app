import 'package:squeaky_app/objects/user.dart';

class Invoice {
  final num total;
  final num taxes;
  final num hours;
  final num pricing;
  final num neatFreakGuarantee;
  final num tip;
  final String customerEmail;
  final String cleanerEmail;

  AppUser cleaner;
  String customerName;
  String cleanerName;

  Invoice(
      {required this.total,
      required this.hours,
      required this.pricing,
      required this.taxes,
      required this.neatFreakGuarantee,
      required this.tip,
      required this.cleaner,
      required this.customerEmail,
      required this.cleanerEmail,
      this.customerName = '',
      this.cleanerName = ''});

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'hours': hours,
      'pricing': pricing,
      'taxes': taxes,
      'neatFreakGuarantee': neatFreakGuarantee,
      'tip': tip,
      'customerEmail': customerEmail,
      'cleanerEmail': cleanerEmail,
      'customerName': customerName,
      'cleanerName': cleanerName,
      'cleaner': cleaner.toMap()
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
        total: map['total'],
        hours: map['hours'],
        pricing: map['pricing'],
        taxes: map['taxes'],
        neatFreakGuarantee: map['neatFreakGuarantee'],
        tip: map['tip'],
        cleaner: AppUser.fromMap(map['cleaner']),
        customerEmail: map['customerEmail'],
        cleanerEmail: map['cleanerEmail'],
        customerName: map['customerName'],
        cleanerName: map['cleanerName']);
  }
}
