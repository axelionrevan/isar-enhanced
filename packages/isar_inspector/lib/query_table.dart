import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';
import 'package:isar_inspector/common.dart';
import 'package:isar_inspector/prev_next.dart';
import 'package:isar_inspector/schema.dart';
import 'package:isar_inspector/state/collections_state.dart';
import 'package:isar_inspector/state/query_state.dart';

import 'state/instances_state.dart';
import 'state/isar_connect_state_notifier.dart';

const _deleteColWidth = 60.0;

class QueryTable extends ConsumerWidget {
  const QueryTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(selectedCollectionPod).value!;
    final objects = ref.watch(queryResultsPod).value?.objects ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                IsarCard(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var property in collection.allProperties)
                        HeaderProperty(property: property),
                      const SizedBox(width: _deleteColWidth),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i = 0; i < objects.length; i++)
                          TableRow(
                            collection: collection,
                            object: objects[i],
                            index: i,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const PrevNext(),
      ],
    );
  }
}

class HeaderProperty extends ConsumerWidget {
  final IProperty property;

  const HeaderProperty({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sortProperty = ref.watch(querySortPod);

    return IsarCard(
      onTap: () {
        SortProperty? newSortProperty;
        if (sortProperty?.property == property.name) {
          if (sortProperty!.sort == Sort.asc) {
            newSortProperty = SortProperty(
              property: property.name,
              sort: Sort.desc,
            );
          }
        } else if (property.type.sortable) {
          newSortProperty = SortProperty(
            property: property.name,
            sort: sortProperty == null && property.isId ? Sort.desc : Sort.asc,
          );
        }
        ref.read(querySortPod.state).state = newSortProperty;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: SizedBox(
          width: property.type.width,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      property.isId ? 'Id' : property.type.name,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (sortProperty?.property == property.name)
                Icon(
                  sortProperty!.sort == Sort.asc
                      ? FontAwesomeIcons.caretUp
                      : FontAwesomeIcons.caretDown,
                  size: 20,
                )
              else if (sortProperty == null && property.isId)
                const Icon(
                  FontAwesomeIcons.caretUp,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableRow extends ConsumerWidget {
  final ICollection collection;
  final int index;
  final QueryObject object;

  const TableRow({
    Key? key,
    required this.collection,
    required this.index,
    required this.object,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IsarCard(
      color: index % 2 == 0 ? Colors.transparent : null,
      radius: BorderRadius.circular(15),
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var property in collection.allProperties)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: SizedBox(
                width: property.type.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      object.getValue(property.name),
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(
            width: _deleteColWidth,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.delete),
                splashRadius: 25,
                onPressed: () {
                  final collection =
                      ref.read(selectedCollectionPod).valueOrNull;
                  if (collection == null) return;

                  final query = ConnectQuery(
                    instance: ref.read(selectedInstanceNamePod),
                    collection: collection.name,
                    filter: FilterCondition.equalTo(
                      property: collection.idName,
                      value: int.parse(object.getValue(collection.idName)),
                    ),
                  );
                  ref.read(isarConnectPod.notifier).removeQuery(query);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
