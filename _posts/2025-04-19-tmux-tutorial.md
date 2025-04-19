---
title: Mastering Terminal Multitasking, Beginner's Guide to tmux
date: 2025-04-19
categories: [dev, shell]
tags: [tmux]
---

This post explains about **what tmux is, how to install tmux and use tmux**.

-----------------------------------

### Installation

If you are using Ubuntu, `tmux` can be installed using command:

```shell
sudo apt-get install tmux
```

-----------------------------------

### Concept

{% plantuml %}
rectangle "session" as session1
rectangle "session" as session2
rectangle "window" as window1
rectangle "window" as window2
rectangle "window" as window3
rectangle "window" as window4
rectangle "pane" as pane1
rectangle "pane" as pane2
rectangle "pane" as pane3
rectangle "pane" as pane4
rectangle "pane" as pane5
rectangle "pane" as pane6
rectangle "pane" as pane7


session1 -down-> window1
session1 -down-> window2
session2 -down-> window3
session2 -down-> window4
window1 -down-> pane1
window1 -down-> pane2
window2 -down-> pane3
window3 -down-> pane4
window3 -down-> pane5
window3 -down-> pane6
window4 -down-> pane7
{% endplantuml %}

Using `tmux`, you can make many **sessions**.  
A single **session** can have a lot of **windows**.  
A single **window** can again have a lot of **panes**.  

Run `tmux` in the terminal.  
The bottom green status bar will show up. It indicates the **session name** and **the windows in the session**.  

![Desktop View](./../assets/posts/tmux_tutorial/tmux.png){: width="300" .left}

- `[1]` indicates the session name.
- `Session 1` has **4 windows**.
- The asterix(`*`) next to `window 3` indicates the window that is displayed on the terminal.

-----------------------------------

### Commands

#### Sessions

|command|description|
|:-:|:-|
|`tmux`| run tmux.|
|`ctrl-b :new`| make new session.|
|`ctrl-b :kill-session`| kill session.|
|`ctrl-b s` - `t` - `X`| kill tagged session(s).|
|`ctrl-b s`| change session.|
|`ctrl-b w`| change session/window.|
|`ctrl-b $`| rename session.|

#### Windows

|command|description|
|:-:|:-|
|`ctrl-b c` | create window.|
|`ctrl-b n` | go to next window.|
|`ctrl-b p` | go to previous window.|
|`ctrl-b w`| change session/window.|
|`ctrl-b ,` | rename window/pane. |
|`ctrl-b d` | close window/pane. |

#### Panes

|command|description|
|:-:|:-|
|`ctrl-b %` | split horizontal pane. |
|`ctrl-b "` | split vertical pane. |
|`ctrl-b d` | close window/pane. |
