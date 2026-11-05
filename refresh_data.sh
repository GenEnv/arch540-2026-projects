#!/bin/zsh
# Saves a fresh copy of the two sheet tabs into data/ (used by the page only when the live sheet cannot be reached)
# and the file list of the shared Drive folder "ARCH540 mid-review videos" (used to fill a video or thumbnail
# a student uploaded but did not paste into the sheet). Commit and push the result.
set -e
cd "$(dirname "$0")"
SHEET=10-8GOJDdNf2oM-7lpjZlFgsWTTEWyE2AjwOprtiw5ow
FOLDER=1cEQkPzlbiuzmuK-UN-Q6uGPeS5czb-dQ
curl -sfL "https://docs.google.com/spreadsheets/d/$SHEET/export?format=csv&gid=0" -o data/midreview.csv
curl -sfL "https://docs.google.com/spreadsheets/d/$SHEET/export?format=csv&gid=1681716343" -o data/assignment1.csv
TMP=$(mktemp)
curl -sfL "https://drive.google.com/embeddedfolderview?id=$FOLDER#list" -o "$TMP"
python3 -I - "$TMP" data/drive_folder.json <<'PY'
import sys, re, html, json, datetime
s = open(sys.argv[1], encoding='utf-8', errors='replace').read()
files = []
for e in re.split(r'<div class="flip-entry"', s)[1:]:
    fid = re.search(r'id="entry-([\w-]+)"', e)
    title = re.search(r'class="flip-entry-title"[^>]*>(.*?)</div>', e, re.S)
    if fid and title:
        files.append({"id": fid.group(1), "name": html.unescape(re.sub('<[^>]+>', '', title.group(1))).strip()})
json.dump({"updated": datetime.date.today().isoformat(), "folder": "https://drive.google.com/drive/folders/1cEQkPzlbiuzmuK-UN-Q6uGPeS5czb-dQ", "files": files}, open(sys.argv[2], 'w'), indent=1)
print(len(files), "files in the Drive folder")
PY
rm -f "$TMP"
# GitHub Pages address of each repository in the Mid-review tab (used as the app link when the App URL cell is empty)
python3 -I - data/midreview.csv data/repo_pages.json <<'PY'
import sys, csv, re, json, subprocess, datetime
rows = list(csv.reader(open(sys.argv[1], encoding='utf-8')))
irepo = [i for i, h in enumerate(rows[0]) if 'repo' in h.lower()][0]
pages = {}
for r in rows[1:]:
    cell = (r[irepo] if len(r) > irepo else '').strip()
    m = re.search(r'github\.com/([\w.-]+)/([\w.-]+?)(?:[/:\s]|$)', cell) or re.match(r'([\w.-]+)/([\w.-]+?)(?=[:\s]|$)', cell)
    if not m: continue
    owner, repo = m.group(1), m.group(2)
    out = subprocess.run(['gh', 'api', f'repos/{owner}/{repo}/pages', '--jq', '.html_url'], capture_output=True, text=True)
    if out.returncode == 0 and out.stdout.strip():
        pages[f'https://github.com/{owner}/{repo}'] = out.stdout.strip()
json.dump({"updated": datetime.date.today().isoformat(), "pages": pages}, open(sys.argv[2], 'w'), indent=1)
print(len(pages), "repositories with a GitHub Pages site")
PY
# Which Drive files linked in the Mid-review tab are not shared publicly (no thumbnail for anonymous requests): the page shows those as "not shared publicly yet"
python3 -I - data/midreview.csv data/drive_access.json <<'PY'
import sys, csv, re, json, subprocess, datetime
rows = list(csv.reader(open(sys.argv[1], encoding='utf-8')))
ids = sorted(set(m for r in rows[1:] for cell in r for m in re.findall(r'drive\.google\.com/(?:file/d/|open\?id=|uc\?id=)([\w-]+)', cell)))
private = []
for i in ids:
    out = subprocess.run(['curl', '-sL', '-o', '/dev/null', '-w', '%{http_code} %{content_type}', f'https://drive.google.com/thumbnail?id={i}&sz=w64'], capture_output=True, text=True).stdout
    if not (out.startswith('200') and 'image/' in out): private.append(i)
json.dump({"updated": datetime.date.today().isoformat(), "checked": len(ids), "private": private}, open(sys.argv[2], 'w'), indent=1)
print(len(ids), "Drive files checked,", len(private), "not public")
PY
sed -i '' "s/var SNAPSHOT_DATE='[0-9-]*'/var SNAPSHOT_DATE='$(date +%Y-%m-%d)'/" index.html
wc -l data/*.csv
