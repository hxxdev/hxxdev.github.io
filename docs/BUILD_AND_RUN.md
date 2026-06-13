# Build and local server guide

## Install dependencies

Run once from the repository root:

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

This installs Ruby gems locally under `vendor/bundle/` instead of requiring system-wide Ruby permissions.

## Build the static site

```bash
bundle exec jekyll build --trace
```

The generated site is written to:

```text
_site/
```

## Run a local development server

```bash
bundle exec jekyll serve -l -H localhost
```

Open:

```text
http://localhost:4000
```

## Run with drafts

```bash
bundle exec jekyll serve -l -H localhost --drafts
```

Draft files live in:

```text
_drafts/
```

## Common troubleshooting

### Permission error while installing gems

If Bundler tries to write to `/usr/lib/ruby/...`, run:

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

### Config changes do not appear

Jekyll does not always reload `_config.yml` changes during `jekyll serve`. Stop the server and restart it.

### PlantUML diagrams

PlantUML support is kept through `jekyll-plantuml` and `_plugins/plantuml-plugin.rb`.

If diagram generation fails, check that Java and PlantUML-related dependencies are installed on the machine running the build.
