import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bill_item.dart';

class ItemAssignmentState extends Equatable {
  final List<BillItem> items;

  final Map<String, List<String>> itemToPeopleMap;

  final Map<String, String> itemModes;

  final Map<String, Map<String, int>> itemPortions;

  const ItemAssignmentState({
    this.items = const [],
    this.itemToPeopleMap = const {},
    this.itemModes = const {},
    this.itemPortions = const {},
  });

  String modeFor(String itemId) =>
      SplitMode.normalize(itemModes[itemId]);

  int totalPortionsFor(String itemId) {
    final map = itemPortions[itemId];
    if (map == null) return 0;
    return map.values.fold(0, (sum, v) => sum + v);
  }

  bool isItemAssigned(BillItem item) {
    final mode = modeFor(item.id);
    if (mode == SplitMode.quantity) {
      return totalPortionsFor(item.id) == item.quantity;
    }
    final assigned = itemToPeopleMap[item.id] ?? const [];
    return assigned.isNotEmpty;
  }

  List<BillItem> get unassignedItems =>
      items.where((i) => !isItemAssigned(i)).toList();

  bool get isFullyAssigned => unassignedItems.isEmpty;

  ItemAssignmentState copyWith({
    List<BillItem>? items,
    Map<String, List<String>>? itemToPeopleMap,
    Map<String, String>? itemModes,
    Map<String, Map<String, int>>? itemPortions,
  }) {
    return ItemAssignmentState(
      items: items ?? this.items,
      itemToPeopleMap: itemToPeopleMap ?? this.itemToPeopleMap,
      itemModes: itemModes ?? this.itemModes,
      itemPortions: itemPortions ?? this.itemPortions,
    );
  }

  @override
  List<Object?> get props =>
      [items, itemToPeopleMap, itemModes, itemPortions];
}

class ItemAssignmentViewModel extends StateNotifier<ItemAssignmentState> {
  ItemAssignmentViewModel({
    required List<BillItem> items,
  }) : super(ItemAssignmentState(
          items: items,
          itemToPeopleMap: {
            for (final item in items)
              item.id: List<String>.from(item.assignedPersonIds),
          },
          itemModes: {
            for (final item in items)
              item.id: SplitMode.normalize(item.splitMode),
          },
          itemPortions: {
            for (final item in items)
              item.id: Map<String, int>.from(item.portionsPerPerson),
          },
        ));

  void setItems(List<BillItem> items) {
    state = ItemAssignmentState(
      items: items,
      itemToPeopleMap: {
        for (final item in items)
          item.id: List<String>.from(state.itemToPeopleMap[item.id] ??
              item.assignedPersonIds),
      },
      itemModes: {
        for (final item in items)
          item.id: state.itemModes[item.id] ??
              SplitMode.normalize(item.splitMode),
      },
      itemPortions: {
        for (final item in items)
          item.id: Map<String, int>.from(state.itemPortions[item.id] ??
              item.portionsPerPerson),
      },
    );
  }

  void toggleAssignment(String itemId, String personId) {
    final current = List<String>.from(state.itemToPeopleMap[itemId] ?? []);
    if (current.contains(personId)) {
      current.remove(personId);
    } else {
      current.add(personId);
    }
    state = state.copyWith(
      itemToPeopleMap: {...state.itemToPeopleMap, itemId: current},
    );
  }

  void setMode(String itemId, String mode) {
    final normalized = SplitMode.normalize(mode);
    final newModes = {...state.itemModes, itemId: normalized};
    final updates = <String, dynamic>{};
    updates['modes'] = newModes;

    if (normalized == SplitMode.quantity) {
      final existing = state.itemPortions[itemId];
      if (existing == null || existing.isEmpty) {
        state = state.copyWith(
          itemModes: newModes,
          itemPortions: {...state.itemPortions, itemId: <String, int>{}},
        );
        return;
      }
    }

    state = state.copyWith(itemModes: newModes);
  }

  void incrementPortion(String itemId, String personId) {
    final item = state.items.firstWhere((i) => i.id == itemId);
    final portions = Map<String, int>.from(state.itemPortions[itemId] ?? {});
    final current = portions[personId] ?? 0;
    final totalAssigned = state.totalPortionsFor(itemId);
    if (totalAssigned >= item.quantity) return;
    portions[personId] = current + 1;
    state = state.copyWith(
      itemPortions: {...state.itemPortions, itemId: portions},
    );
  }

  void decrementPortion(String itemId, String personId) {
    final portions = Map<String, int>.from(state.itemPortions[itemId] ?? {});
    final current = portions[personId] ?? 0;
    if (current <= 0) return;
    if (current - 1 == 0) {
      portions.remove(personId);
    } else {
      portions[personId] = current - 1;
    }
    state = state.copyWith(
      itemPortions: {...state.itemPortions, itemId: portions},
    );
  }

  void assignAllItemsToAll(List<String> allPersonIds) {
    final newMap = <String, List<String>>{
      for (final item in state.items) item.id: List<String>.from(allPersonIds),
    };
    final newModes = <String, String>{
      for (final item in state.items) item.id: SplitMode.equal,
    };
    state = state.copyWith(itemToPeopleMap: newMap, itemModes: newModes);
  }

  void clearAssignments() {
    final newMap = <String, List<String>>{
      for (final item in state.items) item.id: const [],
    };
    state = state.copyWith(itemToPeopleMap: newMap);
  }

  List<BillItem> getItemsWithAssignments() {
    return state.items.map((i) {
      final mode = state.modeFor(i.id);
      if (mode == SplitMode.quantity) {
        final portions = state.itemPortions[i.id] ?? const <String, int>{};
        return i.copyWith(
          splitMode: SplitMode.quantity,
          portionsPerPerson: portions,
          assignedPersonIds: portions.keys.toList(),
        );
      }
      return i.copyWith(
        splitMode: SplitMode.equal,
        assignedPersonIds: state.itemToPeopleMap[i.id] ?? const [],
        portionsPerPerson: const {},
      );
    }).toList();
  }
}

final itemAssignmentViewModelProvider = StateNotifierProvider.autoDispose
    .family<ItemAssignmentViewModel, ItemAssignmentState, List<BillItem>>(
        (ref, items) {
  return ItemAssignmentViewModel(items: items);
});
