part of graphql_schema.src.schema;

/// Typedef for a function that resolves the value of a [GraphQLObjectField], whether asynchronously or not.
typedef FutureOr<Value> GraphQLFieldResolver<Value, Serialized>(
    Serialized serialized, Map<String, dynamic> argumentValues);

/// Typedef for a function that fully resolves the 
/// value of a [GraphQLObjectField], whether asynchronously or not.
typedef FutureOr<Value> GraphQLFieldFullResolver<Value, Serialized>(
    Serialized serialized, Map<String, dynamic> argumentValues,
    String alias, Map<String, dynamic> tree);

/// A field on a [GraphQLObjectType].
///
/// It can have input values and additional documentation, and explicitly declares it shape
/// within the schema.
class GraphQLObjectField<Value, Serialized> {
  /// The list of input values this field accepts, if any.
  final List<GraphQLFieldInput> inputs = <GraphQLFieldInput>[];

  /// The name of this field in serialized input.
  final String name;

  /// A function used to evaluate the value of this field, with respect to an arbitrary Dart value.
  final GraphQLFieldResolver<Value, Serialized> resolve;

  /// A function used to evaluate the value of this field fully, 
  /// with respect to an arbitrary Dart value.
  final GraphQLFieldFullResolver<Value, Serialized> fullResolve;

  /// The [GraphQLType] associated with values that this field's [resolve] callback returns.
  final GraphQLType<Value, Serialized> type;

  /// An optional description of this field; useful for tools like GraphiQL.
  final String description;

  /// The reason that this field, if it is deprecated, was deprecated.
  final String deprecationReason;

  GraphQLObjectField(this.name, this.type,
      {Iterable<GraphQLFieldInput> arguments: const <GraphQLFieldInput>[],
      this.resolve, this.fullResolve,
      this.deprecationReason,
      this.description}) {
    assert(type != null, 'GraphQL fields must specify a `type`.');
//    assert(
//        resolve != null, 'GraphQL fields must specify a `resolve` callback.');
    this.inputs.addAll(arguments ?? <GraphQLFieldInput>[]);
  }

  /// Returns `true` if this field has a [deprecationReason].
  bool get isDeprecated => deprecationReason?.isNotEmpty == true;

  FutureOr<Serialized> serialize(Value value) {
    return type.serialize(value);
  }

  FutureOr<Value> deserialize(Serialized serialized,
      [Map<String, dynamic> argumentValues = const <String, dynamic>{}]) {
    if (resolve != null) return resolve(serialized, argumentValues);
    return type.deserialize(serialized);
  }

  @override
  bool operator ==(other) =>
      other is GraphQLObjectField &&
      other.name == name &&
      other.deprecationReason == deprecationReason &&
      other.type == type &&
      other.resolve == resolve &&
      const ListEquality<GraphQLFieldInput>().equals(other.inputs, inputs);
}
