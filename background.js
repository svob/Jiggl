/*
 *  Copyright (c) 2016 Frank Trigub. All rights reserved.*
    frankyyyy at live com
*/

console.log('Starting extension');

var requestFilter = {
        urls: ['<all_urls>']
    },

    extraInfoSpec = ['requestHeaders', 'blocking'],
    handler = function(details) {

        var isRefererSet = false;
        var originSet = false;
        var forge = false;
        var headers = details.requestHeaders,
            blockingResponse = {};

        for (var j = 0, k = headers.length; j < k; ++j) {
            if (headers[j].name === 'forgeme') {
                forge = true;
            }
        }

        if (forge) {
            //  forge this request
            for (var i = 0, l = headers.length; i < l; ++i) {
                if (headers[i].name === 'Referer') {
                    headers[i].value = 'https://hydranewmedia.atlassian.net';
                    isRefererSet = true;
                }
                if (headers[i].name === 'Origin') {
                    headers[i].value = 'https://hydranewmedia.atlassian.net';
                    originSet = true;
                }
            }

            if (!isRefererSet) {
                headers.push({
                    name: 'Referer',
                    value: 'https://hydranewmedia.atlassian.net'
                });
            }

            if (!originSet) {
                headers.push({
                    name: 'Origin',
                    value: 'https://hydranewmedia.atlassian.net'
                });
            }

        }


        blockingResponse.requestHeaders = headers;
        return blockingResponse;
    };

chrome.webRequest.onBeforeSendHeaders.addListener(handler, requestFilter, extraInfoSpec);


// Called when the user clicks on the browser action.
chrome.browserAction.onClicked.addListener(function() {
    // No tabs or host permissions needed!
    chrome.tabs.executeScript({
        file: 'parser.js'
    });
});
