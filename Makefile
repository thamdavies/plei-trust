lint:
	bundle exec rubocop $(ARGS)
	yarn lint

watch:
	foreman start -f Procfile.dev

dev:
	rm -rf tmp/pids/server.pid || true
	bin/rails server -p 2325 -b '0.0.0.0'

db:
	docker compose up -d

test:
	bundle exec rspec

db-reset:
	docker stop $(docker ps -aq)
	docker rm $(docker ps -aq)
	docker compose down -v
	docker compose up -d
	rm -rf db/schema.rb
	bin/rails db:create db:migrate db:seed

deploy:
	bundle exec cap production deploy
