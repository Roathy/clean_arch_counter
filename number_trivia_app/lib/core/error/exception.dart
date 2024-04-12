// For now either of the classes have an actual custom message to provide details about the error but they can be implemented:
// final String message;

// The repository will cach these exceptions and convert them into Failure, therefore Failures map one to one to Exceptions

// 404
class ServerException implements Exception {}

// Will be thrown from between the local data source when a cache error happens
class CacheException implements Exception {}
