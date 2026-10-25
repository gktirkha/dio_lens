import 'package:flutter/material.dart';

import '../../di/dio_lens_dependencies.dart';
import '../../features/request_detail/presentation/pages/request_detail_page.dart';
import '../../features/request_home/presentation/controllers/request_home_controller.dart';
import '../../features/request_home/presentation/pages/request_home_page.dart';
import 'dio_lens_navigator.dart';

/// The screen `DioLens.open` shows: the request list, where a tap opens
/// that request's detail.
class DioLensInspector extends StatefulWidget {
  const DioLensInspector({super.key, required this.dependencies});

  final DioLensDependencies dependencies;

  @override
  State<DioLensInspector> createState() => _DioLensInspectorState();
}

class _DioLensInspectorState extends State<DioLensInspector> {
  late final RequestHomeController _controller = widget.dependencies
      .createRequestHomeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RequestHomePage(
      controller: _controller,
      onRequestTap: (item) => pushDioLensPage<void>(
        context,
        builder: (_) => RequestDetailPage(
          createController: () =>
              widget.dependencies.createRequestDetailController(item.id),
        ),
      ),
      onMinimize: () => Navigator.of(context).maybePop(),
    );
  }
}
