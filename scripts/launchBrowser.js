const { chromium } = require('playwright');

(async () => {

    const configuration = JSON.parse(process.argv[2]);
    const browser = await chromium.launch({
        headless: configuration.headless,
        args: configuration.startMaximized
        ? ['--start-maximized']
        : []
    });
    console.log(configuration.startMaximized);

    const context = await browser.newContext({
        httpCredentials: {
            username: configuration.username,
            password: configuration.password
        },
        
         ignoreHTTPSErrors: configuration.ignoreHttpsErrors,

            viewport:
        configuration.viewportMode === 'host'
            ? null
            : {
                width: 1280,
                height: 720
            }
    });

    const page = await context.newPage();

    await page.goto(configuration.url);

})();