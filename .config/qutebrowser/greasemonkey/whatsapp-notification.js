// ==UserScript==
// @name         Fix web WhatsApp Notifications
// @description  Automatically clicks the 'Turn on desktop notifications' button
// @version      1.0
// @namespace    https://web.whatsapp.com/
// @run-at       document-idle
// @grant        none
// ==/UserScript==
(function() {
    'use strict';
    var waitForThatFrickingButton = setInterval(function() {
        let xpath = "//span[@class='lHWcP'][contains(.,'Turn on desktop notifications')]";
        let button = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
        if (button) {
            button.click();
            clearInterval(waitForThatFrickingButton);
        }
    }, 500);
})();   
