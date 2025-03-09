---
layout: post
title: How to make your own Github Blog.
subtitle: This post explains how you can make your own Github blog.
tags: [github]
---

This post explains how to setup [Github](https://github.com) blog.

-------------
<span class="color-blue">Step 1. Make github repository</span><br>
Make your [Github](https://github.com) repository.  
Make sure you name your repository as `<username>.github.io` and make it `public`.
Then clone your repository into your local.  
`git clone your_repository`

---------------------
<span class="color-blue">Step 2. Install Ruby 2.7.0</span><br>
```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv/
echo 'export RUBYOPT='-W0'' >> ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL
rbenv install 2.7.0
rbenv global 2.7.0
```
---------------------
<span class="color-blue">Step 3. Install Bundler and Jekyll using Gem</span><br>
<pre>
    <code class="bash">
        gem install jekyll
        gem install bundler 
        gem install webrick
        bundle update
        bundle add webrick
    </code>
</pre>
---------------------
<span class="color-blue">Step 4. Get your preferred theme into your repository.</span><br>
In this example we will use [Parchment Theme](https://github.com/rhl-bthr/parchment).  
```bash
git clone https://github.com/rhl-bthr/parchment ./<your local repostiroy path>
bundle install
```
Running `bundle install` will trigger installation of packages listed in `Gemfile`.

---------------------
<span class="color-blue">Step 5. Configure to your preference.</span><br>
Edit `./_config.yml` to your needs.  
```yml
url: <user_name>.github.io
baseurl: "/parchment"
```
Edit `./css/main.scss` to your needs.


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
