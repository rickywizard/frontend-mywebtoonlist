import 'package:flutter/material.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:frontend/services/comment_service.dart';
import 'package:frontend/models/comment.dart';

class DetailsTab extends StatefulWidget {
  final Map<String, dynamic> comicDetails;
  final Utilities utils;

  const DetailsTab({
    super.key,
    required this.comicDetails,
    required this.utils,
  });

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  Future<List<Comment>>? _userComments;

  @override
  void initState() {
    super.initState();
    _loadUserComments();
  }

  Future<void> _loadUserComments() async {
    final userId = await _commentService.getUserId();
    final comicId = widget.comicDetails['id'];
    setState(() {
      _userComments = _commentService.fetchUserComments(comicId, userId);
    });
  }

  Future<void> _handleAddComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty.')),
      );
      return;
    }

    try {
      final userId = await _commentService.getUserId();
      final comicId = widget.comicDetails['id'];

      await _commentService.addComment(
        content: content,
        userId: userId,
        comicId: comicId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added successfully.')),
        );
        _commentController.clear();
        _loadUserComments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    }
  }

  Future<void> _handleDeleteComment(int commentId) async {
    try {
      await _commentService.deleteComment(commentId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted successfully.')),
        );
        _loadUserComments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete comment: $e')),
        );
      }
    }
  }

  Future<void> _handleUpdateComment(int commentId, String newContent) async {
    if (newContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty.')),
      );
      return;
    }

    try {
      await _commentService.updateComment(
          commentId: commentId, content: newContent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment updated successfully.')),
        );
        _loadUserComments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update comment: $e')),
        );
      }
    }
  }

  void _showUpdateDialog(int commentId, String currentContent) {
    final TextEditingController updateController =
        TextEditingController(text: currentContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Update Comment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: TextField(
            controller: updateController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Update your comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF00D563)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF00D563),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleUpdateComment(commentId, updateController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Color(0xFF00D563)),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Color(0xFF00D563),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for Image and Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Comic Image
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  widget.utils.imageUrl(widget.comicDetails['image']),
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.comicDetails['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Genre
                    Text(
                      'Genre: ${widget.comicDetails['genre']}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Views
                    Text(
                      'Views: ${widget.utils.formatViews(widget.comicDetails['views'])}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Synopsis
          const Text(
            'Synopsis:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.comicDetails['synopsis'] ?? 'No synopsis available.',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // Comment Input Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF00D563)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _handleAddComment,
                color: Colors.green,
                iconSize: 24.0,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Comments Section
          FutureBuilder<List<Comment>>(
            future: _userComments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final comments = snapshot.data!;
                return ListView.separated(
                  shrinkWrap:
                      true, // Make ListView fit inside SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling for the list
                  itemCount: comments.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.getFormattedCreatedAt(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showUpdateDialog(comment.id, comment.content);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _handleDeleteComment(comment.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('You have not commented yet.'));
              }
            },
          ),
        ],
      ),
    );
  }
}
