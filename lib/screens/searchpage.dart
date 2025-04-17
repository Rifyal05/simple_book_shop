import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ecommerce/DataTest/bookdata.dart';
import 'package:simple_ecommerce/Model/products.dart';
import 'package:simple_ecommerce/UI4BUILD/book_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoadingHistory = true;
  String _query = '';

  static const String _historyKey = 'searchHistory';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    setState(() {
      _isLoadingHistory = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    setState(() {
      _searchHistory = history;
      _isLoadingHistory = false;
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, _searchHistory);
  }

  void _addSearchTerm(String term) {
    if (term.trim().isEmpty) return;

    _searchHistory.remove(term);
    _searchHistory.insert(0, term);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    _saveSearchHistory();
    setState(() {});
  }

  void _removeSearchTerm(String term) {
    _searchHistory.remove(term);
    _saveSearchHistory();
    setState(() {});
  }

  void _clearSearchHistory() {
    _searchHistory.clear();
    _saveSearchHistory();
    setState(() {});
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _query = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = bookList
            .where((book) =>
        book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _submitSearch(String term) {
    if (term.trim().isNotEmpty) {
      _addSearchTerm(term.trim());
      _searchController.text = term.trim();
      _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length));
      FocusScope.of(context).unfocus();
    }
  }

  Widget _buildHistoryList() {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchHistory.isEmpty) {
      return const Center(
          child: Text(
            'Belum ada riwayat pencarian.',
            style: TextStyle(color: Colors.grey),
          ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Riwayat Pencarian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (_searchHistory.isNotEmpty)
                TextButton(
                  onPressed: _clearSearchHistory,
                  child: const Text('Hapus Semua', style: TextStyle(color: Colors.redAccent)),
                )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final item = _searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(item),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => _removeSearchTerm(item),
                ),
                onTap: () {
                  _submitSearch(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('Tidak ada hasil ditemukan.'),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: BookList(books: _searchResults, searchText: ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showHistory = _query.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40, // Atur tinggi container box
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[200], // Warna background field
            borderRadius: BorderRadius.circular(20), // Border radius
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textAlignVertical: TextAlignVertical.center, // Pusatkan teks vertikal
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20), // Icon search
              suffixIcon: _query.isNotEmpty
                  ? IconButton( // Tombol clear hanya muncul jika ada teks
                icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
              hintText: 'Cari judul atau penulis...',
              border: InputBorder.none, // Hilangkan border bawaan TextField
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10), // Atur padding internal
            ),
            style: const TextStyle(fontSize: 16), // Ukuran font input
            textInputAction: TextInputAction.search,
            onSubmitted: _submitSearch,
          ),
        ),
        // Kita pindahkan tombol clear ke dalam TextField sebagai suffixIcon
        // jadi actions bisa dihapus atau diisi hal lain jika perlu
        actions: const [],
      ),
      body: showHistory ? _buildHistoryList() : _buildSearchResults(),
    );
  }
}