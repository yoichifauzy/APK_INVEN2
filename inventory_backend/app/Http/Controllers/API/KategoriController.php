<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Kategori;
use Illuminate\Http\Request;

class KategoriController extends Controller
{
    public function index(Request $request)
    {
        $me = $request->user();
        if (!$me) return response()->json(['message' => 'Unauthorized'], 403);

        $cats = Kategori::orderBy('nama_kategori')->get();
        return response()->json($cats);
    }

    public function store(Request $request)
    {
        $me = $request->user();
        if (!$me) return response()->json(['message' => 'Unauthorized'], 403);

        $data = $request->validate([
            'nama_kategori' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
        ]);

        $cat = Kategori::create($data);
        return response()->json($cat, 201);
    }

    public function update(Request $request, $id)
    {
        $me = $request->user();
        if (!$me) return response()->json(['message' => 'Unauthorized'], 403);

        $cat = Kategori::find($id);
        if (!$cat) return response()->json(['message' => 'Not found'], 404);

        $data = $request->validate([
            'nama_kategori' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
        ]);

        $cat->update($data);
        return response()->json($cat);
    }

    public function destroy(Request $request, $id)
    {
        $me = $request->user();
        if (!$me) return response()->json(['message' => 'Unauthorized'], 403);

        $cat = Kategori::find($id);
        if (!$cat) return response()->json(['message' => 'Not found'], 404);

        $cat->delete();
        return response()->json(null, 204);
    }
}
