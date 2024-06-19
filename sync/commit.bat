@echo off

REM Add all files to the commit
git add -A

REM Create a commit comment
git commit -m "dumping config"

REM Push the changes to GitHub
git push

REM Optional: Display the commit comment and push status
echo Commit Comment: %commit_comment%
echo Push Status: %errorlevel%
