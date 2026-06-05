#!/bin/bash

# Definisi Warna ANSI
NC='\033[0m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
CYAN='\033[0;36m'
LIGHT_BLUE='\033[1;34m'
BOLD='\033[1m'

R1='\033[1;31m' # Merah
R2='\033[1;33m' # Kuning
R3='\033[1;32m' # Hijau
R4='\033[1;36m' # Cyan
R5='\033[1;35m' # Magenta
R6='\033[1;34m' # Biru

PANEL_DIR="/var/www/pterodactyl"
BACKUP_DIR="/var/www/pterodactyl_backup_$(date +%F_%H-%M)"

show_banner() {
  clear
  
  local b_uptime=$(cat /proc/uptime | awk '{print int($1)}')
  local days=$((b_uptime / 86400))
  local hours=$(( (b_uptime % 86400) / 3600 ))
  local mins=$(( (b_uptime % 3600) / 60 ))
  
  local uptime_vps=""
  if [ $days -gt 0 ]; then uptime_vps+="${days} Hari "; fi
  if [ $hours -gt 0 ] || [ $days -gt 0 ]; then uptime_vps+="${hours} Jam "; fi
  uptime_vps+="${mins} Menit"

  local ip_vps=$(hostname -I | awk '{print $1}')
  local cpu_model=$(lscpu | grep 'Model name' | cut -f2 -d: | sed -e 's/^[ \t]*//' | awk '{print $1,$2,$3}')
  [ -z "$cpu_model" ] && cpu_model=$(lscpu | grep 'Vendor ID' | cut -f2 -d: | sed -e 's/^[ \t]*//')
  
  local cpu_cores=$(nproc)
  local ram_used=$(free -h | awk '/Mem:/ {print $3}')
  local ram_total=$(free -h | awk '/Mem:/ {print $2}')
  local disk_usage=$(df -h / | awk 'NR==2 {print $5}')
  local disk_total=$(df -h / | awk 'NR==2 {print $2}')

  echo -e "${RED}        _,gggggggggg.${NC}"
  echo -e "${RED}    ,ggggggggggggggggg.${NC}"
  echo -e "${RED}  ,ggggg        gggggggg.${NC}"
  echo -e "${RED} ,ggg'               'ggg.${NC}"
  echo -e "${RED}',gg       ,ggg.      'ggg:${NC}"
  echo -e "${RED}'ggg      ,gg'''  .    ggg${NC}"
  echo -e "${WHITE}gggg      gg     ,     ggg${NC}"
  echo -e "${WHITE}ggg:     gg.     -   ,ggg${NC}"
  echo -e "${WHITE} ggg:     ggg._    _,ggg${NC}"
  echo -e "${WHITE} ggg.    '.'''ggggggp${NC}"
  echo -e "${WHITE}  'ggg    '-.__${NC}"
  echo -e "${WHITE}    ggg${NC}"
  echo -e "${WHITE}      ggg${NC}"
  
  echo -e "${R1}┌ 𝚄𝙿𝚃𝙸𝙼𝙴 𝚅𝙿𝚂  : ${uptime_vps}${NC}"
  echo -e "${R2}├ 𝙸𝙿 𝚅𝙿𝚂      : ${ip_vps}${NC}"
  echo -e "${R3}├ 𝙲𝙿𝚄         : ${cpu_model}${NC}"
  echo -e "${R4}├ 𝙲𝙾𝚁𝙴        : ${cpu_cores} Core(s)${NC}"
  echo -e "${R5}├ 𝚁𝙰𝙼         : ${ram_used} / ${ram_total}${NC}"
  echo -e "${R6}└ 𝙳𝙸𝚂𝙺        : ${disk_usage} / ${disk_total}${NC}"
  echo -e ""
  
  echo -e "${LIGHT_BLUE}𝚃𝚎𝚛𝚒𝚖𝚊𝚔𝚊𝚜𝚒𝚑 𝚃𝚎𝚕𝚊𝚑 𝙼𝚎𝚖𝚊𝚔𝚊𝚒 𝙱𝚊𝚜𝚑 𝙸𝚗𝚒. 
  𝚂𝚞𝚙𝚙𝚘𝚛𝚝 𝚃𝚎𝚛𝚞𝚜 @lixzhosting${NC}"
  echo -e ""
}

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                       [+]${NC}"
  echo -e "${WHITE}[+]                AUTO INSTALLER THEMA              [+]${NC}"
  echo -e "${WHITE}[+]                    © ZelixBotzSetup                   [+]${NC}"
  echo -e "${BLUE}[+]                                                       [+]${NC}"
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

#Update and install jq & mysql-client
install_jq() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]          UPDATE & INSTALL DEPENDENCIES          [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq mysql-client
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]           INSTALL DEPENDENCIES BERHASIL         [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
    echo -e "${RED}[+] =============================================== [+]${NC}"
    echo -e "${RED}[+]           INSTALL DEPENDENCIES GAGAL           [+]${NC}"
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

# FUNGSI UNINSTALL/RESET THEME KE ORIGINAL
uninstall_theme() {
  echo " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]       RESET PANEL (UNINSTALL THEME/TOOLS)       [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo " "
  while true; do
    echo -n -e "${BOLD}Apakah Anda benar-benar yakin ingin melanjutkan? (y/n): ${NC}"
    read yn
    case $yn in
      [Yy]*)
        set -e
        if [ ! -d "/var/www/pterodactyl" ]; then
          echo -e "${RED}[X] Error: Direktori Pterodactyl tidak ditemukan.${NC}"
          return 1
        fi
        cd /var/www/pterodactyl || { echo -e "${RED}[X] Error: Gagal masuk ke direktori Pterodactyl.${NC}"; return 1; }
        echo -e "${YELLOW}[*] ⚙️ Memulai proses reset panel...${NC}"
        echo -e "${BOLD} - Mem-backup file .env...${NC}"
        TEMP_BACKUP=$(mktemp -d)
        if [ -f ".env" ]; then sudo mv .env "$TEMP_BACKUP/"; fi
        echo -e "${BOLD} - Menghapus semua file panel lama...${NC}"
        sudo find . -mindepth 1 -delete
        echo -e "${BOLD} - Mengunduh panel original terbaru...${NC}"
        curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | sudo tar -xzf - -C /var/www/pterodactyl
        echo -e "${BOLD} - Mengembalikan file .env...${NC}"
        if [ -f "$TEMP_BACKUP/.env" ]; then sudo mv "$TEMP_BACKUP"/.env .; fi
        rm -rf "$TEMP_BACKUP"
        echo -e "${BOLD} - Install ulang dependensi (Composer)...${NC}"
        PHP_CLI_VERSION=$(php -v | head -n 1 | awk '{print $2}' | cut -d. -f1,2)
        PHP_WEB_VERSION=$(systemctl list-units --type=service | grep -oP 'php[0-9\.]+-fpm' | grep -oP '[0-9\.]+' | head -n 1)
        if [ -z "$PHP_WEB_VERSION" ]; then PHP_WEB_VERSION=$PHP_CLI_VERSION; fi
        sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get install -y \
          ca-certificates curl gnupg zip unzip git wget redis-server \
          php${PHP_CLI_VERSION}-common php${PHP_CLI_VERSION}-cli php${PHP_CLI_VERSION}-gd \
          php${PHP_CLI_VERSION}-mbstring php${PHP_CLI_VERSION}-bcmath php${PHP_CLI_VERSION}-xml \
          php${PHP_CLI_VERSION}-curl php${PHP_CLI_VERSION}-zip php${PHP_CLI_VERSION}-intl \
          php${PHP_CLI_VERSION}-sqlite3 php${PHP_CLI_VERSION}-mysql php${PHP_CLI_VERSION}-fpm php${PHP_CLI_VERSION}-redis \
          php${PHP_WEB_VERSION}-common php${PHP_WEB_VERSION}-cli php${PHP_WEB_VERSION}-gd \
          php${PHP_WEB_VERSION}-mbstring php${PHP_WEB_VERSION}-bcmath php${PHP_WEB_VERSION}-xml \
          php${PHP_WEB_VERSION}-curl php${PHP_WEB_VERSION}-zip php${PHP_WEB_VERSION}-intl \
          php${PHP_WEB_VERSION}-sqlite3 php${PHP_WEB_VERSION}-mysql php${PHP_WEB_VERSION}-fpm php${PHP_WEB_VERSION}-redis
        sudo phpenmod -v ${PHP_CLI_VERSION} redis || true
        sudo phpenmod -v ${PHP_WEB_VERSION} redis || true
        sudo systemctl enable redis-server || true
        sudo systemctl start redis-server || true
        sudo chmod -R 755 storage/* bootstrap/cache/
        sudo chown -R www-data:www-data /var/www/pterodactyl
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
        sudo rm -rf /var/www/.cache
        sudo mkdir -p /var/www/.cache
        sudo chown -R www-data:www-data /var/www/.cache
        sudo -u www-data env COMPOSER_PROCESS_TIMEOUT=2000 composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist
        echo -e "${BOLD} - Menjalankan migrasi...${NC}"
        sudo -u www-data php artisan migrate --seed --force
        echo -e "${BOLD} - Membersihkan cache sistem...${NC}"
        sudo -u www-data php artisan optimize:clear
        sudo -u www-data php artisan view:clear
        sudo -u www-data php artisan config:clear
        sudo -u www-data php artisan route:clear
        sudo -u www-data php artisan cache:clear
        sudo rm -f /usr/local/bin/blueprint
        if systemctl list-unit-files | grep -q "agent.service"; then
          echo -e "${BOLD} - Membersihkan Reviactyl Agent & Mengembalikan Wings...${NC}"
          sudo systemctl stop agent >/dev/null 2>&1 || true
          sudo systemctl disable agent >/dev/null 2>&1 || true
          sudo rm -f /etc/systemd/system/agent.service
          sudo rm -f /usr/local/bin/agent
          sudo rm -rf /etc/reviactyl
          sudo systemctl daemon-reload
        fi
        if systemctl list-unit-files | grep -q "wings.service"; then
          sudo systemctl enable --now wings >/dev/null 2>&1 || true
        fi
        echo -e "${BOLD} - Restart layanan webserver & worker...${NC}"
        sudo systemctl restart nginx || sudo systemctl restart apache2
        PHP_SERVICES=$(systemctl list-unit-files | grep -oE "php[0-9\.]+-fpm\.service" | tr "\n" " ")
        if [ ! -z "$PHP_SERVICES" ]; then
          sudo systemctl restart $PHP_SERVICES || true
        fi
        sudo systemctl restart pteroq
        sudo -u www-data php artisan up
        break
        ;;
      [Nn]*)
        echo -e "\n${BOLD}${RED}❌ Operasi dibatalkan oleh pengguna.${NC}"
        return
        ;;
      *)
        echo -e "\n${BOLD}${YELLOW}Pilihan tidak valid! Silahkan pilih (y) atau (n).${NC}"
        ;;
    esac
  done
  echo " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]             PANEL BERHASIL DI-RESET             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo " "
  sleep 3
  return 0
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
  echo -e " 11. ${RED}Uninstall/Reset Theme${NC} (Hapus Tema Balik Polos)"
  echo -e " ${RED}x. Kembali ke Menu Utama${NC}"
  echo -e " ------------------------------------------------------------"
  read -p " Pilih menu (1-11/x): " THEME_CHOICE

  if [ "$THEME_CHOICE" == "x" ]; then
      return
  fi

  # Eksekusi install dependencies dasar (Kecuali jika milih reset theme)
  if [ "$THEME_CHOICE" != "11" ]; then
      install_dependencies
  fi

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
    11)
      uninstall_theme
      sleep 3
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid!${NC}"
      sleep 2
      ;;
  esac

  # Cek Nginx Config Default (Skip jika memilih uninstall theme)
  if [ "$THEME_CHOICE" != "11" ] && [ ! -f "/etc/nginx/sites-available/pterodactyl.conf" ]; then
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
}

setup_multi_nodes() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]          SETUP MULTI NODES (AUTO SPEK VPS)      [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  echo -e "${YELLOW}[*] Mendeteksi spek asli VPS lu...${NC}"
  local VPS_RAM_MB=$(free -m | awk '/Mem:/ {print $2}')
  local VPS_DISK_KB=$(df / | awk 'NR==2 {print $2}')
  local VPS_DISK_MB=$((VPS_DISK_KB / 1024))

  echo -e "${GREEN}[✓] Terdeteksi RAM  : ${VPS_RAM_MB} MB${NC}"
  echo -e "${GREEN}[✓] Terdeteksi DISK : ${VPS_DISK_MB} MB${NC}"
  echo -e "-----------------------------------------------------"

  read -p "DOMAIN PANEL : " PANEL_URL
  read -p "PTLA : " API_KEY
  read -p "ID LOKASI (default 1): " LOCID
  read -p "NAME NODES : " NODE_NAME
  echo -e "-----------------------------------------------------"
  read -p "DOMAIN NODES : " NODE_DOMAIN
  read -p "DAEMON PORT (default 8080) : " DAEMON_PORT
  read -p "SFTP PORT (default 2022) : " SFTP_PORT

  if [ -z "$PANEL_URL" ] || [ -z "$API_KEY" ] || [ -z "$LOCID" ] || [ -z "$NODE_NAME" ] || [ -z "$NODE_DOMAIN" ] || [ -z "$DAEMON_PORT" ] || [ -z "$SFTP_PORT" ]; then
    echo -e "${RED}[X] Error: Data tidak boleh ada yang kosong!${NC}"
    sleep 3
    return
  fi

  NODE_SUFFIX="${DAEMON_PORT}"

  echo -e "\n${YELLOW}[*] Memvalidasi DNS Domain... Mohon tunggu.${NC}"
  sleep 1
  if ! ping -c 1 "$NODE_DOMAIN" &> /dev/null; then
    echo -e "${RED}[X] Domain $NODE_DOMAIN Belum diarahkan ke IP VPS ini!${NC}"
    read -p "Tekan Enter untuk kembali..."
    return
  fi

  echo -e "\n${GREEN}[*] Membuka Firewall & Request SSL Let's Encrypt...${NC}"
  if command -v ufw &> /dev/null; then
    sudo ufw allow $DAEMON_PORT/tcp
    sudo ufw allow $SFTP_PORT/tcp
    sudo ufw reload
  fi
  sudo systemctl stop nginx
  sudo certbot certonly --standalone -d "$NODE_DOMAIN" --non-interactive --agree-tos --register-unsafely-without-email
  sudo systemctl start nginx

  if [ ! -f "/etc/letsencrypt/live/$NODE_DOMAIN/fullchain.pem" ]; then
    echo -e "${RED}[X] SSL Gagal dibuat! Proses dihentikan.${NC}"
    sleep 3
    return
  fi

  echo -e "\n${YELLOW}[*] Create nodes panel mohon tunggu...${NC}"
  PANEL_URL="${PANEL_URL%/}"

  RESPONSE=$(curl -s -X POST "${PANEL_URL}/api/application/nodes" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d "{
      \"name\": \"${NODE_NAME}\",
      \"location_id\": ${LOCID},
      \"fqdn\": \"${NODE_DOMAIN}\",
      \"scheme\": \"https\",
      \"behind_proxy\": false,
      \"maintenance_mode\": false,
      \"memory\": ${VPS_RAM_MB},
      \"memory_overallocate\": 0,
      \"disk\": ${VPS_DISK_MB},
      \"disk_overallocate\": 0,
      \"upload_size\": 100,
      \"daemon_listen\": ${DAEMON_PORT},
      \"daemon_sftp\": ${SFTP_PORT}
    }")

  NODE_ID=$(echo "$RESPONSE" | jq -r '.attributes.id // empty')

  if [ -z "$NODE_ID" ]; then
    echo -e "${RED}[X] Gagal membuat Node di panel via API!${NC}"
    echo -e "${RED}Response Error: $RESPONSE${NC}"
    read -p "Tekan Enter untuk kembali..."
    return
  fi

  echo -e "${GREEN}[✓] Node Berhasil dibuat di Panel dengan ID: $NODE_ID${NC}"

  echo -e "${YELLOW}[*] Menarik data Token, UUID, dan Configuration dari panel...${NC}"
  WINGS_CONFIG=$(curl -s -X GET "${PANEL_URL}/api/application/nodes/${NODE_ID}/configuration" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Accept: application/json")

  UUID=$(echo "$WINGS_CONFIG" | jq -r '.uuid')
  TOKEN_ID=$(echo "$WINGS_CONFIG" | jq -r '.token_id')
  TOKEN=$(echo "$WINGS_CONFIG" | jq -r '.token')

  if [ -z "$UUID" ] || [ "$UUID" == "null" ]; then
    echo -e "${RED}[X] Gagal menarik token configuration dari panel!${NC}"
    read -p "Tekan Enter untuk kembali..."
    return
  fi

  echo -e "\n${GREEN}[*] Menulis file config.yml secara otomatis...${NC}"
  sudo mkdir -p /etc/pterodactyl${NODE_SUFFIX}
  sudo mkdir -p /var/lib/pterodactyl${NODE_SUFFIX}/volumes

  cat <<EOF > /etc/pterodactyl${NODE_SUFFIX}/config.yml
debug: false
uuid: ${UUID}
token_id: ${TOKEN_ID}
token: ${TOKEN}
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
remote: '${PANEL_URL}'
EOF

  echo -e "${GREEN}[*] Membuat Service Systemd wings${NODE_SUFFIX}...${NC}"
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

  sudo systemctl daemon-reload
  sudo systemctl enable wings${NODE_SUFFIX}
  sudo systemctl start wings${NODE_SUFFIX}

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]        AUTO SETUP MULTI NODE BERHASIL!          [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  read -p "Tekan Enter untuk kembali..."
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
  sleep 2
}

ubahpw_vps() {
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]./"
  echo -e "${GREEN}[+]                    UBAH PASSWORD VPS       [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  read -p "Masukkan Pw Baru: " pw

  passwd <<EOF
$pw
$pw
EOF

  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 GANTI PW VPS SUKSES         [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  sleep 2
}

clean_pterodactyl_system() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]          CLEAN SYSTEM & PTERODACTYL PANEL       [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  echo -e "${YELLOW}[1] MEMBERSIHKAN DOCKER & CONTAINER SAMPAH...${NC}"
  sudo docker rm $(sudo docker ps -a -q -f status=exited) 2>/dev/null
  sudo docker rmi $(sudo docker images -f "dangling=true" -q) 2>/dev/null
  sudo docker volume prune -f
  sudo docker builder prune -f
  echo -e "${GREEN}[✓] Docker System Cleaned!${NC}"
  echo -e "-----------------------------------------------------"

  echo -e "${YELLOW}[2] MEMBERSIHKAN USER TANPA SERVER DI PANEL...${NC}"
  if [ ! -d "$PANEL_DIR" ]; then
      echo -e "${RED}[X] Panel Pterodactyl tidak ditemukan di $PANEL_DIR. Skip bersihin user.${NC}"
  else
      cd "$PANEL_DIR" || return
      USER_WITH_SERVERS=$(php artisan tinker --execute="print_index(json_encode(DB::table('servers')->pluck('owner_id')->unique()->toArray()))" | grep -o '[0-9]\+')
      ALL_USERS=$(php artisan tinker --execute="print_index(json_encode(DB::table('users')->where('root_admin', 0)->pluck('id')->toArray()))" | grep -o '[0-9]\+')

      echo -e "${YELLOW}[*] Sedang menyeleksi user tanpa server...${NC}"
      count=0
      for user_id in $ALL_USERS; do
          if ! echo "$USER_WITH_SERVERS" | grep -q -w "$user_id"; then
              USER_EMAIL=$(php artisan tinker --execute="print_index(DB::table('users')->where('id', $user_id)->value('email'))" | tr -d '"')
              if [ ! -z "$USER_EMAIL" ] && [ "$USER_EMAIL" != "null" ]; then
                  echo -e "${RED}[-] Menghapus User: $USER_EMAIL (ID: $user_id)${NC}"
                  php artisan tinker --execute="DB::table('users')->where('id', $user_id)->delete();" > /dev/null
                  count=$((count+1))
              fi
          fi
      done
      [ $count -eq 0 ] && echo -e "${GREEN}[✓] Tidak ada user hantu!${NC}" || echo -e "${GREEN}[✓] Berhasil menghapus $count user hantu!${NC}"
      php artisan view:clear && php artisan cache:clear
  fi
  read -p "Tekan Enter untuk kembali..."
}

backup_panel_to_telegram() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]          BACKUP TO TELEGRAM BOT                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  if [ ! -d "$PANEL_DIR" ]; then
    echo -e "${RED}[X] Panel Pterodactyl tidak ditemukan!${NC}"
    sleep 3
    return
  fi

  read -p "Masukkan Token Bot Telegram : " TG_TOKEN
  read -p "Masukkan Chat ID Telegram Lu : " TG_CHAT_ID

  if [ -z "$TG_TOKEN" ] || [ -z "$TG_CHAT_ID" ]; then
    echo -e "${RED}[X] Error: Token & Chat ID tidak boleh kosong!${NC}"
    sleep 3
    return
  fi

  DB_DATABASE=$(grep DB_DATABASE "$PANEL_DIR/.env" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
  DB_USERNAME=$(grep DB_USERNAME "$PANEL_DIR/.env" | cut -d'=' -f2 | tr -d '"' | tr -d "'")
  DB_PASSWORD=$(grep DB_PASSWORD "$PANEL_DIR/.env" | cut -d'=' -f2 | tr -d '"' | tr -d "'")

  local DATE=$(date +%F_%H-%M)
  local BACKUP_NAME="PteroBackup_${DATE}"
  local TMP_BACKUP_DIR="/tmp/${BACKUP_NAME}"
  mkdir -p "$TMP_BACKUP_DIR"

  mysqldump -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" > "${TMP_BACKUP_DIR}/panel_database.sql" 2>/dev/null
  cp "$PANEL_DIR/.env" "$TMP_BACKUP_DIR/"
  cd /tmp && zip -r "${BACKUP_NAME}.zip" "$BACKUP_NAME" > /dev/null

  local CAPTION="🚀 *NEW PTERODACTYL BACKUP SUCCESSED*\n\n📅 *Tanggal:* \`${DATE}\`\n🖥️ *IP VPS:* \`$(hostname -I | awk '{print $1}')\`\n"
  RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendDocument" -F "chat_id=${TG_CHAT_ID}" -F "document=@/tmp/${BACKUP_NAME}.zip" -F "caption=${CAPTION}" -F "parse_mode=Markdown")
  
  rm -rf "/tmp/${BACKUP_NAME}" "/tmp/${BACKUP_NAME}.zip"
  [ "$(echo "$RESPONSE" | jq -r '.ok')" = "true" ] && echo -e "${GREEN}[✓] Backup Sukses terkirim ke Telegram!${NC}" || echo -e "${RED}[X] Gagal kirim ke Telegram!${NC}"
  read -p "Tekan Enter untuk kembali..."
}

auto_clean_disk_85() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]           AUTO CLEAN DISK SYSTEM (THRES 85%)    [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "

  local CURRENT_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
  echo -e "${YELLOW}[*] Status Penggunaan Disk Saat Ini: ${CURRENT_USAGE}%${NC}"
  
  if [ "$CURRENT_USAGE" -lt 85 ]; then
    echo -e "${GREEN}[✓] Disk masih aman (Di bawah 85%). Tidak perlu eksekusi paksa!${NC}"
  else
    echo -e "${RED}[!] WARNING! Disk sudah kritis (${CURRENT_USAGE}%), Memulai Pembersihan Total...${NC}"
    echo -e "-----------------------------------------------------"
    echo -e "${YELLOW}[*] 1. Mengosongkan cache Package Manager (APT)...${NC}"
    sudo apt-get clean -y
    sudo apt-get autoremove -y
    echo -e "${YELLOW}[*] 2. Memotong ukuran Log Linux (Systemd Journal) sisa 50MB...${NC}"
    sudo journalctl --vacuum-size=50M
    echo -e "${YELLOW}[*] 3. Membersihkan file sementara di folder /tmp...${NC}"
    sudo rm -rf /tmp/* 2>/dev/null
    echo -e "${YELLOW}[*] 4. Deep Clean Docker Engine & Volumes hantu...${NC}"
    sudo docker system prune -a -f --volumes
    echo -e "${YELLOW}[*] 5. Mengecilkan file log bengkak milik Pterodactyl...${NC}"
    if [ -d "$PANEL_DIR" ]; then
        [ -f "$PANEL_DIR/storage/logs/laravel.log" ] && cat /dev/null > "$PANEL_DIR/storage/logs/laravel.log"
    fi
    [ -f "/var/log/nginx/error.log" ] && cat /dev/null > /var/log/nginx/error.log
    [ -f "/var/log/nginx/access.log" ] && cat /dev/null > /var/log/nginx/access.log

    local AFTER_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo -e "-----------------------------------------------------"
    echo -e "${GREEN}[✓] BERSIH-BERSIH SELESAI!${NC}"
    echo -e " Hasil Akhir Penggunaan Disk: ${YELLOW}${AFTER_USAGE}%${NC} (Sebelumnya: ${RED}${CURRENT_USAGE}%${NC})"
  fi
  read -p "Tekan Enter untuk kembali ke menu utama..."
}

uninstall_panel() {
  echo " "
  echo -e "${BOLD}${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BOLD}${BLUE}[+]                  UNINSTALL PANEL                [+]${NC}"
  echo -e "${BOLD}${BLUE}[+] =============================================== [+]${NC}"
  echo " "
  echo -n -e "${BOLD}Apakah Anda yakin ingin melanjutkan? (y/n): ${NC}"
  read confirmation
  if [[ "$confirmation" != [yY] ]]; then echo -e "${BOLD}${RED}Uninstall dibatalkan.${NC}"; return; fi

  echo -e "${YELLOW}[*] Memulai proses uninstall...${NC}"

  if [ -f "/var/www/pterodactyl/.env" ]; then
      echo -e "${YELLOW}[*] Mencoba menghapus database panel...${NC}"
      DB_NAME=$(grep "^DB_DATABASE=" /var/www/pterodactyl/.env | cut -d'=' -f2)
      DB_USER=$(grep "^DB_USERNAME=" /var/www/pterodactyl/.env | cut -d'=' -f2)
      DB_PASS=$(grep "^DB_PASSWORD=" /var/www/pterodactyl/.env | cut -d'=' -f2)
      mysql -u root -e "DROP DATABASE IF EXISTS $DB_NAME; DROP USER IF EXISTS '$DB_USER'@'127.0.0.1';" > /dev/null 2>&1 || true
      echo -e "${GREEN}[✓] Database cleaning selesai.${NC}"
  else
      echo -e "${YELLOW}[!] File .env tidak ditemukan, melewati penghapusan database otomatis.${NC}"
  fi

  echo -e "${YELLOW}[*] Menghentikan layanan pterodactyl...${NC}"
  systemctl disable --now wings pteroq > /dev/null 2>&1 || true
  systemctl disable --now redis-server > /dev/null 2>&1 || true
  systemctl disable --now redis > /dev/null 2>&1 || true
  PHP_SERVICES=$(systemctl list-unit-files | grep -oE "php[0-9\.]+-fpm\.service" | tr "\n" " ")
  if [ ! -z "$PHP_SERVICES" ]; then
      systemctl disable --now $PHP_SERVICES > /dev/null 2>&1 || true
  fi
  systemctl stop nginx apache2 > /dev/null 2>&1 || true

  echo -e "${YELLOW}[*] Membersihkan Cronjob...${NC}"
  (crontab -l 2>/dev/null | grep -v "pterodactyl" | crontab -) || true

  echo -e "${YELLOW}[*] Menghapus file sistem Pterodactyl...${NC}"
  rm -rf /var/www/pterodactyl
  rm -rf /etc/pterodactyl
  rm -rf /var/lib/pterodactyl
  rm -f /usr/local/bin/wings
  rm -f /usr/local/bin/composer
  rm -f /usr/local/bin/blueprint

  echo -e "${YELLOW}[*] Menghapus konfigurasi service...${NC}"
  rm -f /etc/systemd/system/wings.service
  rm -f /etc/systemd/system/pteroq.service
  systemctl daemon-reload

  echo -e "${YELLOW}[*] Menghapus konfigurasi webserver...${NC}"
  rm -f /etc/nginx/sites-enabled/pterodactyl.conf
  rm -f /etc/nginx/sites-available/pterodactyl.conf
  rm -f /etc/nginx/conf.d/pterodactyl.conf
  rm -f /etc/apache2/sites-enabled/pterodactyl.conf
  rm -f /etc/apache2/sites-available/pterodactyl.conf
  rm -f /etc/php/*/fpm/pool.d/www-pterodactyl.conf
  rm -f /etc/php-fpm.d/www-pterodactyl.conf
  if [ -f /etc/nginx/sites-available/default ] && [ ! -L /etc/nginx/sites-enabled/default ]; then
      ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default > /dev/null 2>&1 || true
  fi

  echo -e "${YELLOW}[*] Membersihkan sisa Docker...${NC}"
  docker rm -f $(docker ps -a -q) > /dev/null 2>&1 || true
  docker system prune -af > /dev/null 2>&1 || true 

  echo -e "${YELLOW}[*] Merestart layanan sistem...${NC}"
  systemctl restart nginx > /dev/null 2>&1 || true
  systemctl restart apache2 > /dev/null 2>&1 || true
  
  echo -e "                                                       "
  echo -e "${BOLD}${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${BOLD}${GREEN}[+]             UNINSTALL PANEL SUKSES              [+]${NC}"
  echo -e "${BOLD}${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 3
  return 0
}

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Harap jalankan script ini sebagai root (sudo su)${NC}"
  exit 1
fi

# Main script execution flow
display_welcome
install_jq
check_token

while true; do
  show_banner

  echo -e "${BLUE}[+] ======================================================= [+]${NC}"
  echo -e "${YELLOW}           Auto Installer Zelix Private - Menu System        ${NC}"
  echo -e "${BLUE}[+] ======================================================= [+]${NC}"
  echo -e "${CYAN}BERIKUT LIST INSTALLASI :${NC}"
  echo -e "  ${GREEN}1.${NC} Install Thema"
  echo -e "  ${GREEN}2.${NC} Configure Wings"
  echo -e "  ${GREEN}3.${NC} Create Node"
  echo -e "  ${GREEN}4.${NC} Hack Back Panel"
  echo -e "  ${GREEN}5.${NC} Setup Multi Nodes"
  echo -e "  ${GREEN}6.${NC} Ubah Pw Vps"
  echo -e "  ${GREEN}7.${NC} Clean System & Panel"
  echo -e "  ${GREEN}8.${NC} Backup Panel to Telegram"
  echo -e "  ${GREEN}9.${NC} Auto Clean Disk (>85%)"
  echo -e "  ${GREEN}10.${NC} Uninstall Panel Total"
  echo -e "  ${RED}x.${NC} Exit"
  echo -e "${BLUE}-----------------------------------------------------------${NC}"
  echo -ne "${YELLOW}Masukkan pilihan: ${NC}"
  read -r MENU_CHOICE
  clear

  case "$MENU_CHOICE" in
    1) install_multi_theme_menu ;;
    2) configure_wings ;;
    3) create_node ;;
    4) hackback_panel ;;
    5) setup_multi_nodes ;;
    6) ubahpw_vps ;;
    7) clean_pterodactyl_system ;;
    8) backup_panel_to_telegram ;;
    9) auto_clean_disk_85 ;;
    10) uninstall_panel ;;
    x|X) echo "Keluar dari skrip."; exit 0 ;;
    *) echo "Pilihan tidak valid, silahkan coba lagi."; sleep 2 ;;
  esac
done
