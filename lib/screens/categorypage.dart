import 'package:flutter/material.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';
import '../UI4BUILD/book_list.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Book> _books = [];
  final String _selectedFilter = 'Terbaru';
  final RangeValues _currentPriceRange = const RangeValues(0, 200000);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _books = _getBooksForCategory(widget.categoryName);
  }

  List<Book> _getBooksForCategory(String category) {
    List<Book> allBooks = bookList;
    if (category == 'Fiksi') {
      return allBooks.take(3).toList();
    } else if (category == 'Sains') {
      return allBooks.skip(3).take(3).toList();
    } else if (category == 'Anak-Anak') {
      return allBooks.skip(6).take(2).toList();
    } else {
      return allBooks.skip(1).take(4).toList();
    }
  }

  List<Book> _applyFilter(List<Book> books, String filter) {
    List<Book> filteredBooks = List.from(books);

    filteredBooks = filteredBooks.where((book) =>
    book.price >= _currentPriceRange.start &&
        book.price <= _currentPriceRange.end)
        .toList();

    if (_searchText.isNotEmpty) {
      filteredBooks = filteredBooks.where((book) =>
      book.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }

    switch (filter) {
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
        filteredBooks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        filteredBooks.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return filteredBooks;
  }

  void _onApplyFilterPressed() {
    setState(() {});
    _scaffoldKey.currentState?.closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Anak-Anak',
      'Fiksi',
      'Non-Fiksi',
      'Misteri',
      'Fantasi',
      'Sains',
      'Sejarah',
    ];

    final List<String> filters = [
      'Terbaru',
      'Populer',
      'Harga Tertinggi',
      'Harga Terendah',
      'Rating Tertinggi',
      'A-Z',
      'Z-A',
    ];

    final List<Book> filteredBooks = _applyFilter(_books, _selectedFilter);

    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.categoryName),
          elevation: 1.0,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
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
                  onPressed: () {
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
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari buku / author di ${widget.categoryName}...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
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
                child: Text(
                  'Belum ada produk untuk kategori "${widget.categoryName}"',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              )
                  : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookList(
                    books: filteredBooks,
                    searchText: _searchText,
                  ),
                ),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 100.0, right: 20.0, bottom: 70.0),
                child: Text(
                  'Filter dan Kategori',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleButton({
    required VoidCallback onPressed,
    required String label,
    required BuildContext context,
    bool isSelected = false,
  }) {
    return Material(
      color: isSelected
          ? const Color(0xFF64FFDA)
          : const Color(0xFF424242),
      borderRadius: BorderRadius.circular(24.0),
      elevation: isSelected ? 8.0 : 4.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF212121)
                  : const Color(0xFFE0F7FA),
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}