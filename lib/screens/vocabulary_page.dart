import 'package:flutter/material.dart';
import 'package:lingobrezze/models/word_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class _AppColors {
  static const background = Color(0xFFF4F7F6);
  static const surface = Color(0xFFFFFFFF);
  static const appBarStart = Color(0xFF2F6B6B);
  static const appBarEnd = Color(0xFF3D6278);
  static const primary = Color(0xFF3A9189);
  static const primaryMuted = Color(0xFF6A9E96);
  static const accentWarm = Color(0xFFC4845C);
  static const meaningLabel = Color(0xFF2E8578);
  static const translationLabel = Color(0xFFB8724F);
  static const border = Color(0xFFD5E5E1);
  static const textPrimary = Color(0xFF1E3330);
  static const textSecondary = Color(0xFF5C726E);
  static const emptyIconBg = Color(0xFFDFF0ED);
  static const error = Color(0xFFC76B6B);
}

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  Future<void> fetchWords() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/words'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          words = data.map((item) {
            return WordModel(
              word: item['word'],
              meaning: item['meaning'],
              translation: item['translation'],
            );
          }).toList();

          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWords();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    wordController.dispose();
    meaningController.dispose();
    translationController.dispose();
    super.dispose();
  }

  List<WordModel> get filteredWords {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return words;

    return words.where((word) {
      return word.word.toLowerCase().contains(query) ||
          word.meaning.toLowerCase().contains(query) ||
          word.translation.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: searchController,
        style: const TextStyle(
          color: _AppColors.textPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'Search words, meanings, translations...',
          hintStyle: TextStyle(
            color: _AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _AppColors.primaryMuted,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: _AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: _AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(WordModel word, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _AppColors.border),
        boxShadow: [
          BoxShadow(
            color: _AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: index.isEven ? _AppColors.primary : _AppColors.accentWarm,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: _AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Meaning',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _AppColors.meaningLabel,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.meaning,
                      style: const TextStyle(
                        fontSize: 15,
                        color: _AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Translation',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _AppColors.translationLabel,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.translation,
                      style: const TextStyle(
                        fontSize: 15,
                        color: _AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.search_off_rounded,
          size: 56,
          color: _AppColors.primaryMuted.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 16),
        const Text(
          'No words found',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'No matches for "${searchController.text.trim()}"',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: _AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _AppColors.textSecondary),
      filled: true,
      fillColor: _AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _AppColors.primary, width: 1.5),
      ),
    );
  }

  void showAddWordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add New Word',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Save a word with its meaning and translation.',
                style: TextStyle(
                  fontSize: 14,
                  color: _AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: wordController,
                decoration: _inputDecoration('Word'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: meaningController,
                decoration: _inputDecoration('Meaning'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: translationController,
                decoration: _inputDecoration('Translation'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('words').add({
                      'word': wordController.text,
                      'meaning': meaningController.text,
                      'translation': translationController.text,
                    });

                    setState(() {
                      words.add(
                        WordModel(
                          word: wordController.text,
                          meaning: meaningController.text,
                          translation: translationController.text,
                        ),
                      );
                    });

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save Word',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: _AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: _AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: _AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDED),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: _AppColors.error,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We couldn\'t load your vocabulary. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: _AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorMessage = null;
                      isLoading = true;
                    });
                    fetchWords();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _AppColors.appBarStart,
                  _AppColors.appBarEnd,
                ],
              ),
            ),
          ),
        ),
        title: const Text(
          'My Vocabulary',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddWordSheet,
        backgroundColor: _AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Word',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: words.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: const BoxDecoration(
                        color: _AppColors.emptyIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 72,
                        color: _AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      "You haven't saved any words yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Start building your personal word collection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: _AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: showAddWordSheet,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Add your first word'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: filteredWords.isEmpty
                      ? RefreshIndicator(
                          color: _AppColors.primary,
                          onRefresh: fetchWords,
                          child: _buildNoResultsState(),
                        )
                      : RefreshIndicator(
                          color: _AppColors.primary,
                          onRefresh: fetchWords,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 88),
                            itemCount: filteredWords.length,
                            itemBuilder: (context, index) {
                              return _buildWordCard(filteredWords[index], index);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  List<WordModel> words = [];
  bool isLoading = true;
  String? errorMessage;
  final searchController = TextEditingController();
  final wordController = TextEditingController();
  final meaningController = TextEditingController();
  final translationController = TextEditingController();
}
