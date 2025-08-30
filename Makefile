lint:
	bundle exec rubocop $(ARGS)

watch:
	foreman start -f Procfile.dev

dev:
	bin/rails server

db:
  docker compose up -d
