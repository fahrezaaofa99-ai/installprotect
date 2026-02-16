#!/bin/bash

# Path utama Pterodactyl
APP_PATH="/var/www/pterodactyl"
FILE_PATH="$APP_PATH/resources/views/templates/wrapper.blade.php"

echo "Memulai instalasi 'Salam User' yang dijamin work..."

if [ -f "$FILE_PATH" ]; then
    # 1. Bersihkan sisa-sisa script lama agar tidak double
    sed -i '//,//d' "$FILE_PATH"

    # 2. Siapkan Kode JavaScript yang mandiri (Stand-alone)
    # Menggunakan CDN SweetAlert2 langsung agar tidak tergantung internal panel
    JS_INJECT="<script src=\"https://cdn.jsdelivr.net/npm/sweetalert2@11\"></script>
    <script>
        (function() {
            window.addEventListener('load', function() {
                @if(isset(\$user))
                    Swal.fire({
                        toast: true,
                        position: 'bottom-start',
                        showConfirmButton: false,
                        timer: 5000,
                        timerProgressBar: true,
                        background: '#111827',
                        color: '#ffffff',
                        icon: 'success',
                        iconColor: '#10b981',
                        title: '🚀 Hai {{ \$user->username }}, Apa Kabar?'
                    });
                @endif
            });
        })();
    </script>
    "

    # 3. Inject kode tepat sebelum tag penutup </body>
    # Menggunakan variabel shell agar karakter khusus tidak rusak
    printf "%s\n" "$JS_INJECT" > /tmp/salam_code.txt
    sed -i "/<\/body>/e cat /tmp/salam_code.txt" "$FILE_PATH"
    rm /tmp/salam_code.txt

    # 4. Berikan izin akses (Permission) yang benar
    chown www-data:www-data "$FILE_PATH"

    # 5. BERSIHKAN SEMUA CACHE (Sangat Penting!)
    cd $APP_PATH
    php artisan view:clear
    php artisan cache:clear
    php artisan config:clear

    echo "--------------------------------------------------"
    echo "✅ SELESAI! Script sudah terpasang permanen."
    echo "--------------------------------------------------"
    echo "👉 SEKARANG: Buka panel kamu di Chrome/Browser,"
    echo "👉 LALU TEKAN: CTRL + SHIFT + R (Hard Refresh)."
    echo "--------------------------------------------------"
else
    echo "❌ ERROR: File wrapper.blade.php tidak ditemukan!"
    echo "Pastikan panel kamu ada di /var/www/pterodactyl"
fi
