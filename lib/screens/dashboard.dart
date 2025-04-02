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
  ];
  final List<String> _bannerImages = [
    'https://img.freepik.com/premium-vector/playful-cartoon-book-illustration-with-vector-characters_1323048-20751.jpg',
    'https://i.pinimg.com/1200x/02/d8/e6/02d8e6935eb0bb0f1ca50935d891a101.jpg',
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

  @override
  Widget build(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DASHBOARD",
        style: TextStyle(
          fontSize: 20,
        ),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari buku...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(left: 10, bottom: 5, right: 5),
                  icon: const Icon(Icons.settings, size: 34,),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18, right: 12, left: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: const Text('Anak-Anak'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: const Text('Fiksi'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: const Text('Non-Fiksi'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: const Text('Misteri'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: const Text('Fantasi'),
                    ),
                    //
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  CarouselSlider(
                    items: widget._bannerImages.map((url) {
                      return Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 180.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Indicator Carousel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget._bannerImages.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                          items: <String>['Terbaru', 'Terlaris', 'Harga Terendah', 'Harga Tertinggi']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedOption = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: BookList(
                          books: widget._books,
                          searchText: _searchText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}