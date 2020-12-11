import 'std_out.dart';

///  The [Queue] class represents a _firstNode-in-_firstNode-out (FIFO)
///  queue of generic items.
///  It supports the usual **enqueue** and **dequeue**
///  operations, along with methods for peeking at the _firstNode item,
///  testing if the queue is empty, and iterating through
///  the items in FIFO order.
///
///  This implementation uses a singly linked list with a static nested class for
///  linked-list nodes. See [LinkedQueue] for the version from the
///  textbook that uses a non-static nested class.
///  See [ResizingArrayQueue] for a version that uses a resizing array.
///  The **enqueue**, **dequeue**, **peek**, **size**, and **is-empty**
///  operations all take constant time in the worst case.
///
///  For additional documentation, see [Section 1.3](https://algs4.cs.princeton.edu/13stacks) of
///  *Algorithms, 4th Edition* by Robert Sedgewick and Kevin Wayne.
///
///  @author Robert Sedgewick
///  @author Kevin Wayne
///
///  [Item] the generic type of an item in this queue
class Queue<Item> implements Iterable<Item> {
  /// beginning of queue
  Node<Item>? _firstNode;

  /// end of queue
  Node<Item>? _lastNode;

  /// number of elements on queue
  int n = 0;

  /// Returns the number of items in this queue.

  @Deprecated('Please use [Queue.length] getter')
  int size() {
    return n;
  }

  /// Returns the item least recently added to this queue.
  ///
  /// Throws [StateError] if this queue is empty
  Item peek() {
    if (isEmpty) throw StateError('Queue underflow');
    return _firstNode!.item;
  }

  /// Adds the [item] to this queue.
  void enqueue(Item item) {
    var oldLastNode = _lastNode;

    _lastNode = Node<Item>(item);
    _lastNode!.next;

    if (isEmpty) {
      _firstNode = _lastNode;
    } else {
      oldLastNode!.next = _lastNode;
    }

    n++;
  }

  /// Removes and returns the item on this queue that was least recently added.
  /// @throws StateError if this queue is empty
  Item dequeue() {
    if (isEmpty) throw StateError('Queue underflow');
    var item = _firstNode!.item;

    _firstNode = _firstNode!.next;
    n--;

    // to avoid loitering
    if (isEmpty) _lastNode = null;
    return item!;
  }

  /// Return the sequence of items in a string representation and FIFO order, separated by spaces
  @override
  String toString() {
    var s = <Item>[];
    for (var item in this) {
      s.add(item);
    }
    return s.toString();
  }

  @override
  bool any(bool Function(Item element) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<R> cast<R>() {
    throw UnimplementedError();
  }

  @override
  Item elementAt(int index) {
    throw UnimplementedError();
  }

  @override
  bool every(bool Function(Item element) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Item element) f) {
    throw UnimplementedError();
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, Item element) combine) {
    throw UnimplementedError();
  }

  @override
  Iterable<Item> followedBy(Iterable<Item> other) {
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(Item element) fn) {
    for (var item in this) {
      fn(item);
    }
  }

  @override
  String join([String separator = '']) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> map<T>(T Function(Item e) fn) {
    final items = <T>[];

    for (var item in this) {
      items.add(fn(item));
    }

    return items;
  }

  @override
  Item reduce(Item Function(Item value, Item element) combine) {
    throw UnimplementedError();
  }

  @override
  Item get single => throw UnimplementedError();

  @override
  Item singleWhere(bool Function(Item element) test,
      {Item Function()? orElse}) {
    throw UnimplementedError();
  }

  @override
  Iterable<Item> skip(int count) {
    throw UnimplementedError();
  }

  @override
  Iterable<Item> skipWhile(bool Function(Item value) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<Item> take(int count) {
    throw UnimplementedError();
  }

  @override
  Iterable<Item> takeWhile(bool Function(Item value) test) {
    throw UnimplementedError();
  }

  @override
  List<Item> toList({bool growable = true}) {
    throw UnimplementedError();
  }

  @override
  Set<Item> toSet() {
    throw UnimplementedError();
  }

  @override
  Iterable<Item> where(bool Function(Item element) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> whereType<T>() {
    throw UnimplementedError();
  }

  /// Returns the number of items in this queue.
  @override
  int get length => n;

  @override
  bool get isEmpty => _firstNode == null;

  @override
  bool get isNotEmpty => _firstNode != null;

  @override
  Item get first => _firstNode!.item!;

  @override
  Item firstWhere(bool Function(Item element) test, {Item Function()? orElse}) {
    throw UnimplementedError();
  }

  @override
  Item get last => _lastNode!.item!;

  @override
  Item lastWhere(bool Function(Item element) test, {Item Function()? orElse}) {
    throw UnimplementedError();
  }

  @override
  Iterator<Item> get iterator => LinkedIterator(_firstNode!);

  @override
  bool contains(Object? element) {
    throw UnimplementedError();
  }
}

class Node<Item> {
  Item item;
  Node<Item>? next;
  Node(this.item);
}

class LinkedIterator<Item> implements Iterator<Item> {
  Node<Item>? _currentNode;
  Item? _currentItem;

  LinkedIterator(Node<Item> firstNode) {
    _currentNode = firstNode;
  }

  bool hasNext() {
    return _currentNode != null;
  }

  void remove() {
    throw UnsupportedError('unsupported remove method');
  }

  @override
  bool moveNext() {
    if (!hasNext()) return false;

    _currentItem = _currentNode!.item;
    _currentNode = _currentNode!.next;

    return _currentItem != null;
  }

  @override
  Item get current => _currentItem!;
}

/// Method to perform some tests of [Queue] data type it receive the command-line [arguments]
void main(List<String> arguments) {
  var queue = Queue<String>();

  arguments.asMap().forEach((i, item) {
    if (item != '-') {
      queue.enqueue(item);
    } else if (queue.isNotEmpty) {
      stdOut.println('${queue.dequeue()} ');
    }
  });

  stdOut.println('(${queue.length.toString()} left on queue)');
  stdOut.println('Queue: ${queue.toString()}');
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
