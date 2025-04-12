import 'package:flutter/material.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';
import '../UI/book_list.dart';
import '../colorcode/appcolor.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _allCategories = [
    'Anak-Anak', 'Fiksi', 'Non-Fiksi', 'Misteri',
    'Fantasi', 'Sains', 'Sejarah', 'Biografi', 'Komik'
  ];

  bool _filterDiskon = false;
  RangeValues _filterHarga = const RangeValues(10000, 100000);
  String _sortBy = 'Terbaru';

  bool _tempFilterDiskon = false;
  RangeValues _tempFilterHarga = const RangeValues(10000, 100000);
  String _tempSortBy = 'Terbaru';

  @override
  void initState() {
    super.initState();
    _resetTempFilters();
  }

  void _resetTempFilters() {
    _tempFilterDiskon = _filterDiskon;
    _tempFilterHarga = _filterHarga;
    _tempSortBy = _sortBy;
  }

  List<Book> _getBooksForCategory(String category) {
    List<Book> allBooks = bookList;
    // print('Filter aktif: Diskon=$_filterDiskon, Harga=${_filterHarga.start}-${_filterHarga.end}, SortBy=$_sortBy');

    if (category == 'Fiksi') return allBooks.take(3).toList();
    if (category == 'Sains') return allBooks.skip(3).take(3).toList();
    if (category == 'Anak-Anak') return allBooks.skip(6).take(2).toList();

    return allBooks.skip(1).take(4).toList();
  }

  void _applyFiltersAndCloseDrawer() {
    setState(() {
      _filterDiskon = _tempFilterDiskon;
      _filterHarga = _tempFilterHarga;
      _sortBy = _tempSortBy;

    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Filter diterapkan: $_sortBy (Logika filter aktual belum diimplementasikan)'), duration: Duration(seconds: 2)),
    );
  }

  void _onDrawerClose() {
    _resetTempFilters();
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildFilterDrawer() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDrawerState) {
          return Drawer(
            backgroundColor: AppColors.drawerBackground,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).padding.top + 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        child: Text(
                          'Filter & Urutkan',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.drawerTextPrimary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: ['Terbaru', 'Termurah', 'Termahal', 'Populer'].map((sortOption) {
                            bool isActive = _tempSortBy == sortOption;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: isActive ? 2 : 0,
                                backgroundColor: isActive ? AppColors.drawerButtonActive : AppColors.drawerButtonInactive,
                                foregroundColor: isActive ? AppColors.drawerButtonTextActive : AppColors.drawerButtonTextInactive,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: const TextStyle(fontSize: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                setDrawerState(() { _tempSortBy = sortOption; });
                              },
                              child: Text(sortOption),
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 20, indent: 16, endIndent: 16),
                      CheckboxListTile(
                        title: Text('Hanya Diskon', style: TextStyle(color: AppColors.drawerTextPrimary, fontSize: 14)),
                        value: _tempFilterDiskon,
                        dense: true,
                        activeColor: AppColors.drawerButtonActive,
                        checkColor: AppColors.drawerButtonTextActive,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setDrawerState(() { _tempFilterDiskon = value ?? false; });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      ListTile(
                        dense: true,
                        title: Text('Rentang Harga', style: TextStyle(color: AppColors.drawerTextPrimary, fontSize: 14)),
                        subtitle: Text('Rp ${_tempFilterHarga.start.round()} - Rp ${_tempFilterHarga.end.round()}', style: TextStyle(color: AppColors.drawerTextSecondary, fontSize: 12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      RangeSlider(
                        values: _tempFilterHarga,
                        min: 0,
                        max: 150000,
                        divisions: 15,
                        activeColor: AppColors.drawerButtonActive,
                        inactiveColor: AppColors.drawerButtonInactive.withAlpha(100),
                        labels: RangeLabels(
                          'Rp ${_tempFilterHarga.start.round()}',
                          'Rp ${_tempFilterHarga.end.round()}',
                        ),
                        onChanged: (RangeValues values) {
                          setDrawerState(() { _tempFilterHarga = values; });
                        },
                      ),
                      const Divider(color: Colors.white24, height: 20, indent: 16, endIndent: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        child: Text(
                          'Kategori Lain',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.drawerTextPrimary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _allCategories.where((cat) => cat != widget.categoryName).map((category) {
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.drawerButtonTextInactive,
                                side: BorderSide(color: AppColors.drawerButtonOutline),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: const TextStyle(fontSize: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategoryPage(categoryName: category)),
                                );
                              },
                              child: Text(category),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.drawerButtonActive,
                      foregroundColor: AppColors.drawerButtonTextActive,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _applyFiltersAndCloseDrawer,
                    child: const Text('Apply Filter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildBodyContent() {
    final List<Book> categoryBooks = _getBooksForCategory(widget.categoryName);
    return categoryBooks.isEmpty
        ? Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Belum ada produk untuk kategori "${widget.categoryName}"',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    )
        : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
        child: BookList(
          books: categoryBooks,
          searchText: '',
        ),
      ),
    );
  }

  Widget _buildDrawerTrigger() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            _resetTempFilters();
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            width: 28,
            height: 70,
            decoration: BoxDecoration(
                color: AppColors.drawerBackground.withAlpha(179),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 4,
                      offset: const Offset(2, 0)
                  )
                ]
            ),
            child: Icon(
              Icons.chevron_right,
              color: AppColors.drawerTextPrimary.withAlpha(204),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 1.0,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      ),
      drawer: _buildFilterDrawer(),
      drawerEnableOpenDragGesture: false,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          _onDrawerClose();
        }
      },
      body: Stack(
        children: [
          _buildBodyContent(),
          _buildDrawerTrigger(),
        ],
      ),
    );
  }
}