import 'package:animate_do/animate_do.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:outlined_text/outlined_text.dart';

class TopWigdet extends StatefulWidget {
  final String title;
  final bool showBack;
  final bool showSearch;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onCloseSearch;
  const TopWigdet(
      {super.key,
      required this.title,
      this.showBack = false,
      this.showSearch = false,
      this.onSearch,
      this.onCloseSearch});

  @override
  State<TopWigdet> createState() => _TopWigdetState();
}

class _TopWigdetState extends State<TopWigdet> {
  TextEditingController controller = TextEditingController();
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Utils.colorTop,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Utils.radiusCircular),
            bottomRight: Radius.circular(Utils.radiusCircular)),
      ),
      child: Stack(
        children: [
          _TopBackgroundWidget(),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.showBack) _arrowBack(context),
                if (!widget.showBack) _titleSimple(),
                if (widget.showBack) _titleBack(context),
                if (widget.showSearch) _search(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _search(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      width: isExpanded ? MediaQuery.of(context).size.width * 0.85 : 52,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(isExpanded ? 30 : 40),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isExpanded
            ? Row(
                spacing: 10,
                children: [
                  CustomInkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Utils.colorIcon),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      maxLength: 50,
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(
                            fontSize: 18, color: Utils.circulo2, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        counter: SizedBox.shrink(),
                        focusedBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontSize: 18, color: Utils.circulo2, fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        widget.onSearch?.call(value);
                      },
                    ),
                  ),
                  CustomInkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                        FocusScope.of(context).unfocus();
                        controller.text = '';
                        widget.onCloseSearch?.call();
                      });
                    },
                    child: Icon(Icons.clear, color: Utils.colorIcon),
                  ),
                  const SizedBox(width: 5),
                ],
              )
            : CustomInkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                    FocusScope.of(context).unfocus();
                  });
                },
                child: Icon(Icons.search, size: 28, color: Utils.colorIcon),
              ),
      ),
    );
  }

  Widget _titleBack(BuildContext context) {
    return Expanded(
      child: AnimatedOpacity(
        opacity: isExpanded ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: Visibility(
          visible: !isExpanded,
          maintainSize: false,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: OutlinedText(
                text: Text(
                  widget.title,
                  style: TextStyle(
                    color: Utils.colorFontTop,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                strokes: [
                  OutlinedTextStroke(
                    color: Utils.circulo1,
                    width: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleSimple() {
    return Expanded(
      child: AnimatedOpacity(
        opacity: isExpanded ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 750),
        child: Visibility(
          visible: !isExpanded,
          child: Center(
            child: OutlinedText(
              text: Text(
                widget.title,
                style: TextStyle(
                  color: Utils.colorFontTop,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              strokes: [
                OutlinedTextStroke(
                  color: Utils.circulo1,
                  width: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _arrowBack(BuildContext context) {
    return CustomInkWell(
      onTap: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back_ios_new, size: Utils.iconSize, color: Utils.circulo4),
    );
  }
}

class _TopBackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(Utils.radiusCircular),
        bottomRight: Radius.circular(Utils.radiusCircular),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -50,
            top: -70,
            child: ZoomIn(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Utils.circulo1,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -130,
            right: -70,
            child: ZoomIn(
              child: Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  color: Utils.circulo2,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: -220,
            right: -30,
            child: ZoomIn(
              child: Container(
                width: 310,
                height: 310,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Utils.circulo3, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            left: 80,
            bottom: 15,
            child: ZoomIn(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Utils.circulo4,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
