# IRSec-Blue15
Blue team 15 tool repository for IRSec

# Git Workflow Instructions
You don't need to fork this repo! You can just set up your own branch and develop individually on it.
The reason being is that it is probably important for the whole team to be able to access each of our tools in case we need to access each others' boxes, as well as centralizing a place for White/Black team to see what we've been working on.

---
1. Add a branch, name it something personalized so the team knows its you
   (I think it's easier to use GUI on browser, but you can also use terminal commands):
   git checkout -c <branchname>
3. Clone the repo to your host machine
4. Pull from the repo so that you have the most up-to-date files:
   git pull origin main
5. Switch to your branch within your IDE. Branches that you are not directly switched into or are not loaded onto your machine are called remote branches, so that's some error troubleshooting terminology
   git switch <branchname>
6. Develop, commit your work, etc!
