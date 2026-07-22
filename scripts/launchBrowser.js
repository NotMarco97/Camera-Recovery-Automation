const { chromium } = require('playwright');

(async () => {
    const browser = await chromium.launch({
        headless: false
    });

    const page = await browser.newPage();
    await page.goto('https://example.com');

    await page.waitForTimeout(50000);

    await browser.close();
})();