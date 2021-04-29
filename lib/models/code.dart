class Code {
  String code;
  String parent;
  String description;

  Code(this.parent, this.code, this.description);
  Code.copy(Code from) : this(from.parent, from.code, from.description);
}
