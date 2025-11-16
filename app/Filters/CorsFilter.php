<?php namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class CorsFilter implements FilterInterface
{
    protected $allowedOrigins = [
        // Development: tambahkan origin Flutter Web Anda di sini
        'http://localhost:8080',
        // 'http://127.0.0.1:8080',
        // Production: 'https://myapp.com'
    ];

    public function before(RequestInterface $request, $arguments = null)
    {
        $origin = $request->getServer('HTTP_ORIGIN');
        $response = service('response');

        // Pilih origin yang diizinkan (jangan gunakan '*' jika Anda butuh credentials)
        if ($origin && in_array($origin, $this->allowedOrigins)) {
            $response->setHeader('Access-Control-Allow-Origin', $origin);
            // Jika Anda ingin mengizinkan credential (cookie / auth header):
            // $response->setHeader('Access-Control-Allow-Credentials', 'true');
        } else {
            // Fallback: jika Anda yakin dev-only, bisa pakai '*' tapi jangan di production.
            $response->setHeader('Access-Control-Allow-Origin', '*');
        }

        $response->setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
        $response->setHeader('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, Authorization, X-Requested-With');
        // Optional: exposed headers
        $response->setHeader('Access-Control-Expose-Headers', 'Content-Length, Content-Range');

        // Jika request OPTIONS (preflight), kembalikan response cepat dengan status 200
        if ($request->getMethod(true) === 'OPTIONS') {
            // stop processing further and return response
            $response->setStatusCode(200);
            // Pastikan response dikembalikan (CI4 menerima ResponseInterface)
            return $response;
        }

        // untuk request normal, filter tidak perlu mengembalikan apa-apa
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // Pastikan header juga ada pada response akhir (beberapa route/response mungkin menimpa)
        // Jika sudah di-set di before, ini opsional. Tetapi aman untuk set ulang:
        if (!$response->hasHeader('Access-Control-Allow-Origin')) {
            $origin = $request->getServer('HTTP_ORIGIN');
            if ($origin && in_array($origin, $this->allowedOrigins)) {
                $response->setHeader('Access-Control-Allow-Origin', $origin);
                // $response->setHeader('Access-Control-Allow-Credentials', 'true');
            } else {
                $response->setHeader('Access-Control-Allow-Origin', '*');
            }
        }
        if (!$response->hasHeader('Access-Control-Allow-Methods')) {
            $response->setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
        }
        if (!$response->hasHeader('Access-Control-Allow-Headers')) {
            $response->setHeader('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, Authorization, X-Requested-With');
        }
    }
}
