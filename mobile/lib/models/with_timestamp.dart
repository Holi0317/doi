/// A generic class that wraps any data type T and adds a timestamp indicating when the instance was created.
class WithTimestamp<T> {
  final T data;
  final DateTime timestamp;

  WithTimestamp(this.data) : timestamp = DateTime.now();
}
