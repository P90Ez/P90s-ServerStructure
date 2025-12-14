include .env
export

test-setup: build-containers

production: build-containers remove-certbotini remove-env
# additionally removes files containing credentials!

build-containers: create-certbotini
	docker compose -f Docker-Compose.yaml up -d

clean: remove-certbotini
	docker compose -f Docker-Compose.yaml down -v

# fullclean: clean remove-data remove-env

create-certbotini:
	mkdir -p $(CertbotDir)
	@echo "dns_cloudflare_api_token = $(CloudflareAPIToken)" > $(CertbotIni)

remove-certbotini:
	rm $(CertbotIni) -f

remove-env:
	rm ./.env -f

#remove-data:
#	rm $(WorkDir) -f

monitor:
	sh -c "while true; do clear && docker ps -a && sleep 2s; done"