import 'package:flutter/material.dart';

import '../gallery_image_viewer.dart';

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {
  /// The image to display
  final ImageProvider imageProvider;

  /// Minimum scale factor
  final double minScale;

  /// Maximum scale factor
  final double maxScale;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(double)? onScaleChanged;

  final GalleryImageController? controller;

  /// Create a new instance
  const EasyImageView({
    Key? key,
    required this.imageProvider,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.onScaleChanged,
    this.controller,
  }) : super(key: key);

  @override
  _EasyImageViewState createState() => _EasyImageViewState();
}

class _EasyImageViewState extends State<EasyImageView> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    bool isHasButtons = widget.controller?.showEditButton == true ||
        widget.controller?.showDeleteButton == true;

    Widget buttons = Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: SafeArea(
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.controller?.onImageDeleted
                        ?.call(widget.imageProvider);
                  },
                ),
                Text(
                  "Delete",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                )
              ],
            ),
          ),
        ));

    Widget? customButtons() {
      return widget.controller?.buildCustomButtons?.call(callImageDelete: () {
        widget.controller?.onImageDeleted?.call(widget.imageProvider);
      }, callEditImage: () {
        widget.controller?.onEditImage?.call(widget.imageProvider);
      });
    }

    return Stack(
      children: [
        SizedBox.expand(
            key: const Key('easy_image_sized_box'),
            child: InteractiveViewer(
              key: const Key('easy_image_interactive_viewer'),
              transformationController: _transformationController,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
              child: Image(image: widget.imageProvider),
              onInteractionEnd: (scaleEndDetails) {
                double scale =
                    _transformationController.value.getMaxScaleOnAxis();

                if (widget.onScaleChanged != null) {
                  widget.onScaleChanged!(scale);
                }
              },
            )),
        isHasButtons ? (customButtons() ?? buttons) : Container(),
      ],
    );
  }
}
