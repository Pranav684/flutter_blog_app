import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DescriptionArea extends StatefulWidget {
  const DescriptionArea({super.key});

  @override
  State<DescriptionArea> createState() => _DescriptionAreaState();
}

class _DescriptionAreaState extends State<DescriptionArea> {
  final QuillController _controller = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        color: AppColors.whiteColor,
        child: Column(
          children: [
            QuillSimpleToolbar(
              controller: _controller,
              config: QuillSimpleToolbarConfig(
                showBoldButton: true,
                showItalicButton: true,
                showQuote: true,
                showListBullets: true,
                showListNumbers: true,
                showUnderLineButton: false,
                showStrikeThrough: false,
                showUndo: false,
                showRedo: false,
                showLink: false,
                showSearchButton: false,
                showFontFamily: false,
                showFontSize: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showInlineCode: false,
                showLeftAlignment: false,
                showRightAlignment: false,
                showHeaderStyle: false,
                buttonOptions:QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        color: AppColors.blackColor,
                      ),
                      iconButtonUnselectedData: IconButtonData(
                        color: AppColors.midGreyColor
                      )
                    )
                  )
                )
              ),
            ),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: QuillEditor.basic(
                    controller: _controller,
                    config: const QuillEditorConfig(
                      placeholder: "Start writing...",
                      expands: true,
                      padding: EdgeInsets.zero,
                      autoFocus: true,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
