extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filterStreamList(bool Function(T) where) {
    return map(
      (items) => items.where(where).toList(),
    );
  }
}
