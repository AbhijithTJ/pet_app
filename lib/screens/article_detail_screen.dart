import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/api/backend/firebase_service.dart';
import 'package:pet_app/api/backend/preference_service.dart';
import 'package:pet_app/screens/auth/login_screen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String articleId;
  final String title;
  final String content;
  final String imageUrl;

  const ArticleDetailScreen({
    super.key,
    required this.articleId,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final PreferenceService _preferenceService = PreferenceService();
  final TextEditingController _commentController = TextEditingController();
  
  bool _isLiked = false;
  int _likesCount = 0;
  bool _isLoggedIn = false; // Dummy state for now

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _fetchInitialLikes();
  }

  Future<void> _checkIfLiked() async {
    final liked = await _preferenceService.isArticleLiked(widget.articleId);
    if (mounted) {
      setState(() {
        _isLiked = liked;
      });
    }
  }

  Future<void> _fetchInitialLikes() async {
    final doc = await FirebaseFirestore.instance.collection('articles').doc(widget.articleId).get();
    if (mounted && doc.exists && doc.data()!.containsKey('likes')) {
      setState(() {
        _likesCount = doc.data()!['likes'] as int;
      });
    }
  }

  void _showLoginPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("You need to login to post a comment or like this article."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ).then((_) {
                // For demonstration, we simulate user logging in after returning
                if (mounted) {
                  setState(() {
                    _isLoggedIn = true;
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleLike() async {
    if (!_isLoggedIn) {
      _showLoginPopup();
      return;
    }
    final wasLiked = _isLiked;
    setState(() {
      _isLiked = !wasLiked;
      _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
      if (_likesCount < 0) _likesCount = 0;
    });

    if (_isLiked) {
      await _preferenceService.saveLikedArticle(widget.articleId);
    } else {
      await _preferenceService.removeLikedArticle(widget.articleId);
    }

    await _firebaseService.toggleLike(widget.articleId, wasLiked);
  }

  Future<void> _postComment() async {
    if (!_isLoggedIn) {
      _showLoginPopup();
      return;
    }
    
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _commentController.clear();
    FocusScope.of(context).unfocus();

    await _firebaseService.addComment(widget.articleId, text, "Pet Lover"); // Default name
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                    )
                  : Container(color: Colors.grey),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Html(
                      data: widget.content,
                      style: {
                        "body": Style(
                          fontSize: FontSize(16.0),
                          lineHeight: LineHeight(1.6),
                          margin: Margins.zero,
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Interaction Bar (Likes)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _toggleLike,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isLiked ? Colors.red.withOpacity(0.1) : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.grey[600],
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$_likesCount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Icon(Icons.chat_bubble_outline, color: Colors.grey[600], size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          "Comments",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Comments Section Header
                  Text(
                    "Discussion",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Add Comment Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            readOnly: !_isLoggedIn,
                            onTap: () {
                              if (!_isLoggedIn) {
                                _showLoginPopup();
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primaryOrange,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 18),
                              onPressed: _postComment,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Comments List
                  StreamBuilder<QuerySnapshot>(
                    stream: _firebaseService.getCommentsForArticle(widget.articleId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Icon(Icons.chat, size: 50, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text("No comments yet.", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      }
                      
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final String text = data['text'] ?? '';
                          final String userName = data['userName'] ?? 'User';
                          
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                                  foregroundColor: AppColors.primaryOrange,
                                  child: Text(userName[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        text,
                                        style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
