import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props]);
}

class AccDepositEvent extends HomeEvent {
  final String custID;

  AccDepositEvent(this.custID) : super([custID]);

  @override
  List<Object> get props => [custID];
}

class AccLoanEvent extends HomeEvent {
  final String custID;

  AccLoanEvent(this.custID) : super([custID]);

  @override
  List<Object> get props => [custID];
}

class ShareEvent extends HomeEvent {
  final String custID;

  ShareEvent(this.custID) : super([custID]);

  @override
  List<Object> get props => [custID];
}

class ChittyEvent extends HomeEvent {
  final String custID;

  ChittyEvent(this.custID) : super([custID]);

  @override
  List<Object> get props => [custID];
}
