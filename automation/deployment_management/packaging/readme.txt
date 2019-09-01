Comments only for manual execution, not for usage within jenkins pipeline!

Prerequisite: installed Git, clonned demoproject repository and checked out deployment branch (develop)
* copy pack.config and pack.sh into the directory where you store git repositories (C:\Users\luba\Desktop\git)
* update pack.config if development repository structure changed
* open GIT BASH terminal
* navigate to the directory where you store the git repositories (cd /C/Users/luba/Desktop/git)
* run  as: 
./pack.sh DEV   
./pack.sh TEST  
./pack.sh UAT   


