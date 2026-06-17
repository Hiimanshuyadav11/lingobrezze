import 'package:flutter/material.dart';
import 'package:lingobrezze/models/word_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VocabularyPage extends StatefulWidget {
  const VocabularyPage ({super.key});

  @override
  State<VocabularyPage>createState() => _VocabularyPageState();}

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
}

      void showAddWordSheet() {
    showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(25),
    ),
  ),
      builder: (context) {
        return Padding(padding: const EdgeInsetsGeometry.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
  'Add New Word',
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

TextField(
  controller: wordController,
  decoration: InputDecoration(
    labelText: "Word",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: meaningController,
  decoration: InputDecoration(
    labelText: 'Meaning',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: translationController,
  decoration: InputDecoration(
    labelText: 'Translation',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
),

const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('words')
          .add({
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
    child: const Text('Save Word'),
  ),
),
          ],
        ),);
      },
    );
  }


  
  @override 
  Widget build(BuildContext context) {
    if (isLoading) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}   

if (errorMessage != null) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),

          const SizedBox(height: 20),

          const Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              setState(() {
                errorMessage = null;
                isLoading = true;
              });

              fetchWords();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    ),
  );
}


    return Scaffold(
      appBar: AppBar(
       elevation: 0,
  backgroundColor: Colors.transparent,

  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(30),
    ),
  ),

  flexibleSpace: ClipRRect(
    borderRadius: const BorderRadius.vertical(
      bottom: Radius.circular(20),
    ),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 74, 77, 162),
            Color.fromARGB(255, 89, 64, 148),
          ],
        ),
      ),
    ),
  ),
  title: const Text(
    'My Vocabulary',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  centerTitle: true,
 
),


        floatingActionButton: FloatingActionButton.extended(
    onPressed: showAddWordSheet,
    icon: const Icon(Icons.add),
    label: const Text("Add Word")
  ),
      body: words.isEmpty 
      ?  Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(24),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
  padding: const EdgeInsets.all(25),
  decoration: BoxDecoration(
    color: Colors.indigo.shade50,
    shape: BoxShape.circle,
  ),
  child: const Icon(
    Icons.menu_book_rounded,
    size: 80,
    color: Color(0xFF6366F1),
  ),
),

              const SizedBox(height: 20,),
              const Text("You haven't saved any words yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 36, 36, 31)
              ),),

              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: showAddWordSheet,
              icon: Icon(Icons.add),
               label: const Text('Add your First Words'))
            ],
          )
          )
      )

      : Padding(
    padding: const EdgeInsets.only(top: 17),
    child: RefreshIndicator(
    onRefresh: fetchWords,
    child
      : ListView.builder(
      itemCount: words.length,
     itemBuilder: (context, index) {
      final word = words[index];

      return Card(
        color: Colors.white,
  margin: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  ),
  elevation: 6,
  shadowColor: Colors.black26,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          word.word,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "Meaning",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(word.meaning),

        const SizedBox(height: 12),

        const Text(
          "Translation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(word.translation),
      ],
    ),
  ),
);
    },
  ),
    ), ), ) ;
  }

  
 

  List<WordModel> words = [];
   bool isLoading = true;
   String? errorMessage;
  final wordController = TextEditingController();
  final meaningController = TextEditingController();
  final translationController = TextEditingController();

 

  


 



  }

  