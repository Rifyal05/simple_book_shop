import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';
import '../UI4DATA/category4data.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Book> _books = [];
  String _selectedFilter = 'Terbaru';
  RangeValues _currentPriceRange = const RangeValues(0, 500000);
  final double _maxPrice = 500000;

  late String _tempSelectedFilter;
  late RangeValues _tempPriceRange;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchText = '';

  final List<String> _categories = [
    'Anak-Anak',
    'Fiksi',
    'Non-Fiksi',
    'Misteri',
    'Fantasi',
    'Sains',
    'Sejarah',
  ];

  final List<String> _filters = [
    'Terbaru',
    'Populer',
    'Harga Tertinggi',
    'Harga Terendah',
    'Rating Tertinggi',
    'A-Z',
    'Z-A',
  ];

  final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _books = _getBooksForCategory(widget.categoryName);
    _tempSelectedFilter = _selectedFilter;
    _tempPriceRange = _currentPriceRange;
  }

  List<Book> _getBooksForCategory(String category) {
    List<Book> allBooks = bookList;
    final uniqueBooks = <String, Book>{};
    for (var book in allBooks) {
      uniqueBooks[book.id] = book;
    }
    allBooks = uniqueBooks.values.toList();

    final int bookCount = allBooks.length;
    if (bookCount == 0) return [];

    if (category == 'Fiksi') {
      return allBooks.take( (bookCount * 0.3).ceil() ).toList();
    } else if (category == 'Sains') {
      return allBooks.skip( (bookCount * 0.3).ceil() ).take( (bookCount * 0.3).ceil() ).toList();
    } else if (category == 'Anak-Anak') {
      return allBooks.skip( (bookCount * 0.6).ceil() ).take( (bookCount * 0.2).ceil() ).toList();
    } else {
      return allBooks.skip( (bookCount * 0.8).ceil() ).toList();
    }
  }

  List<Book> _applyFilter(List<Book> books) {
    List<Book> filteredBooks = List.from(books);

    filteredBooks = filteredBooks
        .where((book) =>
    book.price >= _currentPriceRange.start &&
        book.price <= _currentPriceRange.end)
        .toList();

    if (_searchText.isNotEmpty) {
      filteredBooks = filteredBooks
          .where((book) =>
      book.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    switch (_selectedFilter) {
      case 'Terbaru':
        break;
      case 'Populer':
        break;
      case 'Harga Tertinggi':
        filteredBooks.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Harga Terendah':
        filteredBooks.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Rating Tertinggi':
        break;
      case 'A-Z':
        filteredBooks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'Z-A':
        filteredBooks.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }

    return filteredBooks;
  }

  void _onApplyFilterPressed() {
    setState(() {
      _selectedFilter = _tempSelectedFilter;
      _currentPriceRange = _tempPriceRange;
    });
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _tempSelectedFilter = 'Terbaru';
      _tempPriceRange = RangeValues(0, _maxPrice);
    });
  }

  void _navigateToCategory(String categoryName) {
    Navigator.pop(context);
    if (widget.categoryName == categoryName) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(categoryName: categoryName),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<Book> filteredBooks = _applyFilter(_books);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.categoryName),
        elevation: 1.0,
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
            : null,
        actions: [
          Builder(
            builder: (BuildContext iconButtonContext) {
              return IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Filter & Kategori',
                onPressed: () {
                  setState(() {
                    _tempSelectedFilter = _selectedFilter;
                    _tempPriceRange = _currentPriceRange;
                  });
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari di ${widget.categoryName}...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredBooks.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Tidak ada produk ditemukan untuk filter atau pencarian ini di kategori "${widget.categoryName}". Coba sesuaikan filter atau kata kunci.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Category4Data(books: filteredBooks),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text(
                      'Filter & Kategori',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    Text('Urutkan Berdasarkan', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _filters.map((filter) {
                        return ChoiceChip(
                          label: Text(filter),
                          selected: _tempSelectedFilter == filter,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _tempSelectedFilter = filter;
                              });
                            }
                          },
                          selectedColor: colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                              color: _tempSelectedFilter == filter ? colorScheme.onPrimaryContainer : null
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const Divider(height: 32),

                    Text('Rentang Harga', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _tempPriceRange,
                      min: 0,
                      max: _maxPrice,
                      divisions: 10,
                      labels: RangeLabels(
                        _rupiahFormat.format(_tempPriceRange.start),
                        _rupiahFormat.format(_tempPriceRange.end),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _tempPriceRange = values;
                        });
                      },
                      activeColor: colorScheme.primary,
                      inactiveColor: colorScheme.surfaceContainerHighest,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_rupiahFormat.format(_tempPriceRange.start), style: Theme.of(context).textTheme.bodySmall),
                        Text(_rupiahFormat.format(_tempPriceRange.end), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const Divider(height: 32),

                    Text('Pindah Kategori', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _categories.map((category) {
                        return ActionChip(
                            avatar: Icon(
                              Icons.label_outline,
                              size: 16,
                              color: widget.categoryName == category ? colorScheme.primary : null,
                            ),
                            label: Text(category),
                            onPressed: () {
                              _navigateToCategory(category);
                            },
                            backgroundColor: widget.categoryName == category ? colorScheme.surfaceContainerHighest : null,
                            side: BorderSide(
                                color: widget.categoryName == category ? colorScheme.outlineVariant : Colors.transparent
                            )
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetFilters,
                        child: const Text('Reset Filter'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onApplyFilterPressed,
                        child: const Text('Terapkan'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}