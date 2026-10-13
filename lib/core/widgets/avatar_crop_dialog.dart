// app/lib/core/widgets/avatar_crop_dialog.dart
// Square crop dialog: shows the picked image, zoom slider, Save/Cancel.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';

/// Shows a picker then the crop dialog.
/// Returns the cropped [File] and its mimeType, or null if cancelled.
Future<(File, String)?> pickAndCropAvatar(BuildContext context) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 90,
  );
  if (picked == null) return null;

  final file = File(picked.path);
  final mime = picked.mimeType ?? 'image/jpeg';

  if (!context.mounted) return null;

  final result = await showDialog<File>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AvatarCropDialog(imageFile: file),
  );

  if (result == null) return null;
  return (result, mime);
}

class _AvatarCropDialog extends StatefulWidget {
  final File imageFile;
  const _AvatarCropDialog({required this.imageFile});

  @override
  State<_AvatarCropDialog> createState() => _AvatarCropDialogState();
}

class _AvatarCropDialogState extends State<_AvatarCropDialog> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _startOffset = Offset.zero;
  double _startScale = 1.0;
  bool _saving = false;
  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cropSize = math.min(screenWidth * 0.8, 360.0);

    return Dialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.panel)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Crop your photo',
              style: AppText.cardTitle.copyWith(color: c.textPrimary)),
            const SizedBox(height: 20),
            // Crop area
            RepaintBoundary(
              key: _repaintKey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cropSize / 2),
                child: SizedBox(
                  width: cropSize,
                  height: cropSize,
                  child: GestureDetector(
                    onScaleStart: (d) {
                      _startOffset = _offset - d.focalPoint;
                      _startScale = _scale;
                    },
                    onScaleUpdate: (d) {
                      setState(() {
                        _scale = (_startScale * d.scale).clamp(1.0, 4.0);
                        _offset = d.focalPoint + _startOffset;
                      });
                    },
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(_offset.dx, _offset.dy)
                        ..scale(_scale),
                      child: Image.file(
                        widget.imageFile,
                        width: cropSize,
                        height: cropSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Zoom slider
            Row(
              children: [
                Icon(Icons.zoom_out, size: 18, color: c.textMuted),
                Expanded(
                  child: Slider(
                    value: _scale,
                    min: 1.0,
                    max: 4.0,
                    activeColor: c.primary,
                    inactiveColor: c.surfaceAlt,
                    onChanged: (v) => setState(() => _scale = v),
                  ),
                ),
                Icon(Icons.zoom_in, size: 18, color: c.textMuted),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: c.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.control)),
                      minimumSize: const Size(0, 44),
                    ),
                    child: Text('Cancel',
                      style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.control)),
                    ),
                    child: _saving
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      // Capture the repaint boundary as an image
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) { Navigator.pop(context); return; }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) { Navigator.pop(context); return; }

      final bytes = byteData.buffer.asUint8List();

      // Write to a temp file
      final tmpDir = Directory.systemTemp;
      final tmpFile = File(
          '${tmpDir.path}/avatar_crop_${DateTime.now().millisecondsSinceEpoch}.png');
      await tmpFile.writeAsBytes(bytes);

      if (mounted) Navigator.pop(context, tmpFile);
    } catch (_) {
      if (mounted) Navigator.pop(context);
    }
  }
}
