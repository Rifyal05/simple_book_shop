import 'package:flutter/material.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';
import '../UI4DATA/popularproduct4data.dart';
import 'categorypage.dart';

class PopularBooksPage extends StatefulWidget {
  const PopularBooksPage({super.key});

  @override
  State<PopularBooksPage> createState() => _PopularBooksPageState();
}

class _PopularBooksPageState extends State<PopularBooksPage> {
  late List<Book> _popularBooks;
  String _searchText = '';
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
  void initState() {
    super.initState();
    final uniqueBooks = <String, Book>{};
    for (var book in bookList) {
      uniqueBooks[book.id] = book;
    }
    _popularBooks = uniqueBooks.values.take(8).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text("Produk Populer"),
              pinned: true,
              floating: true,
              snap: false,
              forceElevated: innerBoxIsScrolled,
              elevation: 1.0,
              surfaceTintColor: Colors.black,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari di produk populer...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
              ),
              // Tombol aksi di AppBar
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter & Urutkan',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Fitur Filter/Urutkan belum diimplementasikan')),
                    );
                  },
                ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories
                          .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          ];
        },
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PopularBook4Data(
            books: _popularBooks,
            searchText: _searchText,
          ),
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