# Site usage guide

This site is a copied Academic Pages/Jekyll template customized for `kjoonha.github.io`.

The public navigation sections are:

- **Projects**: project/ASIC-related portfolio entries from `_projects/`
- **Publications**: publication entries from `_publications/`
- **CV**: editable Markdown CV at `_pages/cv.md`
- **Blog**: long-form posts from `_posts/`
- **Notes**: migrated and future technical notes from `_notes/`
- **Gallery**: image cards from `_gallery/`

## How to edit each section

### About / homepage

Edit:

```text
_pages/about.md
```

This file controls the homepage content at `/`.

### Projects

Project entries live in:

```text
_projects/
```

Create one Markdown file per project, for example:

```text
_projects/2026-06-12-example-project.md
```

Example front matter:

```yaml
---
title: "Example ASIC Project"
date: 2026-06-12
excerpt: "One-sentence summary shown on the Projects page."
permalink: /projects/example-asic-project/
---
```

Then write the project details below the front matter.

### Publications

Publication entries live in:

```text
_publications/
```

Example:

```yaml
---
title: "Paper Title"
date: 2026-06-12
venue: "Conference or Journal Name"
paperurl: /files/paper.pdf
citation: "Author list. Paper title. Venue, 2026."
---
```

Put PDFs or BibTeX files in:

```text
files/
```

### CV

Edit the Markdown CV directly:

```text
_pages/cv.md
```

The page is published at:

```text
/cv/
```

### Blog

Blog posts live in:

```text
_posts/
```

Use Blog for polished, long-form posts. The URL format is:

```text
/blog/YYYY/MM/title/
```

### Notes

Notes live in:

```text
_notes/
```

Use Notes for technical notes, snippets, learning notes, and shorter references. The URL format currently used by migrated notes is explicit in each file, for example:

```yaml
permalink: /notes/2025/05/git-commands/
```

The Notes archive intentionally hides excerpts/previews so that only compact note cards are shown.

### Gallery

Gallery items live in:

```text
_gallery/
```

Each gallery item is a Markdown document with image metadata:

```yaml
---
title: "Photo title"
date: 2026-06-12
image: /images/my-photo.jpg
description: "Short description shown under the image."
---
```

Put images in one of these locations:

```text
images/
assets/img/
```

For a simple workflow, place gallery photos in `images/gallery/` and reference them like:

```yaml
image: /images/gallery/my-photo.jpg
```

## Profile, bio, affiliation, and profile picture

Most sidebar profile settings are in:

```text
_config.yml
```

Look for this section:

```yaml
author:
  avatar: "profile.png"
  name: "Kyoungjoon Ha"
  bio: "Hello, I am kjha."
  location: "Seoul, South Korea"
  employer: "Samsung Electronics"
  email: "g1004jay@snu.ac.kr"
  github: "kjoonha"
  linkedin: "kjoonha"
```

### Change profile picture

The current profile picture is:

```text
images/profile.png
```

To replace it:

1. Save a new square-ish image as `images/profile.png`, or use a new filename.
2. If you use a new filename, update `_config.yml`:

```yaml
author:
  avatar: "new-profile-image.png"
```

Academic Pages automatically looks for non-URL avatar files under `images/`.

## How to write posts

### Blog post template

Create:

```text
_posts/YYYY-MM-DD-my-post-title.md
```

Example:

```yaml
---
title: "My Blog Post Title"
date: 2026-06-12
categories:
  - blog
tags:
  - asic
  - learning
---

Write the post here.
```

Blog post URLs are generated as:

```text
/blog/YYYY/MM/my-post-title/
```

### Note template

Create:

```text
_notes/YYYY-MM-DD-my-note-title.md
```

Recommended front matter:

```yaml
---
title: "My Note Title"
date: 2026-06-12
permalink: /notes/2026/06/my-note-title/
tags:
  - cpp
  - linux
---

Write the note here.
```

Notes are shown as dimmed rectangular cards on `/notes/`. Tags appear on the right side of each card.

## How to write a hobby post

Use the Blog section for polished hobby posts such as cooking, travel, photography, or personal projects.

Create a file like:

```text
_posts/2026-06-12-my-hobby-post.md
```

Example front matter:

```yaml
---
title: "My Frittata Recipe"
date: 2026-06-12
categories:
  - hobby
  - cooking
tags:
  - cooking
  - recipe
  - italian
---
```

If the hobby post is more of a short reference or learning note, put it in `_notes/` instead and use a `/notes/YYYY/MM/.../` permalink.
