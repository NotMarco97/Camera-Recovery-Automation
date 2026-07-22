const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const MAX_FAILURE_LOGS = 100;

let restartCount = 0;

function log(message) {
    const timestamp = new Date().toLocaleString();
    console.log(`[${timestamp}] ${message}`);
}

function saveFailureLog(reason) {

    const logsDirectory = path.join(__dirname, 'logs');

    if (!fs.existsSync(logsDirectory)) {
        fs.mkdirSync(logsDirectory);
    }

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');

    const filePath = path.join(
        logsDirectory,
        `failure-${timestamp}.log`
    );

    const contents =
`Timestamp: ${new Date().toLocaleString()}
Restart: #${restartCount}
Reason: ${reason}
`;

    fs.writeFileSync(filePath, contents);

    cleanupFailureLogs(logsDirectory);

    log(`Failure log saved: ${filePath}`);
}

function cleanupFailureLogs(logsDirectory) {

    const logFiles = fs.readdirSync(logsDirectory)
        .filter(file => file.endsWith('.log'))
        .map(file => ({
            name: file,
            path: path.join(logsDirectory, file),
            modified: fs.statSync(path.join(logsDirectory, file)).mtimeMs
        }))
        .sort((a, b) => b.modified - a.modified);

    while (logFiles.length > MAX_FAILURE_LOGS) {
        const oldest = logFiles.pop();
        fs.unlinkSync(oldest.path);
    }
}

(async () => {

    const configuration = JSON.parse(process.argv[2]);

    log("Camera Recovery Automation started.");

    while (true) {

        restartCount++;
        log(`Starting browser session #${restartCount}.`);

        await launchBrowser(configuration);
    }

})();

async function launchBrowser(configuration) {

    log("Launching Microsoft Edge...");

    const browser = await chromium.launch({
        channel: 'msedge',
        headless: configuration.headless,
        args: configuration.startMaximized
            ? ['--start-maximized']
            : []
    });

    try {

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

        log("Navigating to NVR...");
        await page.goto(configuration.url);

        log("Connected. Monitoring session.");

        const intervalMs = configuration.monitorIntervalSeconds * 1000;

        await monitorSession(page, intervalMs);

    } finally {

        log("Closing browser.");
        await browser.close();

    }
}

async function monitorSession(page, intervalMs) {

    let monitoringStarted = false;

    while (true) {

        await page.waitForTimeout(intervalMs);

        const video = page.locator('video').first();
        const videoDetected = await video.isVisible();

        if (!videoDetected) {

            saveFailureLog("Video missing");

            log("Video missing. Restarting session...");
            return;
        }

        if (!monitoringStarted) {
            log("Video detected. Monitoring active.");
            monitoringStarted = true;
        }
    }
}