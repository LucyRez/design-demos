const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const dotenv = require('dotenv');

// Load environment variables from .env file
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Genius API base URL
const GENIUS_API_URL = 'https://api.genius.com';

// Middleware for parsing JSON
app.use(express.json());

// Route to fetch song information, lyrics, and album cover from Genius API
app.get('/lyrics/:song', async (req, res) => {
  const song = req.params.song;

  try {
    // 1. Make a request to Genius API to search for the song
    const response = await axios.get(`${GENIUS_API_URL}/search`, {
      headers: {
        Authorization: `Bearer ${process.env.GENIUS_ACCESS_TOKEN}`,
      },
      params: {
        q: song, // The song to search for
      },
    });

    // 2. If no results found
    if (response.data.response.hits.length === 0) {
      return res.status(404).json({ message: 'Song not found' });
    }

    // 3. Get the first result (most relevant)
    const songInfo = response.data.response.hits[0].result;
    console.log(songInfo)

    // 4. Fetch the Genius page URL for the lyrics
    const songUrl = songInfo.url;

    // 5. Fetch the lyrics page HTML
    const lyricsPage = await axios.get(songUrl);
    const $ = cheerio.load(lyricsPage.data);

    // 6. Extract lyrics and preserve new lines
    let lyrics = '';

    $('[data-lyrics-container]').each((i, elem) => {
      const htmlContent = $(elem).html();
      lyrics += htmlContent
        .replace(/<br\s*\/?>/gi, '\n') // Replace <br> tags with new line characters
        .replace(/<\/?[^>]+(>|$)/g, ''); // Remove other HTML tags but preserve text
    });

    // 7. Extract album cover (if available)
    const albumCover = songInfo.song_art_image_url ? songInfo.song_art_image_url : null;

    // 8. Respond with song info, album cover, and lyrics
    res.json({
      title: songInfo.title,
      artist: songInfo.primary_artist.name,
      album_cover: albumCover || 'No album cover available',
      lyrics: lyrics.trim() || 'Lyrics not found',
    });
  } catch (error) {
    console.error('Error fetching data from Genius API or scraping:', error.message);
    res.status(500).json({ error: 'Error fetching lyrics from Genius' });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
