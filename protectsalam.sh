#!/bin/bash

# Path standar Pterodactyl
APP_PATH="/var/www/pterodactyl"
FILE_PATH="$APP_PATH/resources/views/templates/wrapper.blade.php"

echo "Menyiapkan script 'Salam User Dinamis'..."

# Cek apakah file template ada
if [ -f "$FILE_PATH" ]; then
    # Kode JavaScript dengan variabel Blade Pterodactyl {{ $user->username }}
    JS_CODE="<script>
        document.addEventListener('DOMContentLoaded', function() {
            @if(isset(\$user))
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'bottom-start',
                    showConfirmButton: false,
                    timer: 5000,
                    timerProgressBar: true,
                    background: '#111827',
                    color: '#fff',
                    didOpen: (toast) => {
                        toast.addEventListener('mouseenter', Swal.stopTimer)
                        toast.addEventListener('mouseleave', Swal.resumeTimer)
                    }
                });

                Toast.fire({
                    icon: 'success',
                    title: '🚀 Hai {{ \$user->username }}, Apa Kabar?'
                });
            @endif
        });
    </script>"

    # Menyisipkan kode sebelum tag penutup </body>
    sed -i "s|</body>|$JS_CODE</body>|g" "$FILE_PATH"
    
    # Membersihkan cache agar perubahan langsung terlihat
    cd $APP_PATH && php artisan view:clear
    
    echo "--------------------------------------------------"
    echo "✅ Berhasil! Sapaan sekarang mengikuti USERNAME login."
    echo "Tidak ada lagi kata 'admin' yang dipaksakan."
    echo "--------------------------------------------------"
else
    echo "❌ Error: File tidak ditemukan di $APP_PATH."
fi
