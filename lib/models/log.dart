class Log {
  String uid;
  String timeStamp;
  String type;
  String label;

  Log({this.uid, this.timeStamp, this.type, this.label});
  Log.copy(Log from)
      : this(
          uid: from.uid,
          timeStamp: from.timeStamp,
          type: from.type,
          label: from.label,
        );

  @override
  String toString() {
    // TODO: implement toString
    return "{ uid:${this.uid}, timeStamp:${this.timeStamp}, type:${this.type}, label:${this.label} }";
  }
}
