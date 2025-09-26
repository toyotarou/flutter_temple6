import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/extensions.dart';
import '../models/temple_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.templeList});

  final List<TempleModel> templeList;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Map<int, GlobalKey> _yearAnchorKeys = <int, GlobalKey<State<StatefulWidget>>>{};

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _headerKey = GlobalKey();

  static const double _yearBarHeight = 56.0;

  ///
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (widget.templeList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Map<int, List<TempleModel>> byYear = <int, List<TempleModel>>{};
    for (final TempleModel e in widget.templeList) {
      byYear.putIfAbsent(e.date.year, () => <TempleModel>[]).add(e);
    }
    final List<int> years = byYear.keys.toList()..sort();

    for (final int y in years) {
      _yearAnchorKeys.putIfAbsent(y, () => GlobalKey());
    }

    final double dpr = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      appBar: AppBar(title: const Text('年ジャンプ付き・神社リスト（Riverpod）')),
      body: CustomScrollView(
        controller: _scrollController,
        cacheExtent: 400,
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: _YearBarDelegate(
              minExtentHeight: _yearBarHeight,
              maxExtentHeight: _yearBarHeight,
              child: Container(
                key: _headerKey,

                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: years.length,
                  itemBuilder: (_, int i) {
                    final int y = years[i];
                    return ChoiceChip(label: Text('$y'), selected: false, onSelected: (_) => _jumpToYear(y));
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            ),
          ),

          for (final int y in years) ...<Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(key: _yearAnchorKeys[y], height: 0),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('$y 年', style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
            ),

            SliverList.builder(
              itemCount: byYear[y]!.length,
              itemBuilder: (BuildContext context, int index) {
                final TempleModel item = byYear[y]![index];
                final double screenW = MediaQuery.of(context).size.width;
                final int targetPxW = max(1, (screenW * dpr).round());

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 3 / 2,
                          child: CachedNetworkImage(
                            imageUrl: item.thumbnail,
                            memCacheWidth: targetPxW,
                            fit: BoxFit.cover,
                            placeholder: (BuildContext c, _) => const ColoredBox(color: Colors.black12),
                            errorWidget: (BuildContext c, _, __) => const Icon(Icons.broken_image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: DisplayTempleName(item: item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  ///
  Future<void> _jumpToYear(int year) async {
    final BuildContext? ctx = _yearAnchorKeys[year]?.currentContext;
    if (ctx == null) {
      return;
    }

    final RenderObject? renderObj = ctx.findRenderObject();
    if (renderObj == null) {
      return;
    }

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObj);

    final double baseOffset = viewport.getOffsetToReveal(renderObj, 0.0).offset;

    final double headerHeight = _headerKey.currentContext?.size?.height ?? _yearBarHeight;

    double target = baseOffset - headerHeight;

    target = target.clamp(_scrollController.position.minScrollExtent, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(target, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);

    // ignore: inference_failure_on_instance_creation, always_specify_types
    await Future.delayed(const Duration(milliseconds: 16));
    // ignore: use_build_context_synchronously
    final RenderBox? box = ctx.findRenderObject() as RenderBox?;
    final RenderBox? vpBox = _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && vpBox != null) {
      final Offset topLeft = box.localToGlobal(Offset.zero);
      final double headerBottomY = vpBox.localToGlobal(Offset.zero).dy + headerHeight;
      final double delta = topLeft.dy - headerBottomY;

      if (delta.abs() > 0.5) {
        final double tweak = (_scrollController.offset + delta).clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        );
        await _scrollController.animateTo(tweak, duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
      }
    }
  }
}

///
class DisplayTempleName extends StatelessWidget {
  const DisplayTempleName({super.key, required this.item});

  final TempleModel item;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4)),
            child: Row(
              children: <Widget>[
                SizedBox(width: 100, child: Text(item.date.yyyymmdd)),

                Expanded(child: Text(item.temple, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),

          SizedBox(height: context.screenSize.height * 0.07),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4)),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.address),
                if (item.station.isNotEmpty) ...<Widget>[const SizedBox(height: 2), Text(item.station)],
                if (item.gohonzon.isNotEmpty) ...<Widget>[const SizedBox(height: 4), Text(item.gohonzon)],
                if (item.memo.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 6),
                  Text('With. ${item.memo}', maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///
class _YearBarDelegate extends SliverPersistentHeaderDelegate {
  _YearBarDelegate({required this.minExtentHeight, required this.maxExtentHeight, required this.child});

  final double minExtentHeight;
  final double maxExtentHeight;
  final Widget child;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant _YearBarDelegate old) =>
      old.child != child || old.minExtentHeight != minExtentHeight || old.maxExtentHeight != maxExtentHeight;
}
