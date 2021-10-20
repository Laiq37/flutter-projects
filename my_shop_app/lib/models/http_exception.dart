//here we are implementing exception class which in abstract class which means we have to override its method
//every class has toString method by default in dart

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
