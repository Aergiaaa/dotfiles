// // ==UserScript==
// // @name         Youtube Ad Skip Enhanced
// // @version      0.1.0
// // @description  Intelligently skip YouTube ads with reduced detection
// // @author       Adcott
// // @match        *://*.youtube.com/*
// // @run-at       document-start
// // @grant        none
// // ==/UserScript==
//
// (function() {
//     'use strict';
//
//     // Add random delay to mimic human behavior
//     const randomDelay = (min, max) => {
//         return new Promise(resolve => {
//             setTimeout(resolve, Math.random() * (max - min) + min);
//         });
//     };
//
//     // More subtle CSS hiding - uses opacity and pointer-events instead of display:none
//     const style = document.createElement('style');
//     style.textContent = `
//         #player-ads,
//         .adDisplay,
//         .ad-container,
//         .ytd-display-ad-renderer,
//         .video-ads,
//         ytd-rich-item-renderer:has(ytd-ad-slot-renderer),
//         ytd-ad-slot-renderer,
//         #masthead-ad,
//         *[class^="ytd-ad-"],
//         #panels.ytd-watch-flexy {
//             opacity: 0 !important;
//             pointer-events: none !important;
//             position: absolute !important;
//             left: -9999px !important;
//         }
//     `;
//
//     if (document.head) {
//         document.head.appendChild(style);
//     } else {
//         document.addEventListener('DOMContentLoaded', () => {
//             document.head.appendChild(style);
//         });
//     }
//
//     // Track processed ads to avoid repeated actions
//     const processedAds = new WeakSet();
//
//     // Main ad handling function
//     async function handleAds() {
//         try {
//             // Find video element
//             const video = document.querySelector('video.html5-main-video');
//             if (!video) return;
//
//             // Check if ad is showing
//             const adContainer = document.querySelector('.ad-showing');
//             const isAdPlaying = video.closest('.ad-showing') !== null;
//
//             if (isAdPlaying && !processedAds.has(video)) {
//                 processedAds.add(video);
//
//                 // Add random delay before skipping (500-1500ms)
//                 await randomDelay(500, 1500);
//
//                 // Try to skip by speeding up instead of jumping to end
//                 // This is less detectable than setting currentTime to 99999
//                 if (video.duration && video.duration > 0 && video.duration < 60) {
//                     video.playbackRate = 16; // Max speed
//                     video.muted = true;
//
//                     // Wait a bit then check for skip button
//                     await randomDelay(300, 800);
//                 }
//
//                 // Look for skip button with random delay
//                 const skipButton = document.querySelector('.ytp-skip-ad-button, .ytp-ad-skip-button, .ytp-ad-skip-button-modern');
//                 if (skipButton && skipButton.offsetParent !== null) {
//                     await randomDelay(200, 600);
//                     skipButton.click();
//                 }
//
//                 // Reset playback rate after ad
//                 setTimeout(() => {
//                     if (video.playbackRate > 2) {
//                         video.playbackRate = 1;
//                         video.muted = false;
//                     }
//                 }, 1000);
//             }
//
//             // Handle overlay ads
//             const overlayAds = document.querySelectorAll('.ytp-ad-overlay-close-button');
//             for (const closeBtn of overlayAds) {
//                 if (closeBtn.offsetParent !== null) {
//                     await randomDelay(300, 700);
//                     closeBtn.click();
//                 }
//             }
//
//         } catch (error) {
//             // Silently handle errors to avoid detection
//             console.debug('Ad handler:', error);
//         }
//     }
//
//     // Use MutationObserver to watch for ad changes
//     let observer;
//     let checkInterval;
//
//     function startObserving() {
//         // Periodic check every 500ms
//         if (checkInterval) clearInterval(checkInterval);
//         checkInterval = setInterval(handleAds, 500);
//
//         // Also observe DOM changes for faster response
//         if (observer) observer.disconnect();
//
//         observer = new MutationObserver((mutations) => {
//             // Only check if relevant changes occurred
//             for (const mutation of mutations) {
//                 if (mutation.addedNodes.length > 0 || 
//                     mutation.attributeName === 'class') {
//                     handleAds();
//                     break;
//                 }
//             }
//         });
//
//         const container = document.querySelector('#movie_player') || document.body;
//         observer.observe(container, {
//             childList: true,
//             subtree: true,
//             attributes: true,
//             attributeFilter: ['class']
//         });
//     }
//
//     // Initialize when page is ready
//     if (document.readyState === 'loading') {
//         document.addEventListener('DOMContentLoaded', startObserving);
//     } else {
//         startObserving();
//     }
//
//     // Re-initialize on navigation (YouTube is SPA)
//     let lastUrl = location.href;
//     new MutationObserver(() => {
//         const currentUrl = location.href;
//         if (currentUrl !== lastUrl) {
//             lastUrl = currentUrl;
//             // Clear processed ads when navigating
//             setTimeout(startObserving, 1000);
//         }
//     }).observe(document.querySelector('body'), {
//         childList: true,
//         subtree: true
//     });
//
// })();

// // ==UserScript==
// // @name         Youtube Ad Skip
// // @version      0.0.7
// // @description  Make YouTube more tolerable by automatically skipping ads
// // @author       Adcott
// // @match        *://*.youtube.com/*
// // ==/UserScript==
//
// GM_addStyle(`
// #player-ads,
// .adDisplay,
// .ad-container,
// .ytd-display-ad-renderer,
// .video-ads,
// ytd-rich-item-renderer:has(ytd-ad-slot-renderer),
// ytd-ad-slot-renderer,
// #masthead-ad,
// *[class^="ytd-ad-"],
// #panels.ytd-watch-flexy {
//     display: none !important;
// }
// `);
//
// document.addEventListener('load', () => {
//     const ad = document.querySelector('.ad-showing:has(.ytp-ad-persistent-progress-bar-container) video');
//     const skipButton = document.querySelector('.ytp-ad-skip-button');
//
//     if (ad) ad.currentTime = 99999;
//     if (skipButton) skipButton.click();
// }, true);   
