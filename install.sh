#!/bin/bash

# Definisi Warna ANSI
NC='\0330m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
LIGHT_BLUE='\033[1;34m'

# Warna-warni Pelangi untuk Spek VPS
R1='\033[1;31m' # Merah
R2='\033[1;33m' # Kuning
R3='\033[1;32m' # Hijau
R4='\033[1;36m' # Cyan
R5='\033[1;35m' # Magenta
R6='\033[1;34m' # Biru

show_banner() {
  clear
  # Mengambil Data Sistem Secara Real-time
  local uptime_vps=$(uptime -p | sed 's/up //')
  local ip_vps=$(hostname -I | awk '{print $1}')
  local cpu_model=$(lscpu | grep 'Model name' | cut -f2 -d: | sed -e 's/^[ \t]*//' | awk '{print $1,$2,$3}')
  local cpu_cores=$(nproc)
  local ram_used=$(free -h | awk '/Mem:/ {print $3}')
  local ram_total=$(free -h | awk '/Mem:/ {print $2}')
  local disk_usage=$(df -h / | awk 'NR==2 {print $5}')
  local disk_total=$(df -h / | awk 'NR==2 {print $2}')

  # Cetak Logo ASCII Art Gajah (JQ Logo)
  echo -e "${R1}        _,gggggggggg.${NC}"
  echo -e "${R1}    ,ggggggggggggggggg.${NC}"
  echo -e "${R2}  ,ggggg        gggggggg.${NC}"
  echo -e "${R2} ,ggg'               'ggg.${NC}"
  echo -e "${R3}',gg       ,ggg.      'ggg:${NC}"
  echo -e "${R3}'ggg      ,gg'''  .    ggg${NC}"
  echo -e "${R4}gggg      gg     ,     ggg${NC}"
  echo -e "${R4}ggg:     gg.     -   ,ggg${NC}"
  echo -e "${R5} ggg:     ggg._    _,ggg${NC}"
  echo -e "${R5} ggg.    '.'''ggggggp${NC}"
  echo -e "${R6}  'ggg    '-.__${NC}"
  echo -e "${R6}    ggg${NC}"
  echo -e "${R6}      ggg${NC}"
  
  # Spek VPS dengan Teks Pelangi (Rainbow)
  echo -e "${R1}┌ 𝚄𝙿𝚃𝙸𝙼𝙴 𝚅𝙿𝚂  : ${uptime_vps}${NC}"
  echo -e "${R2}├ 𝙸𝙿 𝚅𝙿𝚂      : ${ip_vps}${NC}"
  echo -e "${R3}├ 𝙲𝙿𝚄         : ${cpu_model}${NC}"
  echo -e "${R4}├ 𝙲𝙾𝚁𝙴        : ${cpu_cores} Core(s)${NC}"
  echo -e "${R5}├ 𝚁𝙰𝙼         : ${ram_used} / ${ram_total}${NC}"
  echo -e "${R6}└ 𝙳𝙸𝚂𝙺        : ${disk_usage} / ${disk_total}${NC}"
  echo -e ""
  
  # Teks Terima Kasih Warna Biru
  echo -e "${LIGHT_BLUE}𝚃𝚎𝚛𝚒𝚖𝚊𝚔𝚊𝚜𝚒𝚑 𝚃𝚎𝚕𝚊𝚑 𝙼𝚎𝚖𝚊𝚔𝚊𝚒 𝙱𝚊𝚜𝚑 𝙸𝚗𝚒 𝚂𝚞𝚙𝚙𝚘𝚛𝚝 𝚃𝚎𝚛𝚞𝚜 @lixzhosting${NC}"
  echo -e ""
}

# Color Definitions
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Konfigurasi Theme Installer
PANEL_DIR="/var/www/pterodactyl"
BACKUP_DIR="/var/www/pterodactyl_backup_$(date +%F_%H-%M)"

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${WHITE}[+]                AUTO INSTALLER THEMA             [+]${NC}"
  echo -e "${WHITE}[+]                    © ZelixBotzSetup              [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "script ini di buat untuk mempermudah penginstalasian thema pterodactyle,"
  echo -e "dilarang keras untuk dikasih gratis."
  echo -e ""
  echo -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 :"
  echo -e "@lixzsukatobrut"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦 :"
  echo -e "@lixzsukatobrut"
  sleep 4
  clear
}

#Update and install jq
install_jq() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]             UPDATE & INSTALL JQ                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]              INSTALL JQ BERHASIL                [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
    echo -e "${RED}[+] =============================================== [+]${NC}"
    echo -e "${RED}[+]              INSTALL JQ GAGAL                   [+]${NC}"
    echo -e "${RED}[+] =============================================== [+]${NC}"
    exit 1
  fi
  echo -e "                                                       "
  sleep 1
  clear
}

#Check user token
check_token() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSY ZELIX HOSTING          [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "zelix" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}"
  else
    echo -e "${GREEN}Buy dulu Gih Ke Zelix${NC}"
    echo -e "${YELLOW}TELEGRAM : @lixzsukatobrut${NC}"
    echo -e "${YELLOW}WHATSAPP : 628818585370${NC}"
    echo -e "${YELLOW}HARGA TOKEN : 2K FREE UPDATE JIKA ADA TOKEN BARU${NC}"
    echo -e "${YELLOW}©Author Zelix${NC}"
    exit 1
  fi
  clear
}

# --- FUNGSI-FUNGSI UTAMA MULTI-THEME INSTALLER ---

backup_panel() {
    echo -e "${YELLOW}[+] Membuat Backup Panel...${NC}"
    mkdir -p "$BACKUP_DIR"
    rsync -av --exclude 'storage' --exclude 'node_modules' --exclude '.git' "$PANEL_DIR/" "$BACKUP_DIR/"
    echo -e "${GREEN}[✓] Backup tersimpan di: $BACKUP_DIR${NC}"
}

install_dependencies() {
    echo -e "${YELLOW}[+] Menginstall Dependencies (zip, unzip, curl, tar, git)...${NC}"
    apt update -y
    apt install -y zip unzip curl tar git
}

install_build_tools() {
    echo -e "${YELLOW}[+] Mengecek Build Tools (NodeJS & Yarn)...${NC}"
    unset NODE_OPTIONS
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -lt 20 ]; then
            echo -e "${YELLOW}[!] Node.js versi lama terdeteksi ($NODE_VERSION). Mengupgrade ke Node.js 20...${NC}"
            curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
            apt install -y nodejs
        fi
    else
        echo -e "Install NodeJS..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
        apt install -y nodejs
    fi
    if ! command -v yarn &> /dev/null; then
        echo -e "Install Yarn..."
        npm i -g yarn
    fi
}

fix_permissions() {
    echo -e "${YELLOW}[+] Memperbaiki Permission...${NC}"
    chown -R www-data:www-data "$PANEL_DIR"
    chmod -R 755 "$PANEL_DIR/storage" "$PANEL_DIR/bootstrap/cache"
}

# FUNGSI INSTALASI ELYSIUM THEME
install_elysium_theme() {
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]             INSTALLASI ELYSIUM THEME           [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "                                                       "

    REPO_URL="https://github.com/Bangsano/Autoinstaller-Theme-Pterodactyl.git"
    TEMP_DIR="Autoinstaller-Theme-Pterodactyl"

    git clone "$REPO_URL" "$TEMP_DIR" || { echo "Gagal mengkloning repositori."; return 1; }

    sudo mv "$TEMP_DIR/ElysiumTheme.zip" /var/www/
    unzip -o /var/www/ElysiumTheme.zip -d /var/www/
    rm -rf "$TEMP_DIR" /var/www/ElysiumTheme.zip
    cd /root
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt update
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install 16
    sudo apt install -y nodejs
    apt install npm -y
    npm i -g yarn
    cd /var/www/pterodactyl
    yarn
    yarn build:production
    php artisan migrate
    php artisan view:clear

    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]          ELYSIUM THEME BERHASIL DIINSTALL       [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "                                                       "
}

# FUNGSI MENU MASUKKAN MULTI-THEME
install_multi_theme_menu() {
  if [ ! -d "$PANEL_DIR" ]; then
      echo -e "${RED}[!] Pterodactyl Panel tidak ditemukan di $PANEL_DIR${NC}"
      echo -e "${YELLOW}Silakan install Pterodactyl Panel terlebih dahulu.${NC}"
      sleep 3
      return
  fi

  clear
  echo -e "${BLUE}[+] ======================================================== [+]${NC}"
  echo -e "${WHITE}[+]                     PILIH DAFTAR THEMA                   [+]${NC}"
  echo -e "${BLUE}[+] ======================================================== [+]${NC}"
  echo -e " 1. ${GREEN}Blueprint Framework${NC} (Required for some extensions)"
  echo -e " 2. ${GREEN}Reviactyl${NC} (Full Remake, Modern UI)"
  echo -e " 3. ${GREEN}NookTheme${NC} (Clean, Modern, Open Source)"
  echo -e " 4. ${GREEN}Nightcore${NC} (Dark Mode, Purple Accents)"
  echo -e " 5. ${GREEN}Enola${NC} (Elegant Dark)"
  echo -e " 6. ${GREEN}Twilight${NC} (Deep Dark)"
  echo -e " 7. ${YELLOW}Stellar${NC} (Premium - Manual Upload)"
  echo -e " 8. ${GREEN}Recolor${NC} (Blueprint Extension)"
  echo -e " 9. ${YELLOW}Restore Original Pterodactyl${NC} (Kembali ke awal)"
  echo -e " 10. ${CYAN}Elysium Theme${NC} (Modern Glow Dynamic UI)"
  echo -e " ${RED}x. Kembali ke Menu Utama${NC}"
  echo -e " ------------------------------------------------------------"
  read -p " Pilih menu (1-10/x): " THEME_CHOICE

  if [ "$THEME_CHOICE" == "x" ]; then
      return
  fi

  # Eksekusi install dependencies dasar
  install_dependencies

  case "$THEME_CHOICE" in
    1)
      backup_panel
      echo -e "${BLUE}[+] Menginstall Blueprint Framework...${NC}"
      cd "$PANEL_DIR"
      export PTERODACTYL_DIRECTORY="$PANEL_DIR"
      install_build_tools
      echo -e "${YELLOW}[+] Menjalankan yarn install...${NC}"
      npm i -g yarn
      yarn install
      echo -e "${YELLOW}[+] Menginstall dependencies tambahan (webpack, react)...${NC}"
      yarn add cross-env webpack webpack-cli react react-dom --dev
      wget --no-check-certificate "$(curl -s -k -H "User-Agent: Mozilla/5.0" https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep -o '"browser_download_url": *"[^"]*release.zip"' | head -n 1 | cut -d '"' -f 4)" -O "$PANEL_DIR/release.zip"
      unzip -o release.zip
      echo -e "${YELLOW}[+] Membuat konfigurasi .blueprintrc...${NC}"
      echo 'WEBUSER="www-data";
OWNERSHIP="www-data:www-data";
USERSHELL="/bin/bash";' > "$PANEL_DIR/.blueprintrc"
      chmod +x blueprint.sh
      bash blueprint.sh
      rm release.zip
      echo -e "${YELLOW}[+] Memverifikasi instalasi Blueprint...${NC}"
      if [ -f "/usr/local/bin/blueprint" ]; then
          /usr/local/bin/blueprint -upgrade
      elif command -v blueprint &> /dev/null; then
          blueprint -upgrade
      fi
      fix_permissions
      echo -e "${GREEN}[✓] Blueprint Framework berhasil diinstall!${NC}"
      sleep 3
      ;;
    2)
      backup_panel
      echo -e "${BLUE}[+] Menginstall Reviactyl...${NC}"
      cd "$PANEL_DIR"
      php artisan down
      curl -L -k -H "User-Agent: Mozilla/5.0" -o panel.tar.gz https://github.com/reviactyl/panel/releases/latest/download/panel.tar.gz
      tar -xzvf panel.tar.gz
      chmod -R 755 storage/* bootstrap/cache/
      composer install --no-dev --optimize-autoloader
      php artisan migrate --seed --force
      php artisan view:clear
      php artisan config:clear
      fix_permissions
      php artisan up
      echo -e "${GREEN}[✓] Reviactyl berhasil diinstall!${NC}"
      sleep 3
      ;;
    3)
      backup_panel
      echo -e "${BLUE}[+] Menginstall NookTheme...${NC}"
      cd "$PANEL_DIR"
      php artisan down
      curl -L -k -H "User-Agent: Mozilla/5.0" -o panel.tar.gz https://github.com/Nookure/NookTheme/releases/latest/download/panel.tar.gz
      tar -xzvf panel.tar.gz
      chmod -R 755 storage/* bootstrap/cache/
      composer install --no-dev --optimize-autoloader
      php artisan migrate --seed --force
      php artisan view:clear
      php artisan config:clear
      fix_permissions
      php artisan up
      echo -e "${GREEN}[✓] NookTheme berhasil diinstall!${NC}"
      sleep 3
      ;;
    4)
      backup_panel
      echo -e "${BLUE}[+] Menginstall Nightcore...${NC}"
      bash <(curl -s -k -H "User-Agent: Mozilla/5.0" https://raw.githubusercontent.com/NoPro200/Pterodactyl_Nightcore_Theme/main/install.sh)
      fix_permissions
      echo -e "${GREEN}[✓] Nightcore Theme berhasil diinstall!${NC}"
      sleep 3
      ;;
    5)
      backup_panel
      install_build_tools
      echo -e "${BLUE}[+] Menginstall Enola Theme...${NC}"
      cd "$PANEL_DIR"
      bash <(curl -s -k -H "User-Agent: Mozilla/5.0" https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/main/install.sh)
      echo -e "${YELLOW}[!] Script installer external telah dijalankan.${NC}"
      sleep 4
      ;;
    6)
      backup_panel
      install_build_tools
      echo -e "${BLUE}[+] Menginstall Twilight Theme...${NC}"
      bash <(curl -s -k -H "User-Agent: Mozilla/5.0" https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/main/install.sh)
      echo -e "${YELLOW}[!] Script installer external telah dijalankan.${NC}"
      sleep 4
      ;;
    7)
      backup_panel
      echo -e "${BLUE}[+] Menyiapkan Instalasi Stellar Theme...${NC}"
      echo -e "${YELLOW}[!] Stellar adalah theme berbayar/premium.${NC}"
      echo -e "Silakan upload file ${GREEN}stellar.zip${NC} ke folder /root/ di VPS ini."
      read -p "Jika sudah diupload, tekan ENTER untuk melanjutkan..."
      if [ -f "/root/stellar.zip" ]; then
          cd "$PANEL_DIR"
          php artisan down
          cp /root/stellar.zip "$PANEL_DIR/"
          unzip -o stellar.zip
          chmod -R 755 storage/* bootstrap/cache/
          composer install --no-dev --optimize-autoloader
          php artisan migrate --seed --force
          php artisan view:clear
          php artisan config:clear
          fix_permissions
          php artisan up
          echo -e "${GREEN}[✓] Stellar Theme berhasil diinstall!${NC}"
      else
          echo -e "${RED}[!] File /root/stellar.zip tidak ditemukan.${NC}"
      fi
      sleep 3
      ;;
    8)
      backup_panel
      echo -e "${BLUE}[+] Menginstall Recolor (Blueprint Extension)...${NC}"
      cd "$PANEL_DIR"
      if [ ! -f "$PANEL_DIR/blueprint.sh" ]; then
          echo -e "${RED}[!] Blueprint Framework belum terinstall! Silakan install Menu 1 dulu.${NC}"
          sleep 3
          return
      fi
      RECOLOR_URL=$(curl -s -k -H "User-Agent: Mozilla/5.0" https://api.github.com/repos/BlueprintFramework/Extensions/releases/latest | grep -o '"browser_download_url": *"[^"]*recolor.blueprint"' | head -n 1 | cut -d '"' -f 4)
      if [ -z "$RECOLOR_URL" ]; then
          RECOLOR_URL="https://github.com/BlueprintFramework/Extensions/releases/download/recolor-latest/recolor.blueprint"
      fi
      wget --no-check-certificate "$RECOLOR_URL" -O "recolor.blueprint"
      unset NODE_OPTIONS
      if [ -f "recolor.blueprint" ]; then
          if [ -f "/usr/local/bin/blueprint" ]; then
              /usr/local/bin/blueprint -i recolor.blueprint
          elif command -v blueprint &> /dev/null; then
              blueprint -i recolor.blueprint
          fi
      fi
      sleep 3
      ;;
    9)
      echo -e "${YELLOW}[+] Mengembalikan ke Pterodactyl Original...${NC}"
      cd "$PANEL_DIR"
      php artisan down
      curl -L -k -H "User-Agent: Mozilla/5.0" -o panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
      tar -xzvf panel.tar.gz
      chmod -R 755 storage/* bootstrap/cache/
      composer install --no-dev --optimize-autoloader
      php artisan migrate --seed --force
      php artisan view:clear
      php artisan config:clear
      fix_permissions
      php artisan up
      echo -e "${GREEN}[✓] Pterodactyl Original berhasil direstore!${NC}"
      sleep 3
      ;;
    10)
      backup_panel
      install_elysium_theme
      fix_permissions
      sleep 3
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid!${NC}"
      sleep 2
      ;;
  esac

  # Cek Nginx Nyamuk/Config Default
  if [ ! -f "/etc/nginx/sites-available/pterodactyl.conf" ]; then
      echo -e "${YELLOW}[+] Membuat konfigurasi Nginx default...${NC}"
      cat <<EOF > /etc/nginx/sites-available/pterodactyl.conf
server {
    listen 80;
    server_name \$PANEL_DOMAIN;
    root /var/www/pterodactyl/public;
    index index.php;
    access_log /var/log/nginx/pterodactyl.app-access.log;
    error_log  /var/log/nginx/pterodactyl.app-error.log error;
    client_max_body_size 100m;
    client_body_timeout 120s;
    sendfile off;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
    location ~ /\.ht {
        deny all;
    }
}
EOF
      ln -s /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf 2>/dev/null
      systemctl restart nginx
  fi
}

# --- FUNGSIONALITAS LAINNYA ---

create_node() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    CREATE NODE                     [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  read -p "Masukkan nama lokasi: " location_name
  read -p "Masukkan deskripsi lokasi: " location_description
  read -p "Masukkan domain: " domain
  read -p "Masukkan nama node: " node_name
  read -p "Masukkan RAM (dalam MB): " ram
  read -p "Masukkan jumlah maksimum disk space (dalam MB): " disk_space
  read -p "Masukkan Locid: " locid

  cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; exit 1; }

  php artisan p:location:make <<EOF
$location_name
$location_description
EOF

  php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]        CREATE NODE & LOCATION SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}

configure_wings() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    CONFIGURE WINGS                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  read -p "Masukkan token Configure menjalankan wings: " wings
  eval "$wings"
  sudo systemctl start wings

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 CONFIGURE WINGS SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
  exit 0
}

setup_multi_nodes() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               SETUP MULTI NODES (NODE 2+)       [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  echo -e "${YELLOW}MASUKKAN DOMAIN NODE BARU (ex: node2.zelix.adit.web.id) :${NC}"
  read -r NODE_DOMAIN
  echo -e "${YELLOW}MASUKKAN DAEMON PORT BARU (ex: 8081) :${NC}"
  read -r DAEMON_PORT
  echo -e "${YELLOW}MASUKKAN SFTP PORT BARU (ex: 2023) :${NC}"
  read -r SFTP_PORT

  if [ -z "$NODE_DOMAIN" ] || [ -z "$DAEMON_PORT" ] || [ -z "$SFTP_PORT" ]; then
    echo -e "${RED}[X] Error: Semua data wajib diisi! Proses dibatalkan.${NC}"
    sleep 3
    return
  fi

  NODE_SUFFIX="${DAEMON_PORT}"

  # Validasi DNS PING biar gak NXDOMAIN
  echo -e "\n${YELLOW}[*] Memvalidasi DNS Domain... Mohon tunggu.${NC}"
  sleep 2
  if ! ping -c 1 "$NODE_DOMAIN" &> /dev/null; then
    echo -e "${RED}[X] Domain $NODE_DOMAIN BELUM TERDETEKSI / Belum diarahkan ke IP VPS!${NC}"
    echo -e "${YELLOW}Silakan buat A Record dulu di Cloudflare dan tunggu 1 menit sebelum jalankan ulang.${NC}"
    read -p "Tekan Enter untuk kembali..."
    return
  fi
  echo -e "${GREEN}[✓] DNS OK! Domain sudah mengarah ke VPS ini.${NC}"

  echo -e "\n${GREEN}[*] Membuka Firewall Port ${DAEMON_PORT} & ${SFTP_PORT}...${NC}"
  if command -v ufw &> /dev/null; then
    sudo ufw allow $DAEMON_PORT/tcp
    sudo ufw allow $SFTP_PORT/tcp
    sudo ufw reload
  fi

  echo -e "\n${GREEN}[*] Mematikan Nginx Sementara & Request SSL Let's Encrypt...${NC}"
  sudo systemctl stop nginx
  
  # FIX: Menggunakan --register-unsafely-without-email agar kompatibel dengan Certbot VPS lu
  sudo certbot certonly --standalone -d "$NODE_DOMAIN" --non-interactive --agree-tos --register-unsafely-without-email
  
  echo -e "\n${GREEN}[*] Menyalakan Kembali Nginx Server...${NC}"
  sudo systemctl start nginx

  if [ ! -f "/etc/letsencrypt/live/$NODE_DOMAIN/fullchain.pem" ]; then
    echo -e "${RED}[X] SSL Gagal dibuat! Cek log Certbot lu dulu.${NC}"
    sleep 3
    return
  fi

  echo -e "\n${GREEN}[*] Membuat Direktori & File Template Config Node...${NC}"
  sudo mkdir -p /etc/pterodactyl${NODE_SUFFIX}
  # Buat direktori volume khusus node ini biar ga tabrakan data antar node
  sudo mkdir -p /var/lib/pterodactyl${NODE_SUFFIX}/volumes

  # Pemisahan direktori data volume
  cat <<EOF > /etc/pterodactyl${NODE_SUFFIX}/config.yml
# REPLACE ISI FILE INI DENGAN CONFIG ASLI DARI ENVELOPE CONFIGURATION DI PANEL!
api:
  host: 0.0.0.0
  port: ${DAEMON_PORT}
  ssl:
    enabled: true
    cert: /etc/letsencrypt/live/${NODE_DOMAIN}/fullchain.pem
    key: /etc/letsencrypt/live/${NODE_DOMAIN}/privkey.pem
  upload_limit: 100
system:
  data: /var/lib/pterodactyl${NODE_SUFFIX}/volumes
  sftp:
    bind_port: ${SFTP_PORT}
allowed_mounts: []
EOF

  echo -e "\n${GREEN}[*] Membuat Rumah Service Systemd Baru (wings${NODE_SUFFIX})...${NC}"
  cat <<EOF > /etc/systemd/system/wings${NODE_SUFFIX}.service
[Unit]
Description=Pterodactyl Wings Daemon (Node Port ${DAEMON_PORT})
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/root
LimitNOFILE=1048576
LimitNPROC=512000
ExecStart=/usr/local/bin/wings --config /etc/pterodactyl${NODE_SUFFIX}/config.yml
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

  echo -e "\n${GREEN}[*] Reloading Daemon & Mendaftarkan Service Baru...${NC}"
  sudo systemctl daemon-reload
  sudo systemctl enable wings${NODE_SUFFIX}

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]             SETUP NODES SELESAI!          [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "Langkah Selanjutnya:"
  echo -e "1. Buka file config: ${YELLOW}nano /etc/pterodactyl${NODE_SUFFIX}/config.yml${NC}"
  echo -e "2. Tempel token, uuid, token_id asli dari panel lu (timpa semua)."
  echo -e "3. Jalankan nodenya: ${GREEN}sudo systemctl start wings${NODE_SUFFIX}${NC}"
  echo -e "====================================================="
  read -p "Tekan Enter untuk kembali ke menu utama..."
}

hackback_panel() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    HACK BACK PANEL                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  read -p "Masukkan Username Panel: " user
  read -p "password login " psswdhb
  
  cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; exit 1; }

  php artisan p:user:make <<EOF
yes
hackback@gmail.com
$user
$user
$user
$psswdhb
EOF
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 AKUN TELAH DI ADD             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  exit 0
}

ubahpw_vps() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                    UBAH PASSWORD VPS       [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  read -p "Masukkan Pw Baru: " pw
  read -p "Masukkan Ulang Pw Baru " pw

  passwd <<EOF
$pw
$pw
EOF

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 GANTI PW VPS SUKSES         [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  exit 0
}

# FUNGSI CETAK LOGO LAMA & LIVE STATUS NEOFETCH YANG SUPER RAPI
show_legacy_neofetch() {
  # Ambil data sistem asli dinamis
  local os_info=$(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2 || echo "Linux")
  local host_info=$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || echo "KVM/QEMU VPS Server")
  local kernel_info=$(uname -r)
  local uptime_info=$(uptime -p | sed 's/up //')
  local packages_count=$(dpkg-query -f '${binary:Package}\n' -W 2>/dev/null | wc -l || echo "0")
  local shell_info="bash $(echo $BASH_VERSION | cut -d'(' -f1)"
  local cpu_info=$(lscpu | grep 'Model name' | cut -d':' -f2 | sed -e 's/^[ \t]*//' | head -n1 || echo "Unknown CPU")
  
  local mem_used=$(free -m | awk '/Mem:/ {print $3}')
  local mem_total=$(free -m | awk '/Mem:/ {print $2}')
  local disk_used=$(df -h / | awk 'NR==2 {print $3}')
  local disk_total=$(df -h / | awk 'NR==2 {print $2}')

  # 1. Cetak Logo Lama (Tengkorak Kotak) Utuh Bersih
  echo -e "${RED}        _,gggggggggg.                                     ${NC}"
  echo -e "${RED}    ,ggggggggggggggggg.                                   ${NC}"
  echo -e "${RED}  ,ggggg        gggggggg.                                 ${NC}"
  echo -e "${RED} ,ggg'               'ggg.                                ${NC}"
  echo -e "${RED}',gg       ,ggg.      'ggg:                               ${NC}"
  echo -e "${RED}'ggg      ,gg'''  .    ggg                                ${NC}"
  echo -e "${RED}gggg      gg     ,     ggg                                ${NC}"
  echo -e "${WHITE}ggg:     gg.     -   ,ggg                                 ${NC}"
  echo -e "${WHITE} ggg:     ggg._    _,ggg                                  ${NC}"
  echo -e "${WHITE} ggg.    '.'''ggggggp                                     ${NC}"
  echo -e "${WHITE}  'ggg    '-.__                                           ${NC}"
  echo -e "${WHITE}    ggg                                                   ${NC}"
  echo -e "${WHITE}      ggg                                                 ${NC}"
  echo -e "${WHITE}        ggg.                                              ${NC}"
  echo -e "${WHITE}          ggg.                                            ${NC}"
  echo -e "${WHITE}             b.                                           ${NC}"

  # 2. Ambil Posisi Baris Sekarang
  local current_row=$(tput cups)
  local start_row=$(($(tput lines) - $(echo "$current_row" | awk -F';' '{print $1}') - 17))
  
  # Cari posisi baris awal logo dicetak
  local r=$(tput lines)
  # Gunakan trik tput untuk menimpa area teks kanan secara presisi tanpa merusak logo kiri
  tput cup $((r-17)) 50; echo -e "${RED}root${NC}@${RED}Axata${NC}"
  tput cup $((r-16)) 50; echo -e "--------"
  tput cup $((r-15)) 50; echo -e "${GREEN}OS:${NC} $os_info"
  tput cup $((r-14)) 50; echo -e "${GREEN}Host:${NC} $host_info"
  tput cup $((r-13)) 50; echo -e "${GREEN}Kernel:${NC} $kernel_info"
  tput cup $((r-12)) 50; echo -e "${GREEN}Uptime:${NC} $uptime_info"
  tput cup $((r-11)) 50; echo -e "${GREEN}Packages:${NC} $packages_count (dpkg)"
  tput cup $((r-10)) 50; echo -e "${GREEN}Shell:${NC} $shell_info"
  tput cup $((r-9))  50; echo -e "${GREEN}CPU:${NC} $cpu_info"
  tput cup $((r-8))  50; echo -e "${GREEN}Memory:${NC} ${mem_used}MiB / ${mem_total}MiB"
  tput cup $((r-7))  50; echo -e "${GREEN}Disk Space:${NC} ${disk_used} / ${disk_total}"
  tput cup $((r-5))  50; echo -e "${WHITE}Color Palette:${NC}"
  tput cup $((r-4))  50; echo -e "\033[40m   \033[41m   \033[42m   \033[43m   \033[44m   \033[45m   \033[46m   \033[47m   \033[0m"
  
  # Kembalikan posisi kursor ke bawah logo
  tput cup $((r-1)) 0
}

# Cek Root di awal script
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Harap jalankan script ini sebagai root (sudo su)${NC}"
  exit 1
fi

# Main script
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e ""
  
  while true; do
  # Panggil fungsi banner pelangi yang baru dibuat
  show_banner

  echo -e "${BLUE}[+] ======================================================= [+]${NC}"
  echo -e "${YELLOW}           Auto Installer Zelix Private - Menu System        ${NC}"
  echo -e "${BLUE}[+] ======================================================= [+]${NC}"
  echo -e "${CYAN}BERIKUT LIST INSTALL :${NC}"
  echo -e "  ${GREEN}1.${NC} Install Thema"
  echo -e "  ${GREEN}2.${NC} Configure Wings"
  echo -e "  ${GREEN}3.${NC} Create Node"
  echo -e "  ${GREEN}4.${NC} Hack Back Panel"
  echo -e "  ${GREEN}5.${NC} Setup Multi Nodes"
  echo -e "  ${GREEN}6.${NC} Ubah Pw Vps"
  echo -e "  ${RED}x.${NC} Exit"
  echo -e "${BLUE}-----------------------------------------------------------${NC}"
  echo -ne "${YELLOW}Masukkan pilihan: ${NC}"
  read -r PILIH
  
  case "$MENU_CHOICE" in
    1)
      install_multi_theme_menu
      ;;
    2)
      configure_wings
      ;;
    3)
      create_node
      ;;
    4)
      hackback_panel
      ;;
    5)
      setup_multi_nodes
      ;;
    6)
      ubahpw_vps
      ;;
    x)
      echo "Keluar dari skrip."
      exit 0
      ;;
    *)
      echo "Pilihan tidak valid, silahkan coba lagi."
      sleep 2
      ;;
  esac
done
