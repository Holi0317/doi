import 'package:flutter/material.dart';

import '../i18n/strings.g.dart';
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
          Text(t.filter.archive.title),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool?>(
              segments: [
                ButtonSegment<bool?>(
                  value: null,
                  label: Text(t.filter.archive.all),
                ),
                ButtonSegment<bool?>(
                  value: true,
                  label: Text(t.filter.archive.oui),
                ),
                ButtonSegment<bool?>(
                  value: false,
                  label: Text(t.filter.archive.non),
                ),
              ],
              selected: {archive},
              onSelectionChanged: _handleSelection(onArchiveChanged),
            ),
          ),

          const SizedBox(height: 16),
          Text(t.filter.favorite.title),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool?>(
              segments: [
                ButtonSegment<bool?>(
                  value: null,
                  label: Text(t.filter.favorite.all),
                ),
                ButtonSegment<bool?>(
                  value: true,
                  label: Text(t.filter.favorite.oui),
                ),
                ButtonSegment<bool?>(
                  value: false,
                  label: Text(t.filter.favorite.non),
                ),
              ],
              selected: {favorite},
              onSelectionChanged: _handleSelection(onFavoriteChanged),
            ),
          ),

          const SizedBox(height: 16),
          Text(t.filter.order.title),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<SearchOrder>(
              segments: [
                ButtonSegment<SearchOrder>(
                  value: SearchOrder.createdAtDesc,
                  label: Text(t.filter.order.newestFirst),
                ),
                ButtonSegment<SearchOrder>(
                  value: SearchOrder.createdAtAsc,
                  label: Text(t.filter.order.oldestFirst),
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
