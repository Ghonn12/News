<?php

namespace App\Controllers\Api;

use App\Models\UmkmModel;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\HTTP\ResponseInterface;

class UmkmController extends ResourceController
{
    /**
     * Mengambil semua data UMKM
     * @return ResponseInterface
     */
    public function index(): ResponseInterface
    {
        $umkmModel = new UmkmModel();
        $umkm = $umkmModel->findAll();

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data'    => $umkm
        ], 200);
    }

    /**
     * Membuat data UMKM baru
     * @return ResponseInterface
     */
    public function create(): ResponseInterface
    {
        $validation = \Config\Services::validation();

        $rules = [
            'nama_umkm' => 'required|min_length[3]|is_unique[umkm.nama_umkm]',
            'kategori'  => 'permit_empty|string',
            'pemilik'   => 'permit_empty|string',
            'alamat'    => 'permit_empty|string',
            'kontak'    => 'permit_empty|string'
        ];

        $data = $this->request->getPost();

        if (!$validation->setRules($rules)->run($data)) {
            return $this->respond([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validation->getErrors()
            ], 400);
        }

        $umkmModel = new UmkmModel();
        $insertedId = $umkmModel->insert($data);

        if ($insertedId === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menambahkan data UMKM',
                'errors'  => $umkmModel->errors()
            ], 500);
        }

        $newData = $umkmModel->find($insertedId);
        return $this->respondCreated([
            'success' => true,
            'message' => 'Data UMKM berhasil ditambahkan',
            'data'    => $newData
        ]);
    }

    /**
     * Memperbarui data UMKM berdasarkan ID
     * @param int|string|null $id
     * @return ResponseInterface
     */
    public function update($id = null): ResponseInterface
    {
        $umkmModel = new UmkmModel();
        
        // Cek dulu apakah data ada
        $existingData = $umkmModel->find($id);
        if (!$existingData) {
            return $this->failNotFound('Data UMKM tidak ditemukan');
        }

        $data = $this->request->getRawInput();
        $umkmModel->update($id, $data);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diubah',
            'data'    => $umkmModel->find($id) // Kirim data terbaru setelah update
        ], 200);
    }

    /**
     * Menghapus data UMKM berdasarkan ID
     * @param int|string|null $id
     * @return ResponseInterface
     */
    public function delete($id = null): ResponseInterface
    {
        $umkmModel = new UmkmModel();
        $data = $umkmModel->find($id);

        if (!$data) {
            return $this->respond([
                'success' => false,
                'message' => 'Data UMKM tidak ditemukan',
            ], 404);
        }

        $umkmModel->delete($id);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil dihapus',
            'data'    => $data // Mengembalikan data yang baru saja dihapus
        ], 200);
    }
}