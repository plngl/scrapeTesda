const express = require('express');
const scrapeTESDA = require('./ScrapeTesda');
const app = express();

app.get('/scrape', async (req, res) => {
    const { lname, fname, c1, c2 } = req.query;

    if (!lname || !fname || !c1 || !c2) {
        return res.status(400).json({ error: 'Missing parameters' });
    }

    try {
        const result = await scrapeTESDA(lname, fname, c1, c2);
        res.json(result);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Something went wrong' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
