import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import './bloc.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc({TransferState initialState}) : super(initialState);


  @override
  Stream<TransferState> mapEventToState(
    TransferEvent event,
  ) async* {
  
    if(event is SendDetails){
    	yield LoadingTransferState();
	    try {
		    yield DetailsResponse(await RestAPI().get(event.url));
	    } on RestException catch (e) {
	      yield throw e;
	    }
    }else if(event is FetchCustomerAccNo){
	    yield LoadingTransferState();
	    try {
		    yield CustAccNoResponse(await RestAPI().get(APis.fetchAccNo(event.mobileNo)));
	    } on RestException catch (e) {
		    yield throw e;
	    }
    }
  }
}
