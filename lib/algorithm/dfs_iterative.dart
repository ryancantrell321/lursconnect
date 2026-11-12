/// Returns graph nodes in iterative depth-first order.
///
/// Each list in [graph] contains the neighboring node indexes. The traversal
/// follows the stack-based approach used in DFS_iterative.cpp.
List<int> depthFirstSearch(List<List<int>> graph, int start) {
  if (start < 0 || start >= graph.length) {
    throw RangeError('Start node $start is outside the graph.');
  }

  final visited = List<bool>.filled(graph.length, false);
  final stack = <int>[start];
  final traversal = <int>[];
  visited[start] = true;

  while (stack.isNotEmpty) {
    final node = stack.removeLast();
    traversal.add(node);

    for (final neighbor in graph[node]) {
      if (neighbor < 0 || neighbor >= graph.length) {
        throw RangeError('Graph contains an invalid node: $neighbor');
      }
      if (!visited[neighbor]) {
        visited[neighbor] = true;
        stack.add(neighbor);
      }
    }
  }

  return traversal;
}

/// Searches member records by walking them with an explicit stack.
/// Name, phone, year, panel type, and position are searchable.
List<Map<String, dynamic>> searchMembersWithDfs(
  List<Map<String, dynamic>> members,
  String query,
) {
  final searchText = query.trim().toLowerCase();
  if (searchText.isEmpty) return List<Map<String, dynamic>>.from(members);

  final stack = members.reversed.toList();
  final matches = <Map<String, dynamic>>[];
  const searchableFields = [
    'full_name',
    'phone',
    'committee_year',
    'position_type',
    'position',
  ];

  while (stack.isNotEmpty) {
    final member = stack.removeLast();
    final matchesQuery = searchableFields.any((field) {
      final value = member[field]?.toString().toLowerCase() ?? '';
      return value.contains(searchText);
    });

    if (matchesQuery) matches.add(member);
  }

  return matches;
}
