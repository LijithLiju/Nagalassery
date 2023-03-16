import 'package:meta/meta.dart';

@immutable
abstract class TransferEvent {}

class SendDetails extends TransferEvent {
  final String url;

  SendDetails(this.url);
}

class FetchCustomerAccNo extends TransferEvent {
  final String mobileNo;

  FetchCustomerAccNo(this.mobileNo);
}
