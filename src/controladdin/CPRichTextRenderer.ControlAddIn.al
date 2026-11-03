controladdin "CP Rich Text Renderer"
{
    Scripts = 'src/controladdin/CPRichTextRenderer.js';
    StartupScript = 'src/controladdin/CPRichTextRendererStartup.js';
    RequestedHeight = 1;
    RequestedWidth = 1;

    event ControlReady();
    event ImageReady(ImageBase64: Text);
    event RenderFailed(ErrorMessage: Text);

    procedure RenderHtml(Html: Text);
}