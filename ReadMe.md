# ServerStructure

This repo contains all configs for recreating my server structure.

**Hosted services:**

    - Nginx (for routing)
    - Certbot (for SSL certificates)
    - Cloudflare DDNS (for updating DNS records with current ip)
    - Nextcloud
    - Cron (Cron for Nextcloud)
    - PostgreSQL (DB for Nextcloud)

*More services will be added over time.*

Nginx is configured to only allow connection using https (port 443 + ssl) and come from the correct hostname. For example, nextcloud is only accessible from `https://nextcloud.example.com`. This can be reconfigured to your liking. See `Config/nginx/nginx.conf`.

## Setup

The setup requires a `.env` file, containing various variables used by Docker-Compose and makefile. Therefore, create a file named `.env` containing the following variables:

```
WorkDir=./Containers
BaseDomain=example.com

NginxConfig=./Configs/nginx

NextCloudDir=${WorkDir}/nextcloud
NextCloudDBDir=${WorkDir}/nextclouddb
NextCloudDBPW=StrongAndSecurePassword!

CloudflareAPIToken=123UseYourOwnApiToken321
CloudflareDomains=nextcloud.${BaseDomain},youCanAddMore.${BaseDomain}

CertbotEmail=myemail@example.com
CertbotDir=${WorkDir}/certbot
CertbotIni=${CertbotDir}/cloudflare.ini
```

*Provide your own information accordingly.*

Next, run `sudo make`. This will create the CertbotIni file (this part requires sudo, depending on your location) and run docker compose.

If you don't trust the process, you can create the CerbotInit file manually and then run docker compose. Details can be found within the makefile.

The makefile provides additional commands (for example `clean` for cleanup).