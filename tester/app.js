const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');
const path = require('path');

const BASE_URL = 'https://www.amazon.com';

async function scrapeMovies() {
  try {
    const { data } = await axios.get(BASE_URL);
    const $ = cheerio.load(data);

    const movies = [];

    $('.flw-item').slice(0, 10).each((i, el) => {
      const title = $(el).find('.film-name a').attr('title');
      const image = $(el).find('.film-poster-img').attr('data-src');
      if (title && image) {
        movies.push({ title, image });
      }
    });

    console.log("🎬 Films trouvés :");
    console.table(movies);

    // Créer un dossier pour les images
    const imagesDir = path.join(__dirname, 'images');
    if (!fs.existsSync(imagesDir)) {
      fs.mkdirSync(imagesDir);
    }

    // Télécharger les images
    for (const movie of movies) {
      const imagePath = path.join(imagesDir, sanitizeFileName(movie.title) + '.jpg');
      const writer = fs.createWriteStream(imagePath);
      const response = await axios.get(movie.image, { responseType: 'stream' });
      response.data.pipe(writer);

      // Attendre que l’image soit bien enregistrée
      await new Promise((resolve, reject) => {
        writer.on('finish', resolve);
        writer.on('error', reject);
      });

      console.log(`✅ Image téléchargée : ${movie.title}`);
    }

  } catch (error) {
    console.error('❌ Erreur :', error.message);
  }
}

// Nettoyer les noms de fichiers
function sanitizeFileName(name) {
  return name.replace(/[^a-z0-9]/gi, '_').toLowerCase();
}

scrapeMovies();
