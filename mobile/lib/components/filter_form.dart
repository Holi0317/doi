import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t.archive),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool?>(
              segments: [
                ButtonSegment<bool?>(value: null, label: Text(t.all)),
                ButtonSegment<bool?>(value: true, label: Text(t.archived)),
                ButtonSegment<bool?>(value: false, label: Text(t.notArchived)),
              ],
              selected: {archive},
              onSelectionChanged: _handleSelection(onArchiveChanged),
            ),
          ),

          const SizedBox(height: 16),
          Text(t.favorite),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool?>(
              segments: [
                ButtonSegment<bool?>(value: null, label: Text(t.all)),
                ButtonSegment<bool?>(value: true, label: Text(t.favorited)),
                ButtonSegment<bool?>(value: false, label: Text(t.notFavorited)),
              ],
              selected: {favorite},
              onSelectionChanged: _handleSelection(onFavoriteChanged),
            ),
          ),

          const SizedBox(height: 16),
          Text(t.order),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<SearchOrder>(
              segments: [
                ButtonSegment<SearchOrder>(
                  value: SearchOrder.idDesc,
                  label: Text(t.newestFirst),
                ),
                ButtonSegment<SearchOrder>(
                  value: SearchOrder.idAsc,
                  label: Text(t.oldestFirst),
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
