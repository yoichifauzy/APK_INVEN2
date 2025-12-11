<?php
// database/migrations/2025_12_11_120000_add_lokasi_to_barang_keluar_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('barang_keluar', function (Blueprint $table) {
            $table->string('lokasi')->nullable()->after('keterangan');
        });
    }

    public function down(): void
    {
        Schema::table('barang_keluar', function (Blueprint $table) {
            $table->dropColumn('lokasi');
        });
    }
};
