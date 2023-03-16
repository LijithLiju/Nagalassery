import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:safeSoftware/Account/Model/AccountsDepositModel.dart';
import 'package:safeSoftware/Account/Model/AccountsLoanModel.dart';
import 'package:safeSoftware/Passbook/Model/PassbookListModel.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';

import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeState initialState}) : super(initialState);



  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is AccDepositEvent) {
      yield AccDepositLoading();
      try {
        yield AccDepositResponse(
          AccountsDepositModel.fromJson(
            await RestAPI().get(APis.getDepositDetailsList(event.custID)),
          ),
        );
      } on RestException catch (e) {
        yield ErrorException(e);
      }
    }
    if (event is AccLoanEvent) {
      yield AccLoanLoading();
      try {
        yield AccLoanResponse(
          AccountsLoanModel.fromJson(
            await RestAPI().get(APis.accountLoanListUrl(event.custID)),
          ),
        );
      } on RestException catch (e) {
        yield ErrorException(e);
      }
    }
    if (event is ChittyEvent) {
      yield ChittyLoading();
      try {
        yield ChittyResponse(
          PassbookListModel.fromJson(
            await RestAPI().get("${APis.otherAccListInfo}${event.custID}&Acc_Type=MMBS"),
          ),
        );
      } on RestException catch (e) {
        yield ErrorException(e);
      }
    }
    if (event is ShareEvent) {
      yield ShareLoading();
      try {
        yield ShareResponse(
	        PassbookListModel.fromJson(
		        await RestAPI().get("${APis.otherAccListInfo}${event.custID}&Acc_Type=SH"),
	        ),
        );
      } on RestException catch (e) {
        yield ErrorException(e);
      }
    }
  }
}
