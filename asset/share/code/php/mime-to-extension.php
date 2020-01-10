<?php
/**----------------------------------------------------------------------------\
| Resolves a MIME type's common file extension.                                |
+------------------------------------------------------------------------------+
| Usage:                                                                       |
|     echo mime_to_ext('application/javascript');                              |
|                                                                              |
| Result:                                                                      |
|     js                                                                       |
+---------+--------+-------+---------------------------------------------------+
| @param  | string | $mime | A MIME type.                                      |
|         |        |       |                                                   |
| @return | string |       | The MIME type's common file extension.            |
\---------+--------+-------+--------------------------------------------------*/
function mime_to_ext($mime){
    static $extensions = [
        'application/postscript'                                                    => 'ai',
        'text/x-asm'                                                                => 'asm',
        'text/x-msdos-batch'                                                        => 'bat',
        'image/bmp'                                                                 => 'bmp',
        'text/x-c'                                                                  => 'c',
        'application/vnd.ms-cab-compressed'                                         => 'cab',
        'application/pkix-cert'                                                     => 'cer',
        'application/pkix-crl'                                                      => 'crl',
        'application/x-pkcs7-crl'                                                   => 'crl',
        'application/x-x509-ca-cert'                                                => 'crt',
        'application/x-x509-user-cert'                                              => 'crt',
        'application/pkcs10'                                                        => 'csr',
        'text/css'                                                                  => 'css',
        'application/x-x509-ca-cert'                                                => 'der',
        'application/msword'                                                        => 'doc',
        'application/vnd.ms-word.document.macroEnabled.12'                          => 'docm',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'   => 'docx',
        'application/msword'                                                        => 'dot',
        'application/vnd.ms-word.template.macroEnabled.12'                          => 'dotm',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.template'   => 'dotx',
        'application/vnd.ms-fontobject'                                             => 'eot',
        'application/postscript'                                                    => 'eps',
        'application/x-msdownload'                                                  => 'exe',
        'video/x-flv'                                                               => 'flv',
        'image/gif'                                                                 => 'gif',
        'text/html'                                                                 => 'htm',
        'text/html'                                                                 => 'html',
        'image/vnd.microsoft.icon'                                                  => 'ico',
        'image/jpeg'                                                                => 'jpe',
        'image/jpeg'                                                                => 'jpeg',
        'image/jpeg'                                                                => 'jpg',
        'application/javascript'                                                    => 'js',
        'application/json'                                                          => 'json',
        'application/pkcs8'                                                         => 'key',
        'video/quicktime'                                                           => 'mov',
        'audio/mpeg'                                                                => 'mp3',
        'application/x-msdownload'                                                  => 'msi',
        'application/vnd.oasis.opendocument.spreadsheet'                            => 'ods',
        'application/vnd.oasis.opendocument.text'                                   => 'odt',
        'application/x-font-opentype'                                               => 'otf',
        'application/pkcs10'                                                        => 'p10',
        'application/x-pkcs12'                                                      => 'p12',
        'application/x-pkcs7-certificates'                                          => 'p7b',
        'application/pkcs7-mime'                                                    => 'p7c',
        'application/x-pkcs7-certreqresp'                                           => 'p7r',
        'application/pkcs8'                                                         => 'p8',
        'application/pdf'                                                           => 'pdf',
        'application/x-pem-file'                                                    => 'pem',
        'application/x-pkcs12'                                                      => 'pfx',
        'text/x-php'                                                                => 'php',
        'image/png'                                                                 => 'png',
        'application/vnd.ms-powerpoint'                                             => 'pot',
        'application/vnd.ms-powerpoint.template.macroEnabled.12'                    => 'potm',
        'application/vnd.openxmlformats-officedocument.presentationml.template'     => 'potx',
        'application/vnd.ms-powerpoint'                                             => 'ppa',
        'application/vnd.ms-powerpoint.addin.macroEnabled.12'                       => 'ppam',
        'application/vnd.ms-powerpoint'                                             => 'pps',
        'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'                   => 'ppsm',
        'application/vnd.openxmlformats-officedocument.presentationml.slideshow'    => 'ppsx',
        'application/vnd.ms-powerpoint'                                             => 'ppt',
        'application/vnd.ms-powerpoint.presentation.macroEnabled.12'                => 'pptm',
        'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'pptx',
        'application/postscript'                                                    => 'ps',
        'image/vnd.adobe.photoshop'                                                 => 'psd',
        'video/quicktime'                                                           => 'qt',
        'application/x-rar-compressed'                                              => 'rar',
        'application/rtf'                                                           => 'rtf',
        'application/font-sfnt'                                                     => 'sfnt',
        'text/x-shellscript'                                                        => 'sh',
        'application/x-pkcs7-certificates'                                          => 'spc',
        'application/sql'                                                           => 'sql',
        'image/svg+xml'                                                             => 'svg',
        'image/svg+xml'                                                             => 'svgz',
        'application/x-shockwave-flash'                                             => 'swf',
        'image/tiff'                                                                => 'tif',
        'image/tiff'                                                                => 'tiff',
        'application/x-font-truetype'                                               => 'ttf',
        'application/x-font-ttf'                                                    => 'ttf',
        'text/plain'                                                                => 'txt',
        'application/internet-shortcut'                                             => 'url',
        'application/font-woff'                                                     => 'woff',
        'application/font-woff2'                                                    => 'woff2',
        'application/vnd.ms-excel'                                                  => 'xla',
        'application/vnd.ms-excel.addin.macroEnabled.12'                            => 'xlam',
        'application/vnd.ms-excel'                                                  => 'xls',
        'application/vnd.ms-excel.sheet.binary.macroEnabled.12'                     => 'xlsb',
        'application/vnd.ms-excel.sheet.macroEnabled.12'                            => 'xlsm',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'         => 'xlsx',
        'application/vnd.ms-excel'                                                  => 'xlt',
        'application/vnd.ms-excel.template.macroEnabled.12'                         => 'xltm',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.template'      => 'xltx',
        'application/xml'                                                           => 'xml',
        'application/zip'                                                           => 'zip',
    ];
    $mime = mb_strtolower($mime);
    if(!empty($extensions[$mime])) return $extensions[$mime];
}
