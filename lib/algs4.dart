import 'avl_tree_st.dart' as avl_tree_st;
import 'queue.dart' as queue;
import 'std_out.dart';


int calculate(List<String> args) {
  return 6 * 7;
}

void main(List<String> args) {
  avl_tree_st.main(args);
  queue.main(args);

  stdOut.println('Hello world: ${calculate(args)}!');
}

