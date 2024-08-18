import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/services/comic_service.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:frontend/pages/detail_page.dart'; // Import your DetailPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> topComics = []; // Store the full JSON data
  List<String> banners = [];
  List<Map<String, dynamic>> recentComics = [];
  int _currentIndex = 0;
  final ComicService _comicService = ComicService();
  final Utilities _utils = Utilities();

  @override
  void initState() {
    super.initState();
    fetchTopComics();
    fetchRecentComics();
  }

  Future<void> fetchTopComics() async {
    try {
      final data = await _comicService.fetchTopComics();
      setState(() {
        topComics = data;
        banners = List<String>.from(
            topComics.map((item) => _utils.imageUrl(item['banner'])));
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> fetchRecentComics() async {
    try {
      final data = await _comicService.fetchRecentComics();
      setState(() {
        recentComics = data;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _navigateToDetailPage(int comicId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(comicId: comicId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (banners.isNotEmpty)
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300.0,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: banners.asMap().entries.map((entry) {
                      int index = entry.key;
                      String banner = entry.value;

                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              final comicId = topComics[index]['id'];
                              _navigateToDetailPage(comicId);
                            },
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Image.network(
                                  banner,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                                Container(
                                  color: Colors.black26,
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    topComics[index]['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: banners.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          _currentIndex = entry.key;
                        }),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == entry.key
                                ? const Color(0xFF00D563)
                                : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            else
              const Center(child: CircularProgressIndicator()),

            // Infographic Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to My Webtoon List!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore the best webtoons list from top creators. Enjoy a variety of genres and find your new favorite series!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Why choose us?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '- Detailed informations',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '- Public comments',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '- Wide selection of webtoons',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            if (recentComics.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recently Added',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...recentComics.map((comic) {
                      final imageUrl = _utils.imageUrl(comic['image']);
                      return GestureDetector(
                        onTap: () {
                          final comicId = comic['id'];
                          _navigateToDetailPage(comicId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  imageUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  comic['title'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
