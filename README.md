# ARCH 540 Final project: mid-review page

Page: https://genenv.github.io/arch540-final-project/

The page has no data of its own. At load time it reads the `Mid-review` tab of the Google Sheet "ARCH540 Mid-review submissions" (published as CSV) and renders one entry per row: project title, student, proposal, repository and app links, the video (Google Drive link or direct mp4) and the thumbnail. Students edit their own row in the sheet; nothing in this repository needs to change.

- `index.html` is the whole site. The sheet's published CSV link is the `SUBMISSIONS_CSV` constant near the top of the script.
- Comments posted on the page go to the same Google Form as the Assignment 1 page and are displayed from its response sheet.
- Assignment 1 page: https://genenv.github.io/arch540-a1-toolkit/
