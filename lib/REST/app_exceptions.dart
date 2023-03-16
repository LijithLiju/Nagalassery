class RestException implements Exception {
  final prefix;
  final message;

  RestException([this.prefix, this.message]);

  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends RestException {
  final message;

  FetchDataException([this.message]) : super("Error During Communication: ",message );
}

class BadRequestException extends RestException {
  final message;

  BadRequestException([this.message]) : super("Invalid Request: ", message);
}

class UnauthorisedException extends RestException {
  final message;

  UnauthorisedException([this.message]) : super("Unauthorised: ", message);
}

class InvalidInputException extends RestException {
  final message;

  InvalidInputException([this.message]) : super("Invalid Input: ", message);
}
