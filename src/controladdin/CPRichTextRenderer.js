(function () {
    const allowedTags = new Set([
        'a', 'b', 'blockquote', 'br', 'caption', 'div', 'em', 'figcaption', 'figure',
        'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'i', 'li', 'ol', 'p', 's', 'span',
        'img', 'strong', 'table', 'tbody', 'td', 'th', 'thead', 'tr', 'u', 'ul'
    ]);
    const blockedTags = new Set([
        'audio', 'base', 'button', 'embed', 'form', 'iframe', 'input', 'link', 'meta',
        'object', 'script', 'style', 'svg', 'video'
    ]);
    const allowedStyles = new Set([
        'background-color', 'color', 'font-family', 'font-size', 'font-style',
        'font-weight', 'height', 'line-height', 'margin', 'margin-bottom', 'margin-left',
        'margin-right', 'margin-top', 'max-height', 'max-width', 'object-fit',
        'text-align', 'text-decoration', 'width'
    ]);
    const allowedAlignments = new Set(['center', 'justify', 'left', 'right']);

    function safeImageSource(source) {
        const dataImagePattern = /^data:image\/(?:png|jpeg|gif|webp);base64,[a-z0-9+/=\s]+$/i;
        if (dataImagePattern.test(source))
            return source;

        try {
            const imageUrl = new URL(source, window.location.href);
            if ((imageUrl.protocol === 'https:' || imageUrl.protocol === 'http:') && imageUrl.origin === window.location.origin)
                return imageUrl.href;
        } catch (_error) {
            return '';
        }

        return '';
    }

    function sanitizeNode(node, outputDocument) {
        if (node.nodeType === Node.TEXT_NODE)
            return outputDocument.createTextNode(node.nodeValue || '');

        if (node.nodeType !== Node.ELEMENT_NODE)
            return outputDocument.createDocumentFragment();

        const tagName = node.tagName.toLowerCase();
        if (blockedTags.has(tagName))
            return outputDocument.createDocumentFragment();

        if (tagName === 'img') {
            const source = safeImageSource(node.getAttribute('src') || '');
            if (!source)
                return outputDocument.createDocumentFragment();

            const cleanImage = outputDocument.createElement('img');
            cleanImage.setAttribute('src', source);
            cleanImage.setAttribute('alt', node.getAttribute('alt') || '');
            if (node.hasAttribute('width') && /^\d{1,4}$/.test(node.getAttribute('width')))
                cleanImage.setAttribute('width', node.getAttribute('width'));
            if (node.hasAttribute('height') && /^\d{1,4}$/.test(node.getAttribute('height')))
                cleanImage.setAttribute('height', node.getAttribute('height'));
            if (node.hasAttribute('style')) {
                for (const property of node.style) {
                    const value = node.style.getPropertyValue(property).trim();
                    if (allowedStyles.has(property) && CSS.supports(property, value))
                        cleanImage.style.setProperty(property, value);
                }
            }
            cleanImage.style.maxWidth = '100%';
            return cleanImage;
        }

        const children = outputDocument.createDocumentFragment();
        for (const child of node.childNodes)
            children.appendChild(sanitizeNode(child, outputDocument));

        if (!allowedTags.has(tagName))
            return children;

        const cleanElement = outputDocument.createElement(tagName);
        if (node.hasAttribute('style')) {
            for (const property of node.style) {
                const value = node.style.getPropertyValue(property).trim();
                if (!allowedStyles.has(property) || /url\s*\(|expression|javascript/i.test(value))
                    continue;
                if (CSS.supports(property, value))
                    cleanElement.style.setProperty(property, value);
            }
        }
        const alignment = (node.getAttribute('align') || '').toLowerCase();
        if (allowedAlignments.has(alignment))
            cleanElement.style.textAlign = alignment;

        if (tagName === 'a') {
            const href = node.getAttribute('href') || '';
            if (/^(https?:|mailto:)/i.test(href))
                cleanElement.setAttribute('href', href);
        }

        cleanElement.appendChild(children);
        return cleanElement;
    }

    function reportFailure(message) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RenderFailed', [message]);
    }

    function isTransparent(color) {
        return !color || color === 'transparent' || color === 'rgba(0, 0, 0, 0)';
    }

    function prepareImages(host) {
        for (const image of host.querySelectorAll('img')) {
            image.style.display = 'block';
            image.style.marginLeft = 'auto';
            image.style.marginRight = 'auto';
            const figure = image.closest('figure');
            if (figure) {
                figure.style.marginLeft = 'auto';
                figure.style.marginRight = 'auto';
                figure.style.textAlign = 'center';
            }
        }
    }

    function drawDomBackgrounds(context, host, hostRect) {
        for (const element of host.querySelectorAll('*')) {
            const style = window.getComputedStyle(element);
            if (isTransparent(style.backgroundColor))
                continue;
            context.fillStyle = style.backgroundColor;
            for (const rect of element.getClientRects())
                context.fillRect(rect.left - hostRect.left, rect.top - hostRect.top, rect.width, rect.height);
        }
    }

    function drawDomImages(context, host, hostRect, maxWidth) {
        for (const image of host.querySelectorAll('img')) {
            const rect = image.getBoundingClientRect();
            if (!rect.width || !rect.height)
                continue;
            const imageScale = Math.min(1, maxWidth / rect.width);
            const width = rect.width * imageScale;
            const height = rect.height * imageScale;
            const x = (host.clientWidth - width) / 2;
            const y = rect.top - hostRect.top;
            context.drawImage(image, x, y, width, height);
        }
    }

    function drawDomText(context, host, hostRect) {
        const walker = document.createTreeWalker(host, NodeFilter.SHOW_TEXT);
        let textNode;
        while ((textNode = walker.nextNode())) {
            const text = textNode.nodeValue || '';
            if (!text.trim())
                continue;
            const style = window.getComputedStyle(textNode.parentElement);
            if (style.visibility === 'hidden' || style.display === 'none')
                continue;
            const fontSize = parseFloat(style.fontSize) || 14;
            context.font = style.font || (style.fontStyle + ' ' + style.fontWeight + ' ' + fontSize + 'px ' + style.fontFamily);
            context.fillStyle = style.color || '#000';
            context.direction = style.direction;
            context.textBaseline = 'alphabetic';

            const range = document.createRange();
            const lines = new Map();
            let offset = 0;
            for (const character of text) {
                const start = offset;
                offset += character.length;
                if (/\s/.test(character) && character !== ' ' && character !== '\u00a0')
                    continue;
                range.setStart(textNode, start);
                range.setEnd(textNode, offset);
                const rect = range.getBoundingClientRect();
                if (!rect.width || !rect.height)
                    continue;
                const top = Math.round(rect.top * 10) / 10;
                if (!lines.has(top))
                    lines.set(top, { text: '', left: rect.left, top: rect.top, height: rect.height });
                lines.get(top).text += character;
            }

            for (const line of lines.values()) {
                const baseline = line.top - hostRect.top + (line.height - fontSize) / 2 + fontSize * 0.8;
                const x = line.left - hostRect.left;
                context.fillText(line.text, x, baseline);
                const decoration = style.textDecorationLine || style.textDecoration || '';
                const width = context.measureText(line.text).width;
                context.strokeStyle = style.color || '#000';
                context.lineWidth = Math.max(1, fontSize / 14);
                if (decoration.indexOf('underline') >= 0) {
                    context.beginPath();
                    context.moveTo(x, baseline + 1);
                    context.lineTo(x + width, baseline + 1);
                    context.stroke();
                }
                if (decoration.indexOf('line-through') >= 0) {
                    context.beginPath();
                    context.moveTo(x, baseline - fontSize * 0.3);
                    context.lineTo(x + width, baseline - fontSize * 0.3);
                    context.stroke();
                }
            }
        }
    }

    window.RenderHtml = async function (html) {
        try {
            const parsed = new DOMParser().parseFromString(String(html || ''), 'text/html');
            const cleanDocument = document.implementation.createHTMLDocument('');
            const cleanRoot = cleanDocument.createElement('div');
            for (const node of parsed.body.childNodes)
                cleanRoot.appendChild(sanitizeNode(node, cleanDocument));

            const width = 752;
            const height = 384;
            const host = document.createElement('div');
            host.setAttribute('aria-hidden', 'true');
            host.style.cssText = [
                'position:fixed', 'left:-10000px', 'top:0', 'width:' + width + 'px',
                'box-sizing:border-box', 'padding:8px',
                'overflow:visible', 'background:#fff', 'color:#000',
                'font:14px/normal "Segoe UI",sans-serif'
            ].join(';');
            host.innerHTML = cleanRoot.innerHTML;
            document.body.appendChild(host);

            await document.fonts.ready;
            prepareImages(host);
            await Promise.all(Array.from(host.querySelectorAll('img')).map(function (image) { return image.decode(); }));
            await new Promise(function (resolve) {
                requestAnimationFrame(function () { requestAnimationFrame(resolve); });
            });

            const pixelScale = 2;
            const renderScale = Math.min(1, (height - 16) / Math.max(1, host.scrollHeight - 16));
            const xOffset = (width - width * renderScale) / 2;
            const yOffset = 8;
            const canvas = document.createElement('canvas');
            canvas.width = width * pixelScale;
            canvas.height = height * pixelScale;
            const context = canvas.getContext('2d');
            context.fillStyle = '#fff';
            context.fillRect(0, 0, canvas.width, canvas.height);
            const hostRect = host.getBoundingClientRect();
            context.setTransform(pixelScale * renderScale, 0, 0, pixelScale * renderScale, pixelScale * xOffset, pixelScale * yOffset);
            drawDomBackgrounds(context, host, hostRect);
            drawDomImages(context, host, hostRect, width - 16);
            drawDomText(context, host, hostRect);
            document.body.removeChild(host);

            const imageBase64 = canvas.toDataURL('image/png').split(',')[1];
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ImageReady', [imageBase64]);
        } catch (error) {
            reportFailure(String(error));
        }
    };
})();