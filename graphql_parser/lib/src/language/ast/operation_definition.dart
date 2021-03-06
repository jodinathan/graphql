import 'package:source_span/source_span.dart';

import '../token.dart';
import 'definition.dart';
import 'directive.dart';
import 'selection_set.dart';
import 'variable_definitions.dart';

class OperationDefinitionContext extends ExecutableDefinitionContext {
  final Token TYPE, NAME;
  final VariableDefinitionsContext variableDefinitions;
  final List<DirectiveContext> directives = [];
  final SelectionSetContext selectionSet;

  bool get isMutation => TYPE?.text == 'mutation';

  bool get isSubscription => TYPE?.text == 'subscription';

  bool get isQuery => TYPE?.text == 'query' || TYPE == null;

  String get name => NAME?.text;

  OperationDefinitionContext(
      this.TYPE, this.NAME, this.variableDefinitions, this.selectionSet) {
    assert(TYPE == null ||
        TYPE.text == 'query' ||
        TYPE.text == 'mutation' ||
        TYPE.text == 'subscription');
  }

  @override
  FileSpan get span {
    if (TYPE == null) return selectionSet.span;
    var out = NAME == null ? TYPE.span : TYPE.span.expand(NAME.span);
    out = directives.fold<FileSpan>(out, (o, d) => o.expand(d.span));
    return out.expand(selectionSet.span);
  }
}
