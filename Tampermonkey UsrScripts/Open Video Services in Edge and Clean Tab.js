// ==UserScript==
// @name         Open Video Services in Edge and Clean Tab
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Redirect video services to Edge, and clean up the Firefox tab after
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const services = [
        'netflix.com',
        'primevideo.com',
        'disneyplus.com',
        'hulu.com',
        'amazon.de/gp/video'
    ];

    const currentUrl = window.location.href;
    const shouldRedirect = services.some(service => currentUrl.includes(service));

    if (shouldRedirect) {
        const edgeUrl = 'microsoft-edge:' + currentUrl;
        window.location.replace(edgeUrl);

        // Clear out the page after 0.5s so tab isn't left on video site
        setTimeout(() => {
            document.body.innerHTML = '<h1 style="font-family:sans-serif;">Redirected to Edge</h1>';
            document.title = 'Redirected';
            window.history.replaceState(null, '', '/');
        }, 500);

        return;
    }

    // Redirect matching links to Edge on click
    function redirectLinks() {
        document.querySelectorAll('a[href]').forEach(link => {
            services.forEach(service => {
                if (link.href.includes(service)) {
                    link.addEventListener('click', function(e) {
                        e.preventDefault();
                        window.location.href = 'microsoft-edge:' + link.href;
                    });
                }
            });
        });
    }

    const observer = new MutationObserver(redirectLinks);
    observer.observe(document.body, { childList: true, subtree: true });

    redirectLinks();
})();
