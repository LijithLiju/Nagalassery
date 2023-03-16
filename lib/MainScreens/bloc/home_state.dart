import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safeSoftware/Account/Model/AccountsDepositModel.dart';
import 'package:safeSoftware/Account/Model/AccountsLoanModel.dart';
import 'package:safeSoftware/Passbook/Model/PassbookListModel.dart';

@immutable
abstract class HomeState extends Equatable {}

class InitialHomeState extends HomeState {
  @override
  List<Object> get props => [];
}

class AccDepositLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class AccDepositResponse extends HomeState {
  final AccountsDepositModel accountsDepositModel;

  AccDepositResponse(this.accountsDepositModel);

  @override
  List<Object> get props => [accountsDepositModel];
}

class AccLoanLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class AccLoanResponse extends HomeState {
  final AccountsLoanModel accountsLoanModel;

  AccLoanResponse(this.accountsLoanModel);

  @override
  List<Object> get props => [accountsLoanModel];
}

class ShareLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class ShareResponse extends HomeState {
  final PassbookListModel shareListModel;

  ShareResponse(this.shareListModel);

  @override
  List<Object> get props => [shareListModel];
}

class ChittyLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class ChittyResponse extends HomeState {
  final PassbookListModel chittyListModel;

  ChittyResponse(this.chittyListModel);

  @override
  List<Object> get props => [chittyListModel];
}

class PassLoanLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class PassLoanResponse extends HomeState {
  final PassbookListModel passbookLoanListModel;

  PassLoanResponse(this.passbookLoanListModel);

  @override
  List<Object> get props => [passbookLoanListModel];
}

class ErrorException extends HomeState {
  final error;

  ErrorException(this.error);

  @override
  List<Object> get props => [error];
}
