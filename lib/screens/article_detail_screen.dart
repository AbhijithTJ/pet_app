import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/api/backend/firebase_service.dart';
import 'package:pet_app/api/backend/preference_service.dart';
import 'package:pet_app/screens/auth/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_app/l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _fetchInitialLikes();
    
    // Listen to auth state changes to refresh UI if user logs in via popup
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {}); // Trigger rebuild to update UI based on auth state
      }
    });
  }

  bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

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
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.loginRequired),
        content: Text(l10n.loginRequiredMessage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.login, style: const TextStyle(color: Colors.white)),
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

    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@').first ?? "Pet Lover";

    await _firebaseService.addComment(widget.articleId, text, userName);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F5),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            child: Stack(
              children: [
                // Background Orange Curve that scrolls with content
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9E7B), // Soft orange from design
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Custom App Bar (Back)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFF7A51), size: 18),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Content below App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            // Article Image
                            if (widget.imageUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  widget.imageUrl,
                                  width: double.infinity,
                                  height: 240,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                ),
                              ),
                            
                            const SizedBox(height: 20),
                            
                            // Title
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // HTML Content
                            Html(
                              data: widget.content,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(16.0),
                                  lineHeight: LineHeight(1.6),
                                  margin: Margins.zero,
                                  color: const Color(0xFF333333),
                                ),
                                "p": Style(
                                  margin: Margins.only(bottom: 12.0),
                                ),
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Interaction Bar (Like, Comment, Share)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(color: Colors.grey.withOpacity(0.1)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Like Section
                                  GestureDetector(
                                    onTap: _toggleLike,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _isLiked ? Icons.favorite : Icons.favorite_border, 
                                          color: _isLiked ? Colors.red : Colors.red, 
                                          size: 28,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("$_likesCount", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                                            const Text("ലൈക്ക്", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.3)),
                                  
                                  // Comment Section
                                  Row(
                                    children: [
                                      const Icon(Icons.chat_bubble, color: Color(0xFFFF7A51), size: 26),
                                      const SizedBox(width: 8),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: _firebaseService.getCommentsForArticle(widget.articleId),
                                        builder: (context, snapshot) {
                                          final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("$count", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                                              const Text("കമന്റ്", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ],
                                          );
                                        }
                                      )
                                    ],
                                  ),
                                  Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.3)),
                                  
                                  // Share Section
                                  Row(
                                    children: [
                                      Icon(Icons.share_outlined, color: Colors.grey[700], size: 24),
                                      const SizedBox(width: 8),
                                      const Text("ഷെയർ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Comments Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: _firebaseService.getCommentsForArticle(widget.articleId),
                                  builder: (context, snapshot) {
                                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                                    return Text("കമന്റുകൾ ($count)", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16));
                                  }
                                ),
                                const Text("എല്ലാം കാണുക", style: TextStyle(color: Color(0xFFFF7A51), fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Comments List
                            StreamBuilder<QuerySnapshot>(
                              stream: _firebaseService.getCommentsForArticle(widget.articleId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(child: Text("കമന്റുകൾ ഒന്നുമില്ല. ആദ്യത്തെ കമന്റ് എഴുതുക!")),
                                  );
                                }
                                
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final doc = snapshot.data!.docs[index];
                                    final data = doc.data() as Map<String, dynamic>;
                                    final String text = data['text'] ?? '';
                                    final String userName = data['userName'] ?? 'User';
                                    
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.02),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(0xFFFFE8DD),
                                            foregroundColor: const Color(0xFFFF7A51),
                                            radius: 20,
                                            child: Text(userName[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      userName,
                                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black87),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  text,
                                                  style: const TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.4),
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
                            const SizedBox(height: 80), // Space for bottom input
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Comment Input Fixed
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16).copyWith(
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFCF9F5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFFE8DD),
                    foregroundColor: Color(0xFFFF7A51),
                    radius: 20,
                    child: Icon(Icons.person, size: 24),
                  ),
                  const SizedBox(width: 12),
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
                        hintText: "നിങ്ങളുടെ അഭിപ്രായം എഴുതുക...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _postComment,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF7A51),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
