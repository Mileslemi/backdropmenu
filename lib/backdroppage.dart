import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BackDropPage extends StatefulWidget {
  const BackDropPage({Key? key}) : super(key: key);

  @override
  _BackdropPageState createState() => _BackdropPageState();
}

class _BackdropPageState extends State<BackDropPage>
    with SingleTickerProviderStateMixin {
  static const arrowPanelHeight = 32.0;

  late AnimationController _controller;

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - arrowPanelHeight;
    const double bottom = -arrowPanelHeight;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Menu Here",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              elevation: 12.0,
              child: Stack(children: <Widget>[
                Container(
                  color: Colors.amber.shade100,
                  child: const Center(
                    child: Text("content"),
                  ),
                ),
                SizedBox(
                  height: arrowPanelHeight,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        _controller.fling(
                            velocity: _isPanelVisible ? -1.0 : 1.0);
                      },
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_arrow,
                        progress: _controller.view,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Click Below Arrow For Menu"),
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
