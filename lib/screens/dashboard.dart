import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_ecommerce/screens/searchpage.dart';
import '../DataTest/articledata.dart';
import '../Providers/cart_providers.dart';
import '../UI4BUILD/articlelist.dart';
import '../UI4BUILD/book_list.dart';
import '../UI4BUILD/popularlistbook.dart';
import '../DataTest/bannerimagedata.dart';
import '../DataTest/bookdata.dart';
import './categorypage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _current = 0;
  final String _searchText = '';
  final ScrollController _scrollController = ScrollController();

  final List<String> _categories = [
    'Anak-Anak',
    'Fiksi',
    'Non-Fiksi',
    'Misteri',
    'Fantasi',
    'Sains',
    'Sejarah',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              surfaceTintColor: Colors.black,
              title: const Text(
                "DASHBOARD",
                style: TextStyle(fontSize: 20),
              ),
              pinned: true,
              floating: true,
              snap: false,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight * 1.3),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey[500],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Cari buku...',
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 0, right: 10),
                            icon: const Icon(
                              Icons.settings_outlined,
                              size: 28,
                            ),
                            tooltip: 'Pengaturan',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Tombol Pengaturan Ditekan')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories
                          .map((category) => Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              textStyle: const TextStyle(fontSize: 14)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                  categoryName: category,
                                ),
                              ),
                            );
                          },
                          child: Text(category),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
                height: 56.0,
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    CarouselSlider(
                      items: bannerImages.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: AspectRatio(
                            aspectRatio: 5 / 2,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 170.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.85,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bannerImages.asMap().entries.map((entry) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _current == entry.key ? 12.0 : 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: (_current == entry.key
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey)
                                .withOpacity(_current == entry.key ? 0.9 : 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30.0),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PRODUK POPULER",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PopularBookList(
                      books: bookList.sublist(0, 5),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PRODUK",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            BookList(
              books: bookList.sublist(0, 3),
              searchText: _searchText,
            ),
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Berita/Artikel Blog",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ArticleList(articles: articleList),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menuju halaman artikel lengkap')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lihat Berita Lainnya',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}