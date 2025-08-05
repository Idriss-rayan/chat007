const axios = require("axios");
const cheerio = require("cheerio");

const BASE_URL = "https://books.toscrape.com/";

async function scrapeBooks() {
  try {
    const { data } = await axios.get(BASE_URL);
    const $ = cheerio.load(data);

    const books = [];

    $(".product_pod").each((index, element) => {
      const title = $(element).find("h3 a").attr("title");
      const price = $(element).find(".price_color").text();
      const availability = $(element).find(".availability").text().trim();

      books.push({ title, price, availability });
    });

    console.log("📚 Livres trouvés :");
    console.table(books);
  } catch (error) {
    console.error("❌ Erreur de scraping :", error.message);
  }
}

scrapeBooks();
