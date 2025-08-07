const { YoutubeTranscript } = require('youtube-transcript');

async function getTranscript(videoId) {
  try {
    const transcript = await YoutubeTranscript.fetchTranscript(videoId, { lang: 'en' });

    console.log(`📝 Sous-titres pour la vidéo ${videoId} :`);
    transcript.slice(0, 5).forEach(line => {
      console.log(`[${line.start}s] ${line.text}`);
    });
  } catch (error) {
    console.error(`❌ Erreur avec la vidéo ${videoId}:`, error.message);
  }
}

getTranscript('stXgn2iZAAY'); // Rick Astley
getTranscript('stXgn2iZAAY'); // Charlie Puth
