import 'package:meta/meta.dart';

@immutable
abstract class TransferState {}

class InitialTransferState extends TransferState {}
class LoadingTransferState extends TransferState {}

class DetailsResponse extends TransferState{
	final Map response;
	
	DetailsResponse(this.response);
}
class CustAccNoResponse extends TransferState{
	final Map response;
	
	CustAccNoResponse(this.response);
}
class DetailsError extends TransferState{
	final error;
	
	DetailsError(this.error);
}

