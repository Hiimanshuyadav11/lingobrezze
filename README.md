# LingoBreeze – My Vocabulary Feature

## Overview

LingoBreeze is a language-learning application that allows users to save vocabulary words they want to learn later and view them in a clean and organized list.

This implementation focuses on the **My Vocabulary** feature as described in the assignment requirements.

---

## Features Implemented

### Create Word

Users can add a new vocabulary word with the following fields:

| Field       | Required |
| ----------- | -------- |
| Word        | Yes      |
| Meaning     | Yes      |
| Translation | Yes      |

The add word flow is implemented using a **Modal Bottom Sheet**.

Example:

* Word: Apple
* Meaning: A fruit
* Translation: Manzana

---

### Read Words

Users can view all saved vocabulary words in a modern card-based list.

Implemented states:

* Loading State
* Empty State
* Error State
* Pull-to-Refresh

---

## Tech Stack

### Frontend

* Flutter
* Dart
* Material Design

### Backend

* Node.js
* Express.js

### Database

* Firebase Firestore

---

## Project Structure

```text
lingobrezze/
│
├── lib/
│   ├── models/
│   │   └── word_models.dart
│   │
│   ├── screens/
│   │   └── vocabulary_page.dart
│   │
│   ├── firebase_options.dart
│   └── main.dart
│
├── backend/
│   ├── server.js
│   ├── package.json
│   └── serviceAccountKey.json
│
└── README.md
```

---

## API

### GET /words

Returns all saved vocabulary words from Firebase Firestore.

Example Response:

```json
[
  {
    "word": "Apple",
    "meaning": "A fruit",
    "translation": "Manzana"
  },
  {
    "word": "Beautiful",
    "meaning": "Pleasing to look at",
    "translation": "Hermosa"
  }
]
```

---

## Firebase Integration

Vocabulary entries are stored in a Firestore collection:

```text
words
```

Each document contains:

```json
{
  "word": "Apple",
  "meaning": "A fruit",
  "translation": "Manzana"
}
```

---

## Running the Backend

Navigate to the backend folder:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Start the server:

```bash
node server.js
```

Server runs on:

```text
http://localhost:3000
```

---

## Running the Flutter App

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## Architecture

Current implementation follows a simple separation of concerns:

* UI Layer
* Model Layer
* API Layer
* Firebase Data Layer

Reusable widgets and Flutter best practices were used where possible within the assignment scope.

---

## AI Usage

AI-assisted tools were used during development for guidance, debugging, implementation suggestions, and productivity improvements.

The final application architecture, feature integration, testing, and overall implementation decisions were reviewed and completed manually.

Estimated Contribution
* UI Development & Refinement: 40%
* Backend API Development: 60%
* Firebase Integration Support: 40%
* Architecture, Feature Integration & Testing: Manual

AI tools used:

ChatGPT
GitHub Copilot
Firebase Documentation
Flutter Documentation

---

## Assignment Requirements Checklist

### Feature Requirements

* [x] Create Word
* [x] Read Words
* [x] Empty State
* [x] Loading State
* [x] Error State
* [x] Pull-to-Refresh

### Firebase Requirements

* [x] Store vocabulary entries in Firestore

### Node.js API Requirements

* [x] GET /words implemented

### Flutter Requirements

* [x] Flutter application
* [x] State management
* [x] Reusable UI components
* [x] Clean and organized code structure

---

## Author

Himanshu Yadav
