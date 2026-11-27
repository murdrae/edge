// SignalPriorityScreen (lib/ui2/profile/devices.dart) reorders with
// `ids.insert(to, ids.removeAt(from))`, relying on onReorderItem handing over
// `to` already adjusted for the removed row. The deprecated onReorder passed
// the index BEFORE removal and needed `to > from ? to - 1 : to`; mixing the
// two up moves a dragged-down row one slot too far. Pin the contract with a
// real drag in both directions.
import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<List<String>> drag(WidgetTester t, String label, double dy) async {
    var ids = ['a', 'b', 'c', 'd'];
    await t.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (c, setState) => ReorderableListView(
            onReorderItem: (from, to) => setState(() {
              // Same expression as SignalPriorityScreen.
              final next = [...ids];
              next.insert(to, next.removeAt(from));
              ids = next;
            }),
            children: [
              for (final id in ids)
                SizedBox(key: ValueKey(id), height: 50, child: Text(id)),
            ],
          ),
        ),
      ),
    ));
    final g = await t.startGesture(t.getCenter(find.text(label)));
    await t.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await g.moveBy(Offset(0, dy));
    await t.pump(const Duration(milliseconds: 500));
    await g.up();
    await t.pumpAndSettle();
    return ids;
  }

  // The deprecated onReorder's off-by-one only shows when dragging DOWN, so a
  // down-drag and an up-drag of the same distance must move the row the same
  // number of slots.
  for (final dy in [80.0, 130.0]) {
    testWidgets('a ${dy}px drag moves a row the same slots down and up',
        (t) async {
      final down = await drag(t, 'a', dy);
      final up = await drag(t, 'd', -dy);
      final slots = down.indexOf('a');
      expect(slots, greaterThan(0), reason: 'the drag moved nothing: $down');
      expect(down.where((id) => id != 'a'), ['b', 'c', 'd']);
      expect(up.indexOf('d'), 3 - slots, reason: 'down $down, up $up');
      expect(up.where((id) => id != 'd'), ['a', 'b', 'c']);
    });
  }
}
