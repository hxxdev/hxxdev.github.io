---
layout: post
title: How to make your own Github Blog.
subtitle: This post explains how you can make your own Github blog.
tags: [git]
---

This post explains how to setup your own [Github](https://github.com) blog.  
Let's get started!  

-------------
**Step 1. Make Github repository**  
Make your own [Github](https://github.com) repository.  
Make sure you name your repository as `<username>.github.io` and make it public.  
Then clone your repository into your local.  
`git clone <your_repository>`

---------------------
**Step 2. Install Ruby 2.7.0**    
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
**Step 3. Install Bundler and Jekyll using Gem**  
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
**Step 4. Basic configurations**  
Edit `./_config.yml` to your needs.  
```yml
url: <user_name>.github.io
baseurl: ""
```
---------------------

**Step 5. Get your preferred theme into your repository.**  
In this example we will use [Parchment Theme](https://github.com/rhl-bthr/parchment).  
```git
git clone https://github.com/rhl-bthr/parchment ./<your local repository path>
```
Running `bundle install` will trigger installation of packages listed in `Gemfile`.
Since we have installed the necessary packages for our theme, let's play with syntax highlighting.
add the code for markdown to html conversion in `_config.yml`.
```yml
markdown: kramdown
kramdown:
  input: GFM
  syntax_highlighter: rouge
```
Now let's generate `css` for our syntax highlighting. Running this will generate css for `github` style syntax:
```bash
rougify style github > ./css/syntax.css
```
Then add the following line to your `main.css`.
```css
@import "syntax.css"
```
Since we have our syntax highlighter ready, now we can deal with code snippets!
In markdown, small code snippets will be converted to html element `code` with class `highlighter-rounge` and block code snippets(let's say cpp is used as language.) will be converted to html element `pre` with class `language-cpp highlighter-rounge`. Therefore, we can decorate our code snippets by defining `code` and `pre` in `main.css`.
```css
pre {
    border-radius: 15px;
    background-color: #f7f7f8;
    page-break-inside: avoid;
    font-size: 13px;
    line-height: 1.4;
    margin-bottom: 1.6em;
    max-width: 100%;
    overflow: auto;
    padding: 1em 1.5em;
    display: block;
    word-wrap: break-word;
    white-space: pre-wrap;
    white-space: -moz-pre-wrap;
    white-space: -o-pre-wrap;
    white-space: -ms-pre-wrap;
    text-indent: 0px;
}
code {
    display: inline-block;
    font-family: "Fira Code", Consolas, "Courier New", monospace;
    font-size: 13px;
    font-weight: 400;
    border-radius: 3px;
    background-color: #f7f7f8;
    color: #424242;
    padding: 2px 4px;
    line-height: 1.4;
}
```


---------------------
**Step 6. Commit your work to Git!**  
It's time to commit & push your work.  
Your modifications will be deployed by Github and displayed at `<username>.github.io`.  
If it is not showing up at your website, go to `Actions` tab in your Github repository.  
Then select `Re-run everything`.

---------------------

<span class="highlight-blue">And</span>
<span class="highlight-green">some</span>
<span class="highlight-orange">highlighting</span>
<span class="highlight-red">styles.</span>

**Here is a bulleted list,**
 - This is a bullet point
 - This is another bullet point


**Here is a numbered list,**
1. You can also number things down.
2. And so on.

**Here is a sample code snippet in C,**
```C
#include <stdio.h>

int main(void){
    printf("hello world!");
}
```

**Here is a horizontal rule,**

--------------

**Here is a blockquote,**

> There is no such thing as a hopeless situation. Every single 
> circumstances of your life can change!

**Here is a table,**

ID  | Name   | Subject
----|--------|--------
201 | John   | Physics
202 | Doe    | Chemistry
203 | Samson | Biology

**Here is a link,**<br>
[GitHub Inc.](https://github.com) is a web-based hosting service
for version control using Git

**Here is an image,**<br>
![](../assets/autumn.jpg)
