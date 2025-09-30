import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_photo_model.dart';
import '../parts/temple_dialog.dart';
import 'temple_photo_display_alert.dart';

class TemplePhotoListAlert extends ConsumerStatefulWidget {
  const TemplePhotoListAlert({super.key, required this.temple});

  final String temple;

  @override
  ConsumerState<TemplePhotoListAlert> createState() => _TemplePhotoListAlertState();
}

class _TemplePhotoListAlertState extends ConsumerState<TemplePhotoListAlert>
    with ControllersMixin<TemplePhotoListAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(widget.temple),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Expanded(child: displayTemplePhotoList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTemplePhotoList() {
    final List<Widget> list = <Widget>[];

    appParamState.keepTemplePhotoMap[widget.temple]?.forEach((TemplePhotoModel element) {
      final List<Widget> list2 = <Widget>[];
      for (final String element2 in element.templephotos) {
        list2.add(
          GestureDetector(
            onTap: () => TempleDialog(
              context: context,
              widget: TemplePhotoDisplayAlert(imageUrl: element2),

              paddingTop: context.screenSize.height * 0.1,
              paddingBottom: context.screenSize.height * 0.1,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: 90,
              child: CachedNetworkImage(
                imageUrl: element2,
                placeholder: (BuildContext context, String url) => Image.asset('assets/images/no_image.png'),
                errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      }

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.yellowAccent.withValues(alpha: 0.2)),

                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(3),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text(element.date), const SizedBox.shrink()],
                ),
              ),

              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(children: list2),
              ),
            ],
          ),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => list[index],
              childCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
}
