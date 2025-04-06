enum Status { init, loading, success, failure }



extension StatusX on Status{
  bool get init => this == Status.init;
  bool get loading => this == Status.loading;
  bool get success => this == Status.success;
  bool get failure => this == Status.failure;
}