const { chromium } = require('playwright');

const scrapeTESDA = async (lastName, firstName, certFirstFour, certLastFour) => {
    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto('https://www.tesda.gov.ph/Rwac/Rwac2017');
    await page.waitForLoadState('networkidle');

    const iframeElement = await page.locator('iframe');
    const frame = await iframeElement.contentFrame();

    if (!frame) {
        await browser.close();
        return { success: false, data: null };
    }

    await frame.getByRole('textbox', { name: 'Last Name' }).fill(lastName);
    await frame.getByRole('textbox', { name: 'First Name' }).fill(firstName);
    await frame.getByRole('textbox', { name: 'First Four of Certificate' }).fill(certFirstFour);
    await frame.getByRole('textbox', { name: 'Last Four of Certificate' }).fill(certLastFour);
    await frame.getByRole('button', { name: 'Search' }).click();

    await page.waitForTimeout(3000);

    const noData = await frame.locator('text=No Data Found').isVisible();
    if (noData) {
        await browser.close();
        return { success: true, data: null };
    }

    const rows = await frame.locator('table tr').all();
    let results = [];

    for (let i = 1; i < rows.length; i++) {
        const cells = await rows[i].locator('td').allTextContents();
        results.push(cells.map(cell => cell.trim()));
    }

    await browser.close();
    return { success: true, data: results };
};

module.exports = scrapeTESDA;
