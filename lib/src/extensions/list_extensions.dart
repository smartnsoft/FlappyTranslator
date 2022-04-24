extension ListExtensions<E> on List<E> {
  /// Maps a list of elements to a list of elements of another type.
  ///
  /// The [predicate] filters elements that are passed to the [transform] function.
  /// This does not change the order or index of the elements.
  /// The [transform] function is called for each element in the list with its respective index and maps it to a new element.
  List<T> mapIndexedWhere<T>(T Function(int index, E element) transform,
      [bool Function(int index, E element)? predicate]) {
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      if (predicate != null ? predicate(i, this[i]) : true) {
        result.add(transform(i, this[i]));
      }
    }
    return result;
  }
}
