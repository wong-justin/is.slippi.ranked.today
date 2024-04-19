# Usage:
#   make dev PORT=<port>
#
# dependencies: none
build: index.html


# Note that inner 'make' within this makefile also has stdout hidden,
#   due to nearly insuppressible noisy logs
#   (make[1]: Entering directory ... Leaving directory...)
#   so inner errors should go to stderr in order not to be hidden
#
# dev dependencies: envsubst, nginx, entr, bws, minbrowser
.PHONY: dev
dev:
	@export PORT=$(PORT)
	@envsubst < /usr/share/nginx/nginx.conf.template > /tmp/$(PORT)nginx.conf
	@nginx -p $(PWD)/ -c /tmp/$(PORT)nginx.conf 1>/dev/null 2>/dev/null
	@cmd.exe /C min "http://localhost:$(PORT)/"
	@printf "Opening browser.\n"
	@printf "\nWatching for changes...\n"
	@find . | entr -c -s 'make 1> /dev/null; bws ping; echo pinged 1>&2' 1> /dev/null
