import 'package:flutter/material.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';
import '../UI/book_list.dart';
import 'categorypage.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> allBooks = bookList;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              surfaceTintColor: Colors.black,
              title: const Text(
                "Semua Produk",
                style: TextStyle(fontSize: 20),
              ),
              pinned: true,
              floating: true,
              snap: false,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 0, bottom: 0.0, top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari buku...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
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
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BookList(
            books: allBooks,
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