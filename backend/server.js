const express = require('express');
const cors = require('cors');
const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

const serviceAccount = require('./serviceAccountKey.json');

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();
const app = express();

app.use(cors());
app.use(express.json());

app.get('/words', async (req, res) => {
  try {
    const snapshot = await db.collection('words').get();

    const words = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(words);
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});