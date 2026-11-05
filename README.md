# ARCH 540 · Student work (Fall 2026)

Page: https://genenv.github.io/arch540-final-project/

One page, two sections, both read at load time from the class submissions sheet ("ARCH540 Mid-review submissions", Google Sheets, UBC account):

- **Final project: mid-review** reads the `Mid-review` tab. One row per student: project title, proposal, repository, app, video (a Google Drive link or a direct mp4), thumbnail, notes.
- **Assignment 1: Vancouver Regulation Toolkit** reads the `Assignment 1` tab: the fifteen tools from the October 2 review with the discussion notes. The cross-cutting remarks come from `projects.json` on the Assignment 1 page (https://genenv.github.io/arch540-a1-toolkit/).

Students edit their own row in the sheet; nothing in this repository has to change for the page to update. The page tolerates the usual slips: a GitHub page title pasted into the repository cell, a GitHub Pages address in place of the repository, a missing title, a missing video.

- `index.html` is the whole site. The sheet id and the tab gids are in the `SHEET` and `TABS` constants at the top of the script.
- `data/midreview.csv` and `data/assignment1.csv` are a saved copy of the two tabs, used only when the sheet cannot be reached (the page then says so). `./refresh_data.sh` updates them; commit the result.
- Comments posted on the page go to the same Google Form as the Assignment 1 page and are shown from its response sheet; delete a row there to remove a comment. Mid-review comments are stored with the key `<title> (mid-review)`.
- Page views are counted by GoatCounter (site `arch540`).
