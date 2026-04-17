abstract class RPinInputCodeRetriever {
  bool get listenForMultipleCodes;

  Future<String?> getCode();

  Future<void> dispose();
}
