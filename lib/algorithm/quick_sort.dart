/// Sorts [items] in place using the recursive Lomuto quicksort from
/// quick_sort.cpp. [compare] should return a negative, zero, or positive value.
void quickSort<T>(List<T> items, int Function(T left, T right) compare) {
  if (items.length < 2) return;
  _quickSort(items, 0, items.length - 1, compare);
}

void _quickSort<T>(
  List<T> items,
  int low,
  int high,
  int Function(T left, T right) compare,
) {
  if (low >= high) return;

  final pivotIndex = _partition(items, low, high, compare);
  _quickSort(items, low, pivotIndex - 1, compare);
  _quickSort(items, pivotIndex + 1, high, compare);
}

int _partition<T>(
  List<T> items,
  int low,
  int high,
  int Function(T left, T right) compare,
) {
  final pivot = items[high];
  var smallerEnd = low - 1;

  for (var current = low; current < high; current++) {
    if (compare(items[current], pivot) <= 0) {
      smallerEnd++;
      final temporary = items[smallerEnd];
      items[smallerEnd] = items[current];
      items[current] = temporary;
    }
  }

  final pivotPosition = smallerEnd + 1;
  items[high] = items[pivotPosition];
  items[pivotPosition] = pivot;
  return pivotPosition;
}
