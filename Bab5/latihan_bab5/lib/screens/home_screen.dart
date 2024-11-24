import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan/screens/detail_screen.dart';
import 'package:latihan/screens/edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List untuk menyimpan berita yang di-bookmark
  List<Map<String, String>> _bookmarkedNews = [];

  // Fungsi untuk menambahkan atau menghapus bookmark
  void toggleBookmark(Map<String, String> news) {
    setState(() {
      if (_bookmarkedNews.contains(news)) {
        _bookmarkedNews.remove(news); // Jika berita sudah di-bookmark, hapus
      } else {
        _bookmarkedNews.add(news); // Jika belum di-bookmark, tambahkan
      }
    });
  }

  Future<List<Map<String, String>>> fetchNews() async {
    final response = await http.get(Uri.parse('https://events.hmti.unkhair.ac.id/api/posts'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);

        return data.map<Map<String, String>>((item) {
          return {
            'imageUrl': 'https://events.hmti.unkhair.ac.id/storage/' + (item['image'] ?? ''),
            'title': item['title']?.toString() ?? 'No Title',
            'author': item['author']?.toString() ?? 'Unknown',
            'description': item['content']?.toString() ?? 'No Description',
            'time': item['updated_at']?.toString() ?? 'Unknown',
          };
        }).toList();
      } catch (e) {
        print("Error parsing data: $e");
        throw Exception('Failed to parse news data');
      }
    } else {
      print("Failed to load news with status: ${response.statusCode}");
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FutureBuilder<List<Map<String, String>>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            List<Map<String, String>> news = snapshot.data!;
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  title: news[index]['title'].toString(),
                                  description: news[index]['description'].toString(),
                                  imageUrl: news[index]['imageUrl'].toString(),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              news[index]['imageUrl']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            news[index]['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${news[index]['author']} • ${news[index]['time']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                _bookmarkedNews.contains(news[index])
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: _bookmarkedNews.contains(news[index])
                                    ? Colors.blue
                                    : null,
                              ),
                              onPressed: () {
                                toggleBookmark(news[index]);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      Center(child: Text('Explore Page')),
      Center(
        child: _bookmarkedNews.isEmpty
            ? Text("Tidak ada berita yang di-bookmark")
            : ListView.builder(
                itemCount: _bookmarkedNews.length,
                itemBuilder: (context, index) {
                  final news = _bookmarkedNews[index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(news['title']!),
                    subtitle: Text('${news['author']} • ${news['time']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        toggleBookmark(news); // Hapus berita dari bookmark
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: news['title'].toString(),
                            description: news['description'].toString(),
                            imageUrl: news['imageUrl'].toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      EditProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'HMTI',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ' News',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Pengaturan', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Color(0xFF1877F2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF1877F2),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
