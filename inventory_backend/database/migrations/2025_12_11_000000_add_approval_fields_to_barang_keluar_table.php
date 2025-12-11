<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('barang_keluar', function (Blueprint $table) {
            if (!Schema::hasColumn('barang_keluar', 'approved_by')) {
                $table->unsignedBigInteger('approved_by')->nullable()->after('status');
            }
            if (!Schema::hasColumn('barang_keluar', 'approved_at')) {
                $table->timestamp('approved_at')->nullable()->after('approved_by');
            }
            if (!Schema::hasColumn('barang_keluar', 'rejected_by')) {
                $table->unsignedBigInteger('rejected_by')->nullable()->after('approved_at');
            }
            if (!Schema::hasColumn('barang_keluar', 'rejected_at')) {
                $table->timestamp('rejected_at')->nullable()->after('rejected_by');
            }
            if (!Schema::hasColumn('barang_keluar', 'reject_reason')) {
                $table->text('reject_reason')->nullable()->after('rejected_at');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('barang_keluar', function (Blueprint $table) {
            if (Schema::hasColumn('barang_keluar', 'approved_by')) {
                $table->dropColumn('approved_by');
            }
            if (Schema::hasColumn('barang_keluar', 'approved_at')) {
                $table->dropColumn('approved_at');
            }
            if (Schema::hasColumn('barang_keluar', 'rejected_by')) {
                $table->dropColumn('rejected_by');
            }
            if (Schema::hasColumn('barang_keluar', 'rejected_at')) {
                $table->dropColumn('rejected_at');
            }
            if (Schema::hasColumn('barang_keluar', 'reject_reason')) {
                $table->dropColumn('reject_reason');
            }
        });
    }
};
