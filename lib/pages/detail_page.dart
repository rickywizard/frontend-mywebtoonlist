import 'package:flutter/material.dart';
import 'package:frontend/components/comments_tab.dart';
import 'package:frontend/components/details_tab.dart';
import 'package:frontend/services/comic_service.dart';
import 'package:frontend/utils/utilities.dart';

class DetailPage extends StatefulWidget {
  final int comicId;

  const DetailPage({super.key, required this.comicId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> _comicDetails;
  final ComicService _comicService = ComicService();
  final Utilities _utils = Utilities();

  @override
  void initState() {
    super.initState();
    _comicDetails = _comicService.fetchComicDetails(widget.comicId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _comicDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final comicDetails = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: Column(
                children: [
                  Stack(
                    children: [
                      // Banner Image
                      Image.network(
                        _utils.imageUrl(comicDetails['banner']),
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.black
                            .withOpacity(0.3), // Adjust opacity here
                      ),
                      // Back button overlay
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 8,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      // Genre, Title, and Views overlay
                      Positioned(
                        top: 100,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comicDetails['genre'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 150, // Adjust the maximum width here
                              ),
                              child: Text(
                                comicDetails['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_utils.formatViews(comicDetails['views'])} views',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // TabBar
                  const TabBar(
                    indicatorColor: Color(0xFF00D563), // Green indicator color
                    labelColor:
                        Color(0xFF00D563), // Green text color for selected tab
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.info)),
                      Tab(icon: Icon(Icons.comment)),
                    ],
                  ),
                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      children: [
                        DetailsTab(
                          comicDetails: comicDetails,
                          utils: _utils,
                        ),
                        CommentsTab(comicId: comicDetails['id']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No data found')),
          );
        }
      },
    );
  }
}
