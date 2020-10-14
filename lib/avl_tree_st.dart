import 'dart:core';
import 'dart:math' as math;
import 'queue.dart';
import 'std_out.dart';

class AVLTreeST<Key extends Comparable<Key>, Value> {
  /// The root node.
  Node<Key, Value> root;

  /// Checks if the symbol table is empty.
  /// Returns `true` if the symbol table is empty.
  bool isEmpty() {
    return root == null;
  }

  /// Returns the number key-value pairs in the symbol table.
  /// @return the number key-value pairs in the symbol table
  int size() {
    return _size(root);
  }

  /// Returns the number of nodes in the subtree.
  /// @param x the subtree
  /// @return the number of nodes in the subtree
  int _size(Node<Key, Value> x) {
    if (x == null) return 0;
    return x.size;
  }

  /// Returns the height of the internal AVL tree. It is assumed that the
  /// height of an empty tree is -1 and the height of a tree with just one node
  /// is 0.
  ///
  /// @return the height of the internal AVL tree
  int height() {
    return _height(root);
  }

  /// Returns the height of the subtree.
  ///
  /// @param x the subtree
  ///
  /// @return the height of the subtree.
  int _height(Node<Key, Value> x) {
    if (x == null) return -1;
    return x.height;
  }

  /// Returns the value associated with the given key.
  ///
  /// @param key the key
  /// @return the value associated with the given key if the key is in the
  ///         symbol table and {@code null} if the key is not in the
  ///         symbol table
  /// @throws ArgumentError if {@code key} is {@code null}
  Value get(Key key) {
    if (key == null) throw ArgumentError('argument to get() is null');
    var x = _get(root, key);
    if (x == null) return null;
    return x.val;
  }

  /// Returns value associated with the given key in the subtree or
  /// {@code null} if no such key.
  ///
  /// @param x the subtree
  /// @param key the key
  /// @return value associated with the given key in the subtree or
  ///         {@code null} if no such key
  Node<Key, Value> _get(Node<Key, Value> x, Key key) {
    if (x == null) return null;
    var cmp = key.compareTo(x.key);
    if (cmp < 0) {
      return _get(x.left, key);
    } else if (cmp > 0) {
      return _get(x.right, key);
    } else {
      return x;
    }
  }

  /// Checks if the symbol table contains the given key.
  ///
  /// @param key the key
  /// Returns `true` if the symbol table contains {@code key}
  ///     and {@code false} otherwise
  /// @throws ArgumentError if {@code key} is {@code null}
  bool contains(Key key) {
    return get(key) != null;
  }

  /// Inserts the specified key-value pair into the symbol table, overwriting
  /// the old value with the new value if the symbol table already contains the
  /// specified key. Deletes the specified key (and its associated value) from
  /// this symbol table if the specified value is {@code null}.
  ///
  /// @param key the key
  /// @param val the value
  /// @throws ArgumentError if {@code key} is {@code null}
  void put(Key key, Value val) {
    if (key == null) throw ArgumentError('first argument to put() is null');
    if (val == null) {
      delete(key);
      return;
    }
    root = _put(root, key, val);
    assert(check());
  }

  /// Inserts the key-value pair in the subtree. It overrides the old value
  /// with the new value if the symbol table already contains the specified key
  /// and deletes the specified key (and its associated value) from this symbol
  /// table if the specified value is {@code null}.
  ///
  /// @param x the subtree
  /// @param key the key
  /// @param val the value
  /// @return the subtree
  Node<Key, Value> _put(Node<Key, Value> x, Key key, Value val) {
    if (x == null) return Node(key, val, 0, 1);
    var cmp = key.compareTo(x.key);
    if (cmp < 0) {
      x.left = _put(x.left, key, val);
    } else if (cmp > 0) {
      x.right = _put(x.right, key, val);
    } else {
      x.val = val;
      return x;
    }
    x.size = 1 + _size(x.left) + _size(x.right);
    x.height = 1 + math.max(_height(x.left), _height(x.right));
    return balance(x);
  }

  /// Restores the AVL tree property of the subtree.
  ///
  /// @param x the subtree
  /// @return the subtree with restored AVL property
  Node<Key, Value> balance(Node<Key, Value> x) {
    if (_balanceFactor(x) < -1) {
      if (_balanceFactor(x.right) > 0) {
        x.right = _rotateRight(x.right);
      }
      x = rotateLeft(x);
    } else if (_balanceFactor(x) > 1) {
      if (_balanceFactor(x.left) < 0) {
        x.left = rotateLeft(x.left);
      }
      x = _rotateRight(x);
    }
    return x;
  }

  /// Returns the balance factor of the subtree. The balance factor is defined
  /// as the difference in height of the left subtree and right subtree, in
  /// this order. Therefore, a subtree with a balance factor of -1, 0 or 1 has
  /// the AVL property since the heights of the two child subtrees differ by at
  /// most one.
  ///
  /// @param x the subtree
  /// @return the balance factor of the subtree
  int _balanceFactor(Node<Key, Value> x) {
    return _height(x.left) - _height(x.right);
  }

  /// Rotates the given subtree to the right.
  ///
  /// @param x the subtree
  /// @return the right rotated subtree
  Node<Key, Value> _rotateRight(Node<Key, Value> x) {
    var y = x.left;
    x.left = y.right;
    y.right = x;
    y.size = x.size;
    x.size = 1 + _size(x.left) + _size(x.right);
    x.height = 1 + math.max(_height(x.left), _height(x.right));
    y.height = 1 + math.max(_height(y.left), _height(y.right));
    return y;
  }

  /// Rotates the given subtree to the left.
  ///
  /// @param x the subtree
  /// @return the left rotated subtree
  Node<Key, Value> rotateLeft(Node<Key, Value> x) {
    var y = x.right;
    x.right = y.left;
    y.left = x;
    y.size = x.size;
    x.size = 1 + _size(x.left) + _size(x.right);
    x.height = 1 + math.max(_height(x.left), _height(x.right));
    y.height = 1 + math.max(_height(y.left), _height(y.right));
    return y;
  }

  /// Removes the specified key and its associated value from the symbol table
  /// (if the key is in the symbol table).
  ///
  /// @param key the key
  /// @throws IllegalArgumentException if {@code key} is {@code null}
  void delete(Key key) {
    if (key == null) throw ArgumentError('argument to delete() is null');
    if (!contains(key)) return;
    root = _delete(root, key);
    assert(check());
  }

  /// Removes the specified key and its associated value from the given
  /// subtree.
  ///
  /// @param x the subtree
  /// @param key the key
  /// @return the updated subtree
  Node<Key, Value> _delete(Node<Key, Value> x, Key key) {
    var cmp = key.compareTo(x.key);
    if (cmp < 0) {
      x.left = _delete(x.left, key);
    } else if (cmp > 0) {
      x.right = _delete(x.right, key);
    } else {
      if (x.left == null) {
        return x.right;
      } else if (x.right == null) {
        return x.left;
      } else {
        var y = x;
        x = _min(y.right);
        x.right = _deleteMin(y.right);
        x.left = y.left;
      }
    }
    x.size = 1 + _size(x.left) + _size(x.right);
    x.height = 1 + math.max(_height(x.left), _height(x.right));
    return balance(x);
  }

  /// Removes the smallest key and associated value from the symbol table.
  ///
  /// @throws StateError if the symbol table is empty
  void deleteMin() {
    if (isEmpty()) {
      throw StateError('called deleteMin() with empty symbol table');
    }
    root = _deleteMin(root);
    assert(check());
  }

  /// Removes the smallest key and associated value from the given subtree.
  ///
  /// @param x the subtree
  /// @return the updated subtree
  Node<Key, Value> _deleteMin(Node<Key, Value> x) {
    if (x.left == null) return x.right;
    x.left = _deleteMin(x.left);
    x.size = 1 + _size(x.left) + _size(x.right);
    x.height = 1 + math.max(_height(x.left), _height(x.right));
    return balance(x);
  }

  /// Removes the largest key and associated value from the symbol table.
  ///
  /// @throws StateError if the symbol table is empty
  void deleteMax() {
    if (isEmpty()) {
      throw StateError('called deleteMax() with empty symbol table');
    }
    root = _deleteMax(root);
    assert(check());
  }

  /// Removes the largest key and associated value from the given subtree.
  ///
  /// @param x the subtree
  /// @return the updated subtree
  Node<Key, Value> _deleteMax(Node<Key, Value> x) {
    if (x.right == null) return x.left;
    x.right = _deleteMax(x.right);
    x.size = 1 + _size(x.left) + _size(x.right);
    x.height = 1 + math.max(_height(x.left), _height(x.right));
    return balance(x);
  }

  /// Returns the smallest key in the symbol table.
  ///
  /// @return the smallest key in the symbol table
  /// @throws StateError if the symbol table is empty
  Key min() {
    if (isEmpty()) throw StateError('called min() with empty symbol table');
    return _min(root).key;
  }

  /// Returns the node with the smallest key in the subtree.
  ///
  /// @param x the subtree
  /// @return the node with the smallest key in the subtree
  Node<Key, Value> _min(Node<Key, Value> x) {
    if (x.left == null) return x;
    return _min(x.left);
  }

  /// Returns the largest key in the symbol table.
  ///
  /// @return the largest key in the symbol table
  /// @throws StateError if the symbol table is empty
  Key max() {
    if (isEmpty()) throw StateError('called max() with empty symbol table');
    return _max(root).key;
  }

  /// Returns the node with the largest key in the subtree.
  ///
  /// @param x the subtree
  /// @return the node with the largest key in the subtree
  Node<Key, Value> _max(Node<Key, Value> x) {
    if (x.right == null) return x;
    return _max(x.right);
  }

  /// Returns the largest key in the symbol table less than or equal to [key].
  ///
  /// Throws `StateError` if the symbol table **is empty** or `ArgumentError` if [key] is `null`
  Key floor(Key key) {
    if (key == null) throw ArgumentError('argument to floor() is null');
    if (isEmpty()) {
      throw StateError('called floor() with empty symbol table');
    }
    var x = _floor(root, key);
    if (x == null) {
      return null;
    } else {
      return x.key;
    }
  }

  /// Returns the node in the subtree with the largest key less than or equal
  /// to the given key.
  ///
  /// @param x the subtree
  /// @param key the key
  /// @return the node in the subtree with the largest key less than or equal
  ///         to the given key
  Node<Key, Value> _floor(Node<Key, Value> x, Key key) {
    if (x == null) return null;
    var cmp = key.compareTo(x.key);
    if (cmp == 0) return x;
    if (cmp < 0) return _floor(x.left, key);
    var y = _floor(x.right, key);
    if (y != null) {
      return y;
    } else {
      return x;
    }
  }

  /// Returns the smallest key in the symbol table greater than or equal to
  /// {@code key}.
  ///
  /// @param key the key
  /// @return the smallest key in the symbol table greater than or equal to
  ///         {@code key}
  /// Throws `StateError` if the symbol table **is empty** or `ArgumentError` if [key] is `null`
  Key ceiling(Key key) {
    if (key == null) ArgumentError('argument to ceiling() is null');
    if (isEmpty()) StateError('called ceiling() with empty symbol table');
    var x = _ceiling(root, key);
    if (x == null) {
      return null;
    } else {
      return x.key;
    }
  }

  /// Returns the node in the subtree with the smallest key greater than or
  /// equal to the given key.
  ///
  /// @param x the subtree
  /// @param key the key
  /// @return the node in the subtree with the smallest key greater than or
  ///         equal to the given key
  Node<Key, Value> _ceiling(Node<Key, Value> x, Key key) {
    if (x == null) return null;
    var cmp = key.compareTo(x.key);
    if (cmp == 0) return x;
    if (cmp > 0) return _ceiling(x.right, key);
    var y = _ceiling(x.left, key);
    if (y != null) {
      return y;
    } else {
      return x;
    }
  }

  /// Returns the kth smallest key in the symbol table.
  ///
  /// @param k the order statistic
  /// @return the kth smallest key in the symbol table
  /// @throws IllegalArgumentException unless {@code k} is between 0 and
  ///             {@code size() -1 }
  Key select(int k) {
    if (k < 0 || k >= size()) {
      throw ArgumentError('k is not in range 0-' + (size() - 1).toString());
    }
    var x = _select(root, k);
    return x.key;
  }

  /// Returns the node with key the kth smallest key in the subtree.
  ///
  /// @param x the subtree
  /// @param k the kth smallest key in the subtree
  /// @return the node with key the kth smallest key in the subtree
  Node<Key, Value> _select(Node<Key, Value> x, int k) {
    if (x == null) return null;
    var t = _size(x.left);
    if (t > k) {
      return _select(x.left, k);
    } else if (t < k) {
      return _select(x.right, k - t - 1);
    } else {
      return x;
    }
  }

  /// Returns the number of keys in the symbol table strictly less than [key].
  /// Throws ArgumentError if [key] is `null`
  int rank(Key key) {
    if (key == null) throw ArgumentError('argument to rank() is null');
    return _rank(key, root);
  }

  /// Returns the number of keys in the [subtree] less than [key].
  int _rank(Key key, Node<Key, Value> subtree) {
    if (subtree == null) return 0;
    var cmp = key.compareTo(subtree.key);
    if (cmp < 0) {
      return _rank(key, subtree.left);
    } else if (cmp > 0) {
      return 1 + _size(subtree.left) + _rank(key, subtree.right);
    } else {
      return _size(subtree.left);
    }
  }

  /// Returns all keys in the symbol table.
  Iterable<Key> keys() {
    return keysInOrder();
  }

  /// Returns all keys in the symbol table following an in-order traversal.
  ///
  /// @return all keys in the symbol table following an in-order traversal
  Iterable<Key> keysInOrder() {
    var queue = Queue<Key>();
    _keysInOrder(root, queue);
    return queue;
  }

  /// Adds the keys in the subtree to queue following an in-order traversal.
  ///
  /// @param x the subtree
  /// @param queue the queue
  void _keysInOrder(Node<Key, Value> x, Queue<Key> queue) {
    if (x == null) return;
    _keysInOrder(x.left, queue);
    queue.enqueue(x.key);
    _keysInOrder(x.right, queue);
  }

  /// Returns all keys in the symbol table following a level-order traversal.
  ///
  /// @return all keys in the symbol table following a level-order traversal.
  Iterable<Key> keysLevelOrder() {
    var queue = Queue<Key>();
    if (!isEmpty()) {
      var queue2 = Queue<Node<Key, Value>>();
      queue2.enqueue(root);
      while (queue2.isNotEmpty) {
        var x = queue2.dequeue();
        queue.enqueue(x.key);
        if (x.left != null) {
          queue2.enqueue(x.left);
        }
        if (x.right != null) {
          queue2.enqueue(x.right);
        }
      }
    }
    return queue;
  }

  /// Returns all keys in the symbol table in the given range.
  ///
  /// @param lo the lowest key
  /// @param hi the highest key
  /// @return all keys in the symbol table between {@code lo} (inclusive)
  ///         and {@code hi} (exclusive)
  /// @throws ArgumentError if either {@code lo} or {@code hi}
  ///             is {@code null}
  Iterable<Key> keysByRange(Key lo, Key hi) {
    if (lo == null) throw ArgumentError('first argument to keys() is null');
    if (hi == null) throw ArgumentError('second argument to keys() is null');
    var queue = Queue<Key>();
    _keysByRange(root, queue, lo, hi);
    return queue;
  }

  /// Adds the keys between [lo] and [hi] in the subtree to the `queue`.
  void _keysByRange(Node<Key, Value> x, Queue<Key> queue, Key lo, Key hi) {
    if (x == null) return;
    var cmplo = lo.compareTo(x.key);
    var cmphi = hi.compareTo(x.key);
    if (cmplo < 0) _keysByRange(x.left, queue, lo, hi);
    if (cmplo <= 0 && cmphi >= 0) queue.enqueue(x.key);
    if (cmphi > 0) _keysByRange(x.right, queue, lo, hi);
  }

  /// Returns the number of keys in the symbol table
  /// between [lo] (minimum endpoint) and [hi] (maximum endpoint).
  ///
  /// Throws ArgumentError if either [lo] or [hi] is `null`
  int sizeByKeys(Key lo, Key hi) {
    if (lo == null) throw ArgumentError('first argument to size() is null');
    if (hi == null) throw ArgumentError('second argument to size() is null');
    if (lo.compareTo(hi) > 0) return 0;
    if (contains(hi)) {
      return rank(hi) - rank(lo) + 1;
    } else {
      return rank(hi) - rank(lo);
    }
  }

  /// Returns `true` if the AVL tree invariants are fine
  bool check() {
    if (!isBST()) stdOut.println('Symmetric order not consistent');
    if (!isAVL()) stdOut.println('AVL property not consistent');
    if (!isSizeConsistent()) stdOut.println('Subtree counts not consistent');
    if (!isRankConsistent()) stdOut.println('Ranks not consistent');
    return isBST() && isAVL() && isSizeConsistent() && isRankConsistent();
  }

  /// Returns `true` if AVL property is consistent.
  bool isAVL() {
    return _isAVL(root);
  }

  /// Returns `true` if AVL property is consistent in the [subtree]
  bool _isAVL(Node<Key, Value> subtree) {
    if (subtree == null) return true;
    var bf = _balanceFactor(subtree);
    if (bf > 1 || bf < -1) return false;
    return _isAVL(subtree.left) && _isAVL(subtree.right);
  }

  /// Returns `true` if the symmetric order is consistent
  bool isBST() {
    return _isBST(root, null, null);
  }

  /// Checks if the tree rooted at [x] is a BST with all keys strictly between
  /// the minimum key ([min]) and the maximum key ([max]). if [min] or [max] is null, treat as
  /// empty constraint (Credit: **Bob Dondero's** elegant solution).
  ///
  /// Returns `true` if the symmetric order is consistent
  bool _isBST(Node<Key, Value> x, Key min, Key max) {
    if (x == null) return true;
    if (min != null && x.key.compareTo(min) <= 0) return false;
    if (max != null && x.key.compareTo(max) >= 0) return false;
    return _isBST(x.left, min, x.key) && _isBST(x.right, x.key, max);
  }

  /// Checks if size is consistent.
  ///
  /// Returns `true` if size is consistent
  bool isSizeConsistent() {
    return _isSizeConsistent(root);
  }

  /// Checks if the size of the subtree is consistent.
  ///
  /// Returns `true` if the size of the subtree is consistent
  bool _isSizeConsistent(Node x) {
    if (x == null) return true;
    if (x.size != _size(x.left) + _size(x.right) + 1) return false;
    return _isSizeConsistent(x.left) && _isSizeConsistent(x.right);
  }

  /// Checks if rank is consistent.
  ///
  /// Returns `true` if rank is consistent
  bool isRankConsistent() {
    for (var i = 0; i < size(); i++) {
      if (i != rank(select(i))) return false;
    }
    for (var key in keys()) {
      if (key.compareTo(select(rank(key))) != 0) return false;
    }
    return true;
  }
}

/// This class represents an inner node of the AVL tree.
class Node<Key, Value> {
  Key key; // the key
  Value val; // the associated value
  int height; // height of the subtree
  int size; // number of nodes in subtree
  Node<Key, Value> left; // left subtree
  Node<Key, Value> right; // right subtree

  Node(Key key, Value val, int height, int size) {
    this.key = key;
    this.val = val;
    this.size = size;
    this.height = height;
  }
}

/// Unit tests the {`AVLTreeST`} data type.
///
/// [arguments] the command-line arguments
void main(List<String> arguments) {
  var st = AVLTreeST<String, int>();
  arguments.asMap().forEach((i, element) {
    st.put(element, i);
  });

  for (var s in st.keys()) {
    stdOut.println('${s} a');
  }
  stdOut.println('');
}

/******************************************************************************
 *  Copyright 2002-2020, Robert Sedgewick and Kevin Wayne.
 *
 *  This file is part of algs4.jar, which accompanies the textbook
 *
 *      Algorithms, 4th edition by Robert Sedgewick and Kevin Wayne,
 *      Addison-Wesley Professional, 2011, ISBN 0-321-57351-X.
 *      http://algs4.cs.princeton.edu
 *
 *
 *  algs4.jar is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  algs4.jar is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with algs4.jar.  If not, see http://www.gnu.org/licenses.
 ******************************************************************************/
