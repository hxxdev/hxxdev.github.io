---
title: How to make your own Github Blog.
date: 2025-03-09
categories: [dev, git]
tags: [git]
---

This post explains how to setup your own [Github](https://github.com) blog.  
Let's get started!  

---------------------

## Make Github repository

Make your own [Github](https://github.com) repository.  
Make sure to name your repository as `<username>.github.io` and make it public.  
Then clone your repository into your local.  
`git clone <your_repository>`

---------------------

## Install Ruby

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv/
echo 'export RUBYOPT='-W0'' >> ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
rbenv install 2.7.0
rbenv global 2.7.0
exec $SHELL
```

---------------------

## Install Bundler and Jekyll using Gem

```bash
gem install jekyll
gem install bundler 
gem install webrick
gem install kramdown
gem install rouge
bundle update
bundle add webrick
```

---------------------

## Choose your theme

- Go to [Github](https://github.com/topics/jekyll-theme) and choose your preferred theme.

---------------------

## Install Chirpy

In this example we will use [Chirpy Theme](https://github.com/cotes2020/jekyll-theme-chirp).

```git
git clone git@github.com:cotes2020/jekyll-theme-chirpy.git
git add .
git commit -m "initial commit"
git fetch chirpy --tags
git tag
git merge vX.Y.Z --squash --allow-unrelated-histories
```

Then resolve all merge conflicts.

---------------------

## Basic configurations

Edit `./_config.yml` to your needs.  

```yml
url: <user_name>.github.io
baseurl: ""
avatar: /path/to/your/profile/image
```

---------------------

## Configure: Background color

Each can be configured in the following files:

- Background Colors(Light): `/_sass/themes/_light.scss`{: .filepath}
- Background Colors(Dark): `/_sass/themes/_dark.scss`{: .filepath}
- Fonts: `/_sass/abstracts/_variables.scss`{: .filepath}
- Code snippet: `/_sass/base/_syntax.scss`{: .filepath}

---------------------

## Configure: Code snippets

Since we have installed the necessary packages for our theme, let's play with syntax highlighting.

Now let's generate `css` for our syntax highlighting.  
In this example, we will generate github-style syntax.  

```bash
rougify style github > ./css/syntax.css
```

Then replace `/_sass/base/_syntax.scss` with the one we generated.

---------------------

## Configure: Favicons

Create your own [favicons](https://www.favicon-generator.org/about/) at [Favicons Generator](https://www.favicon-generator.org/).  
Then replace all `png` files in `/assets/img/favicons` with the one your generated.

---------------------

## Configure: jekyll plugins

Jekyll plugins can be very useful.  
We will learn how to add [Jekyll PlantUML](https://github.com/yegor256/jekyll-plantuml) here.  

- Install `PlantUML`.

```shell
sudo apt-get install plantuml -y
```

- Install jekyll-plantuml.

```shell
gem install jekyll-plantuml
```

- add gem to `_config.yml`

```
plugins:
  - jekyll-sitemap
  - jekyll-admin
  - jekyll-feed
  - jekyll-plantuml
```

- add `plantuml-plugin.rb` into `_plugins` directory.

```
# _plugins/plantuml-plugin.rb
require "jekyll-plantuml"
```

- add `jekyll-plantuml` to `Gemfile`.

```
gem "jekyll-plantuml"
```

- Update bundle.

```shell
bundle update
```
Check if any error occurs.

- You can draw diagrams in posts. The syntax:

```
Caution: Make sure to exclude `!`.
{!% plantuml %}
[First] - [Second]
{!% endplantuml %}
```

---------------------

## Google Search Console

Go to [**Google Search Console**](https://search.google.com/search-console/about).  
Generate your `goolexxxxxx.html` and place it in your Github repository.  
Generate your website `sitemap.xml` at [**XML-Sitemaps.com](https://xml-sitemaps.com).  
Place the generated `sitemap.xml` at your Github repository.  
Add/commit `sitemap.xml` and push.  

Navigate to <kbd>URL Check</kbd> and enter `https://your/website/url/sitemap.xml`.  
Validate your URL and click <kbd>Index creation request</kbd>. This might take a while.  
After, navigate to <kbd>Sitemaps</kbd> in Google Search Console and then add your new `sitemap.xml` to your Google Search Console.

---------------------

## Commit your work to Git

It's time to commit & push your work.  
Your modifications will be deployed by Github and displayed at `<username>.github.io`.  
If it is not showing up at your website, go to <kbd>Actions</kbd> tab in your Github repository.  
Then select <kbd>Re-run everything</kbd>.  
Navigate to <kbd>Settings</kbd> - <kbd>Pages</kbd>.  
Under <kbd>Build and deployment</kbd>, change `Source` to `Github Actions`.  

---------------------
