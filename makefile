include .env
export

test-setup: build-containers install-cf-ip-cron

production: build-containers install-cf-ip-cron remove-certbotini remove-env
# additionally removes files containing credentials!

build-containers: create-certbotini
	docker compose -f Docker-Compose.yaml up -d

clean: remove-cf-ip-cron remove-certbotini
	docker compose -f Docker-Compose.yaml down -v

# fullclean: clean remove-data remove-env

create-certbotini:
	mkdir -p $(CertbotDir)
	chown root:root $(CertbotDir)
	chmod 700 $(CertbotDir)
	touch $(CertbotIni)
	chown root:root $(CertbotIni)
	chmod 600 $(CertbotIni)
	@echo "dns_cloudflare_api_token = $(CloudflareAPIToken)" > $(CertbotIni)

remove-certbotini:
	rm $(CertbotIni) -f

install-cf-ip-cron:
	$(MAKE) -f UpdateCloudflareIPs_Make run-once
	$(MAKE) -f UpdateCloudflareIPs_Make install

remove-cf-ip-cron:
	$(MAKE) -f UpdateCloudflareIPs_Make remove

remove-env:
	rm ./.env -f

#remove-data:
#	rm $(WorkDir) -f

monitor:
	sh -c "while true; do clear && docker ps -a && sleep 2s; done"