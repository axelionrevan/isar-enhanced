import 'package:flutter/material.dart';
import 'package:isar_inspector/app_state.dart';
import 'package:isar_inspector/common.dart';
import 'package:isar_inspector/schema.dart';
import 'package:provider/provider.dart';

class CollectionsList extends StatelessWidget {
  const CollectionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return ListView.builder(itemBuilder: (context, index) {
          final collection = state.collections.elementAt(index);
                return _buildCollection(
                  context,
                  collection,
                  state.selectedCollection == collection,
                );
        }, itemCount: state.collections.length,);
      },
    );
  }

  Widget _buildCollection(
      BuildContext context, Collection collection, bool selected) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50,
      child: IsarCard(
        color: selected ? theme.primaryColor : null,
        radius: BorderRadius.circular(15),
        onTap: () {
          Provider.of<AppState>(context, listen: false).selectedCollection =
              collection;
        },
        child: Center(
          child: Text(
            collection.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
