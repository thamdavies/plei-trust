# Plei Trust Web Portal
A web portal for Plei Trust
### Requirements
This project requires:
- Ruby 3.4.4
- Bundler 2.6.8
- Node v24.x
- PostgreSQL 17
- Docker 24.x

### Installation
1. Clone `git clone git@github.com:thamdavies/plei-trust.git`
2. Ask me for `development.key` and `test.key`
3. Run the following command to setup docker host
   ```bash
   grep -q "host.docker.internal" /etc/hosts || echo "127.0.0.1 host.docker.internal" | sudo tee -a /etc/hosts
   ```
4. Run `make db` to start our DB
5. Run `bundle install` to install ruby gems
6. Run `yarn install` to install nodejs packages
7. To create and migrate our DB, run: `bin/rails db:create db:migrate db:seed`
8. Run these commands to start our app in separate tabs:
   - `make dev` to run rails server
   - `make watch` to watch js and css file changes
9. Access our web portal at http://localhost:5000
10. Enjoy!

### Troubleshooting
