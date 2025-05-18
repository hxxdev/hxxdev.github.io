---
title: Useful git commands, increase your productivity.
date: 2025-05-04
categories: [dev, git]
tags: [git]
---

This post is for keeping useful **git commands**.

---

### Useful git commands

|Commands          | Descriptions |
|:--               | :--          |
|`git clone`       | create a clone of a remote Git repository onto your local machine<br>🎈`--recursive`: If the repository contains submodules, this option initializes and clones them as well.<br>🎈`--branch <branch>`: Clone a specific branch instead of the default branch. <br>🎈`--quiet`: Reduce the output during the cloning process.<br>🎈`--no-remote`: skips the creation of a remote reference to the original repository, making the cloned repository independent of the remote.|
|`git checkout`    | used for switching between different branches, restoring files, and creating new branches.<br>🎈`<branch-name>`: switch from one branch to another.<br>🎈`-- <file>`: restore a file (or multiple files) to its state in the latest commit on your current branch. This is helpful if you have modified a file but want to discard your changes.<br>🎈`<commit-hash>`: go to a specific commit. Your git will enter detached `HEAD` state.<sup>1</sup><br>🎈`<commit-hash> -- <file-path>`: checkout a specific file from a specific commit. This does not detach your `HEAD`.<sup>1</sup><br>🎈`<branch-name> -- <file>`: checkout individual files from another branch<br>🎈 `-b <new-branch-name>`: create a new branch and switch to the new branch.|
|`git push`    | 🎈`<remote> <tagname>` push a specific tag<br>🎈`--tags`: push all tags|
|`git pull`    | used to fetch changes from a remote repository and merge those changes into your current branch.<br>🎈|
|`git tag`<sup>3</sup>    | list all tags<br>🎈`<tagname>` Creates a tag to the current commit.<sup>2</sup><br>🎈`-a <tagname> -m "message"`: Creates a tag with a message<sup>2</sup><br>🎈`<tagname> <commit-hash>`: tag a specific commit<sup>2</sup><br>🎈|


- 1: `HEAD` is a pointer that points to the latest commit of current branch. If `HEAD` is detached, it means you are not on any branch. You can see where `HEAD` points to by running `cat .git/HEAD`.

- 2: By default, tags are not pushed to remote. Refer to `git push` to push your tags to remote.

- 3: Tags are stored in `.git/refs/tags`.

---

### References
[1] [git-scm](https://git-scm.com/docs)

