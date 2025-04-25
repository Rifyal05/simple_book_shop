import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late List<Book> _allPopularBooks;
  List<Book> _filteredBooks = [];
  String _searchText = '';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedFilter = 'Populer';
  RangeValues _currentPriceRange = const RangeValues(0, 500000);
  final double _maxPrice = 500000;

  late String _tempSelectedFilter;
  late RangeValues _tempPriceRange;

  final List<String> _categories = [
    'Anak-Anak', 'Fiksi', 'Non-Fiksi', 'Misteri', 'Fantasi', 'Sains', 'Sejarah',
  ];

  final List<String> _filters = [
    'Populer', 'Harga Tertinggi', 'Harga Terendah', 'A-Z', 'Z-A',
  ];

  final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    final uniqueBooks = <String, Book>{};
    for (var book in bookList) {
      uniqueBooks[book.id] = book;
    }
    _allPopularBooks = uniqueBooks.values.take(20).toList();
    _tempSelectedFilter = _selectedFilter;
    _tempPriceRange = _currentPriceRange;
    _applyFilters();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    List<Book> tempFilteredBooks = List.from(_allPopularBooks);

    tempFilteredBooks = tempFilteredBooks.where((book) =>
    book.price >= _currentPriceRange.start &&
        book.price <= _currentPriceRange.end).toList();

    if (_searchText.isNotEmpty) {
      tempFilteredBooks = tempFilteredBooks.where((book) =>
      book.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchText.toLowerCase())).toList();
    }

    switch (_selectedFilter) {
      case 'Populer': break;
      case 'Harga Tertinggi': tempFilteredBooks.sort((a, b) => b.price.compareTo(a.price)); break;
      case 'Harga Terendah': tempFilteredBooks.sort((a, b) => a.price.compareTo(b.price)); break;
      case 'A-Z': tempFilteredBooks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())); break;
      case 'Z-A': tempFilteredBooks.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase())); break;
    }

    if (mounted) {
      setState(() { _filteredBooks = tempFilteredBooks; });
    }
  }

  void _onApplyFilterPressed() {
    if (mounted) {
      setState(() {
        _selectedFilter = _tempSelectedFilter;
        _currentPriceRange = _tempPriceRange;
        _applyFilters();
      });
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _resetFilters() {
    if (mounted) {
      setState(() {
        _tempSelectedFilter = 'Populer';
        _tempPriceRange = RangeValues(0, _maxPrice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text('Filter & Urutkan', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text('Urutkan Berdasarkan', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setDrawerState) {
                          return Wrap(
                            spacing: 8.0, runSpacing: 4.0,
                            children: _filters.map((filter) {
                              return ChoiceChip(
                                label: Text(filter),
                                selected: _tempSelectedFilter == filter,
                                onSelected: (selected) {
                                  if (selected) {
                                    setDrawerState(() { _tempSelectedFilter = filter; });
                                  }
                                },
                                selectedColor: colorScheme.primaryContainer,
                                labelStyle: TextStyle(color: _tempSelectedFilter == filter ? colorScheme.onPrimaryContainer : null),
                                showCheckmark: false,
                              );
                            }).toList(),
                          );
                        }
                    ),
                    const Divider(height: 32),
                    Text('Rentang Harga', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setDrawerState) {
                          return Column(
                            children: [
                              RangeSlider(
                                values: _tempPriceRange, min: 0, max: _maxPrice, divisions: 10,
                                labels: RangeLabels(_rupiahFormat.format(_tempPriceRange.start), _rupiahFormat.format(_tempPriceRange.end)),
                                onChanged: (RangeValues values) {
                                  setDrawerState(() { _tempPriceRange = values; });
                                },
                                activeColor: colorScheme.primary, inactiveColor: colorScheme.surfaceContainerHighest,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_rupiahFormat.format(_tempPriceRange.start), style: Theme.of(context).textTheme.bodySmall),
                                  Text(_rupiahFormat.format(_tempPriceRange.end), style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ],
                          );
                        }
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: _resetFilters, child: const Text('Reset Filter'))),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton(onPressed: _onApplyFilterPressed, child: const Text('Terapkan'))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text("Produk Populer"),
              pinned: true, floating: true, snap: false,
              forceElevated: innerBoxIsScrolled,
              elevation: 1.0, surfaceTintColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.filter_alt_sharp),
                  tooltip: 'Filter & Urutkan',
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _tempSelectedFilter = _selectedFilter;
                        _tempPriceRange = _currentPriceRange;
                      });
                    }
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari di produk populer...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide.none),
                            filled: true, fillColor: colorScheme.surfaceContainerHighest,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          ),
                          onChanged: (value) {
                            _searchText = value;
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories.map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), textStyle: const TextStyle(fontSize: 14)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(categoryName: category)));
                          },
                          child: Text(category),
                        ),
                      )).toList(),
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
          child: _filteredBooks.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _searchText.isNotEmpty
                    ? 'Tidak ada produk ditemukan untuk pencarian "$_searchText".'
                    : 'Tidak ada produk ditemukan sesuai filter yang dipilih.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center,
              ),
            ),
          )
              : PopularBook4Data(books: _filteredBooks),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child, required this.height});
  final Widget child;
  final double height;

  @override double get minExtent => height;
  @override double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}