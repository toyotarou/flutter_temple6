import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // ← RenderAbstractViewport 用
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/_get_data/temple/temple.dart';
import '../extensions/extensions.dart';
import '../models/temple_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // 年ジャンプ用アンカー（年→見出し直前の 0px Anchor の GlobalKey）
  final Map<int, GlobalKey> _yearAnchorKeys = <int, GlobalKey<State<StatefulWidget>>>{};

  // スクロール制御
  final ScrollController _scrollController = ScrollController();

  // 固定ヘッダー（年ボタンバー）の実測用キー
  final GlobalKey _headerKey = GlobalKey();

  // SliverPersistentHeader の高さ（表示と一致させる）
  static const double _yearBarHeight = 56.0;

  @override
  void initState() {
    super.initState();
    // 起動時にAPI取得（POST は provider 内で実行）
    // ignore: always_specify_types
    Future.microtask(() => ref.read(templeProvider.notifier).getAllTemple());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TempleState templeState = ref.watch(templeProvider);

    if (templeState.templeList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 年ごとにグループ（昇順）
    final Map<int, List<TempleModel>> byYear = <int, List<TempleModel>>{};
    for (final TempleModel e in templeState.templeList) {
      byYear.putIfAbsent(e.date.year, () => <TempleModel>[]).add(e);
    }
    final List<int> years = byYear.keys.toList()..sort();

    // アンカーキーを準備
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
          // 上部固定の年ジャンプバー
          SliverPersistentHeader(
            pinned: true,
            delegate: _YearBarDelegate(
              minExtentHeight: _yearBarHeight,
              maxExtentHeight: _yearBarHeight,
              child: Container(
                key: _headerKey,
                // 実測用
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

          // 年ごとの見出し＋リスト
          for (final int y in years) ...<Widget>[
            // 見出しの「手前」に 0px アンカーを置く（パディング外なのでズレない）
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ★ ここがジャンプターゲット（高さ0）
                  SizedBox(key: _yearAnchorKeys[y], height: 0),

                  // 見出し UI（パディングは自由に変更OK）
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('$y 年', style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
            ),

            // リスト本体
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          child: _InfoBlockFromModel(item: item),
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

  /// 年ジャンプ（0pxアンカーへ → ヘッダー高さだけ差し引き → 微調整）
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

    // アンカー（0px）の先頭をビューポート先頭に出すためのスクロール量
    final double baseOffset = viewport.getOffsetToReveal(renderObj, 0.0).offset;

    // 固定ヘッダーの実測高さ（なければ定数）
    final double headerHeight = _headerKey.currentContext?.size?.height ?? _yearBarHeight;

    // ヘッダー分だけ引く（パディング補正は不要：アンカーは0pxで見出しの外）
    double target = baseOffset - headerHeight;

    // 範囲内に丸め
    target = target.clamp(_scrollController.position.minScrollExtent, _scrollController.position.maxScrollExtent);

    // スクロール
    await _scrollController.animateTo(target, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);

    // --- 微調整（±数pxの誤差が気になるときだけ） ---
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

class _InfoBlockFromModel extends StatelessWidget {
  const _InfoBlockFromModel({required this.item});

  final TempleModel item;

  @override
  Widget build(BuildContext context) {
    TextStyle gray([double? size]) => TextStyle(color: Colors.grey.shade700, fontSize: size);

    final String dateStr = item.date.yyyymmdd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(dateStr, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text(item.temple, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(item.address, style: gray()),
        if (item.station.isNotEmpty) ...<Widget>[
          const SizedBox(height: 2),
          Text('最寄り: ${item.station}', style: gray(12)),
        ],
        if (item.gohonzon.isNotEmpty) ...<Widget>[
          const SizedBox(height: 4),
          Text('御祭神: ${item.gohonzon}', style: gray()),
        ],
        if (item.memo.isNotEmpty) ...<Widget>[
          const SizedBox(height: 6),
          Text(item.memo, maxLines: 3, overflow: TextOverflow.ellipsis, style: gray()),
        ],
      ],
    );
  }
}

// 年ジャンプ・ヘッダのデリゲート
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
