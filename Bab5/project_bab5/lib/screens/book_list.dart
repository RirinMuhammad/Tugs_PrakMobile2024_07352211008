import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_services.dart';
import 'add_book.dart';
import 'book_detail.dart';

class BooksListScreen extends StatefulWidget {
  const BooksListScreen({super.key});

  @override
  _BooksListScreenState createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  late Future<List<Book>> _booksFuture;

  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    _booksFuture = fetchBooks();
    _booksFuture.then((books) {
      setState(() {
        _books = books;
      });
    });
  }

  void _addNewBook(Book newBook) {
    setState(() {
      _books.add(newBook); // Menambahkan buku baru ke daftar
    });
  }

  void _removeBookById(int id) {
    setState(() {
      _books.removeWhere((book) => book.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newBook = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookScreen()),
              );
              if (newBook != null && newBook is Book) {
                _addNewBook(newBook); // Menambahkan buku baru secara langsung
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBooks,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || _books.isEmpty) {
            return const Center(child: Text("Tidak ada buku tersedia"));
          } else {
            return ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () async {
                    final deletedBookId = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: book),
                      ),
                    );
                    if (deletedBookId != null) {
                      _removeBookById(deletedBookId);
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
