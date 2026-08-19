<?php
$targetUrl = $_GET['url'] ?? '';
$maxSize = 500 * 1024; 

if (empty($targetUrl) || !filter_var($targetUrl, FILTER_VALIDATE_URL)) {
    http_response_code(400);
    exit('Invalid URL.');
}

$context = stream_context_create([
    'http' => ['method' => 'GET', 'header' => "User-Agent: PHP-Proxy\r\n"]
]);

$stream = @fopen($targetUrl, 'rb', false, $context);
if (!$stream) {
    http_response_code(502);
    exit('Unable to fetch external file.');
}

$bytesDownloaded = 0;
$isFirstBlock = true;

while (!feof($stream)) {
    $chunk = fread($stream, 8192);
    $chunkSize = strlen($chunk);
    $bytesDownloaded += $chunkSize;

    if ($bytesDownloaded > $maxSize) {
        fclose($stream);
        http_response_code(413);
        exit('File size exceeds the maximum allowed limit.');
    }

    if ($isFirstBlock) {
        if (strpos($chunk, '%PDF-') !== 0) {
            fclose($stream);
            http_response_code(415);
            exit('The file is not a valid PDF.');
        }
        
        header('Content-Type: application/pdf');
        header('Content-Disposition: inline; filename="documento.pdf"');
        $isFirstBlock = false;
    }

    echo $chunk;
    flush(); 
}

fclose($stream);
