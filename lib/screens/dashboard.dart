import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Model/products.dart';
import '../Providers/cart_providers.dart';
import '../UI/book_list.dart';

class Dashboard extends StatefulWidget {
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'Buku 1',
      author: 'Penulis Buku 1',
      price: 25000,
      imageUrl:
          'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/97/MTA-146437441/reneluv_selalu_ada_ruang_untuk_pulang_buku_novel_by-_karima_ifha_-_penerbit_reneluv_full01_vkmkazji.jpg',
    ),
    Book(
      id: '2',
      title: 'Buku 2',
      author: 'Penulis Buku 2',
      price: 30000,
      imageUrl: 'https://cdn.gramedia.com/uploads/items/9786239712716.jpg',
    ),
    Book(
      id: '3',
      title: 'Buku 3',
      author: 'Penulis Buku 3',
      price: 20000,
      imageUrl:
          'https://deepublishstore.com/wp-content/uploads/2018/01/Wujud-Tanpa-Suara-Nurul-depan1.jpg',
    ),
    Book(
        id: '4',
        title: 'Buku 4',
        author: 'Penulis 4',
        price: 40000,
        imageUrl:
            'https://blog.sribu.com/wp-content/uploads/2024/07/214639-20231011-cover_31.jpg-642x1024.webp'),
    Book(
        id: '5',
        title: 'Buku 5',
        author: 'Penulis 5',
        price: 50000,
        imageUrl:
            'https://cdn.venngage.com/template/thumbnail/310/9553a2c4-731a-4065-bec9-8b184df4045d.webp'),
    Book(
        id: '6',
        title: 'Buku 6',
        author: 'Penulis 6',
        price: 60000,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSDQnigiVI5kU-UYO_Ourb8H5uaXUP-FYYZ7SFSqMSPTb3ZcCxg2rBwRqcINTKAp7uVNQ&usqp=CAU'),
    Book(
        id: '7',
        title: 'Buku 7',
        author: 'Penulis 7',
        price: 70000,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTP0gCZeGK8-rF4puqBoIQgnEAVJNT90RuIkA&s'),
    Book(
        id: '8',
        title: 'Buku 8',
        author: 'Penulis 8',
        price: 80000,
        imageUrl:
            'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/contemporary-fiction-night-time-book-cover-design-template-1be47835c3058eb42211574e0c4ed8bf_screen.jpg?ts=1734004864'),
    Book(
        id: '8',
        title: 'Buku 8',
        author: 'Penulis 8',
        price: 80000,
        imageUrl:
            'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/contemporary-fiction-night-time-book-cover-design-template-1be47835c3058eb42211574e0c4ed8bf_screen.jpg?ts=1734004864'),
    Book(
        id: '8',
        title: 'Buku 8',
        author: 'Penulis 8',
        price: 80000,
        imageUrl:
            'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/contemporary-fiction-night-time-book-cover-design-template-1be47835c3058eb42211574e0c4ed8bf_screen.jpg?ts=1734004864'),
    Book(
        id: '8',
        title: 'Buku 8',
        author: 'Penulis 8',
        price: 80000,
        imageUrl:
            'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/contemporary-fiction-night-time-book-cover-design-template-1be47835c3058eb42211574e0c4ed8bf_screen.jpg?ts=1734004864'),
  ];
  final List<String> _bannerImages = [
    'https://img.freepik.com/premium-vector/playful-cartoon-book-illustration-with-vector-characters_1323048-20751.jpg',
    'https://images.twinkl.co.uk/tw1n/image/private/t_630_eco/image_repo/7e/4a/id-ll-1689248734-spanduk-pojok-baca_ver_1.jpg',
    'https://i.pinimg.com/736x/3c/e3/e0/3ce3e0062cf274c140940b7e1deee005.jpg',
  ];

  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _current = 0;
  String _selectedOption = 'Terbaru';
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
                          size: 30,
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
                                    print('Category selected: $category');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Kategori: $category')),
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
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    CarouselSlider(
                      items: widget._bannerImages.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 175.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
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
                      children:
                          widget._bannerImages.asMap().entries.map((entry) {
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
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PRODUK",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _selectedOption,
                            items: <String>[
                              'Terbaru',
                              'Terlaris',
                              'Harga Terendah',
                              'Harga Tertinggi'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedOption = newValue;
                                  print(
                                      'Sort option changed: $_selectedOption');
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: BookList(
            books: widget._books.sublist(0, 3),
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
