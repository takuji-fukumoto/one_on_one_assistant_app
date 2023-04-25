abstract class RepositoryInterface<T> {
  Future<T?> get(int id);

  Future<T> add(T record);

  Future<void> update(T record);

  Future<List<T?>> getMany(List<int> ids);

  Future<void> addMany(List<T> records);

  Future<List<T>> getAll();

  Future<bool> remove(int id);

  Future<void> removeAll();
}
