const puppeteer = require('puppeteer');
const fs = require('fs');

const FACEBOOK_EMAIL = 'mouhammadr529@gmail.com';
const FACEBOOK_PASSWORD = '665199959';
const POST_URL = 'https://www.facebook.com/zuck/posts/10102577175875681';
const MAX_COMMENTS = 200;

async function scrapeFacebookPostComments() {
  // Vérification de la version de Puppeteer
  console.log('ℹ️ Version de Puppeteer:', puppeteer.version);

  const browser = await puppeteer.launch({
    headless: false,
    defaultViewport: null,
    args: ['--start-maximized'],
  });

  const page = await browser.newPage();

  try {
    // Étape 1: Connexion à Facebook
    console.log('🔐 Connexion à Facebook...');
    await page.goto('https://www.facebook.com/login', { 
      waitUntil: 'networkidle2',
      timeout: 60000 
    });
    
    await page.waitForSelector('#email', { timeout: 15000 });
    await page.type('#email', FACEBOOK_EMAIL, { delay: 30 });
    await page.type('#pass', FACEBOOK_PASSWORD, { delay: 30 });
    
    await Promise.all([
      page.click('[type="submit"]'),
      page.waitForNavigation({ 
        waitUntil: 'networkidle2',
        timeout: 60000 
      }),
    ]);

    // Étape 2: Gestion des popups
    console.log('🔍 Vérification des popups...');
    try {
      const popupSelector = '[aria-label="Fermer"], [aria-label="Close"]';
      await page.waitForSelector(popupSelector, { timeout: 5000 });
      await page.click(popupSelector);
      console.log('✅ Popup fermée');
    } catch (e) {
      console.log('ℹ️ Aucune popup détectée');
    }

    // Étape 3: Accès au post
    console.log('🔗 Accès au post...');
    await page.goto(POST_URL, { 
      waitUntil: 'networkidle2',
      timeout: 120000 
    });
    
    console.log('⏳ Attente de chargement initial (15s)...');
    await page.evaluate(() => {
      return new Promise(resolve => setTimeout(resolve, 15000));
    });

    // Étape 4: Vérification du chargement du post
    const isPostLoaded = await page.evaluate(() => {
      return document.querySelector('[role="article"]') !== null;
    });
    
    if (!isPostLoaded) {
      throw new Error('Le post ne s\'est pas chargé correctement');
    }
    console.log('✅ Post chargé avec succès');

    // Étape 5: Récupération des commentaires
    let comments = new Set();
    let attempts = 0;
    const maxAttempts = 20;

    console.log('🔁 Début de la récupération des commentaires...');

    while (comments.size < MAX_COMMENTS && attempts < maxAttempts) {
      try {
        // Nouvelle méthode de détection des commentaires
        const newComments = await page.evaluate(() => {
          const commentElements = Array.from(document.querySelectorAll('div[data-ad-comet-preview="message"], div[data-ad-preview="message"]'));
          return commentElements.map(el => {
            const spans = el.querySelectorAll('span');
            return Array.from(spans).map(span => span.innerText).join(' ').trim();
          }).filter(text => text.length > 5);
        });

        newComments.forEach(c => comments.add(c));
        console.log(`📊 ${comments.size} commentaires récupérés...`);

        // Scroll amélioré
        await page.evaluate(() => {
          const commentSection = document.querySelector('[role="article"]') || 
                               document.querySelector('[data-testid="post_message"]').parentElement;
          if (commentSection) {
            commentSection.scrollIntoView({ behavior: 'smooth', block: 'end' });
          } else {
            window.scrollBy(0, window.innerHeight);
          }
        });

        // Attente avec vérification de nouveaux éléments
        await page.evaluate(() => {
          return new Promise(resolve => setTimeout(resolve, 3000));
        });

        if (newComments.length === 0) {
          attempts++;
          console.log('⚠️ Aucun nouveau commentaire détecté, tentative', attempts, '/', maxAttempts);
        } else {
          attempts = 0;
        }

      } catch (err) {
        console.error('❌ Erreur durant la récupération:', err.message);
        attempts++;
      }
    }

    // Étape 6: Sauvegarde des résultats
    const finalComments = Array.from(comments).slice(0, MAX_COMMENTS);
    fs.writeFileSync('facebook_comments.txt', finalComments.join('\n----------------\n'), 'utf8');
    console.log(`✅ ${finalComments.length} commentaires enregistrés dans facebook_comments.txt`);

  } catch (error) {
    console.error('❌ ERREUR CRITIQUE:', error);
    // Capture d'écran pour débogage
    await page.screenshot({ path: 'error_debug.png' });
    console.log('🖼️ Capture d\'écran sauvegardée: error_debug.png');
  } finally {
    await browser.close();
  }
}

// Vérification des dépendances avant exécution
(async () => {
  try {
    await scrapeFacebookPostComments();
  } catch (startupError) {
    console.error('❌ Impossible de démarrer le script:', startupError);
    console.log('💡 Conseils de dépannage:');
    console.log('1. Exécutez "npm update puppeteer"');
    console.log('2. Vérifiez vos identifiants Facebook');
    console.log('3. Essayez avec un autre post public');
  }
})();