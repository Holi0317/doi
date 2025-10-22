import 'package:flutter/material.dart';

import '../models/search_query.dart';

class FilterForm extends StatelessWidget {
  const FilterForm({
    super.key,
    required this.archive,
    required this.favorite,
    required this.order,
    required this.onArchiveChanged,
    required this.onFavoriteChanged,
    required this.onOrderChanged,
  });

  final bool? archive;
  final bool? favorite;
  final SearchOrder order;
  final ValueChanged<bool?> onArchiveChanged;
  final ValueChanged<bool?> onFavoriteChanged;
  final ValueChanged<SearchOrder> onOrderChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Archive'),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool?>(
              segments: const [
                ButtonSegment<bool?>(value: null, label: Text('All')),
                ButtonSegment<bool?>(value: true, label: Text('Archived')),
                ButtonSegment<bool?>(value: false, label: Text('Not Archived')),
              ],
              selected: {archive},
              onSelectionChanged: _handleSelection(onArchiveChanged),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Favorite'),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool?>(
              segments: const [
                ButtonSegment<bool?>(value: null, label: Text('All')),
                ButtonSegment<bool?>(value: true, label: Text('Favorited')),
                ButtonSegment<bool?>(
                  value: false,
                  label: Text('Not Favorited'),
                ),
              ],
              selected: {favorite},
              onSelectionChanged: _handleSelection(onFavoriteChanged),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Order'),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<SearchOrder>(
              segments: const [
                ButtonSegment<SearchOrder>(
                  value: SearchOrder.idDesc,
                  label: Text('Newest First'),
                ),
                ButtonSegment<SearchOrder>(
                  value: SearchOrder.idAsc,
                  label: Text('Oldest First'),
                ),
              ],
              selected: {order},
              onSelectionChanged: _handleSelection(onOrderChanged),
            ),
          ),
        ],
      ),
    );
  }

  ValueChanged<Set<T>> _handleSelection<T>(ValueChanged<T> onChanged) {
    return (Set<T> selection) {
      assert(
        selection.length == 1,
        "SegmentedButton should only allow single selection. Is the SegmentedButton misconfigured?",
      );
      onChanged(selection.first);
    };
  }
}
