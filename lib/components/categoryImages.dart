
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';

class ScrollSpy extends StatefulWidget {
  @override
  _ScrollSpyState createState() => _ScrollSpyState();
}

class _ScrollSpyState extends State<ScrollSpy> {
  late LScrollSpyController _controller;
  List<String> ids = ["0", "1", "2", "3", "4", "5"];
  late String activeId;

  @override
  void initState() {
    super.initState();
    _controller = LScrollSpyController(activeCheckOffset: 150.0)
      ..addListener(() {
          setState(() {
            activeId = _controller.activeID;
          });
        },
      );

    activeId = _controller.activeID ?? ids.first;
  }

  @override
  Widget build(BuildContext context) {
    return LCard(
      width: 450.0,
      body: LCardBody(
        child: LRow(
          useMediaQuery: false,
          axis: LRowAxis(xs: Axis.horizontal),
          columns: [
            LColumn(
              xs: 3,
              children: [
                for (final id in ids)
                  LFlatButton.text(
                    text: (int.parse(id) + 1).toString(),
                    type: activeId == id
                        ? LElementType.warning
                        : LElementType.primary,
                    onPressed: () => _controller.scrollTo(id),
                  )
              ],
            ),
            LColumn(
              children: [
                Container(
                  height: 270.0,
                  child: LScrollSpy(
                      controller: _controller,
                      uniqueIdList: ids,
                      itemBuilder: (context, index) => Container(
                        color: Colors.blue[(index + 2) * 100],
                        alignment: Alignment.center,
                        child: LText(" l.h1{ index1 }"),
                      ),
                      itemExtentBuilder: (index, id) => 120.0 * (index + 1),
                      itemCount: ids.length),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

