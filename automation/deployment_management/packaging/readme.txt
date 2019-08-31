Prerequisite: installed Git, clonned keytruda-prototype repository and checked out deployment branch (master)
* copy pack.config and pack.sh into the directory where you store git repositories (C:\Users\kamenskl\Desktop\git)
* update pack.config if development repository structure changed
* open GIT BASH terminal
* navigate to the directory where you store the git repositories (cd /C/Users/kamenskl/Desktop/git)
* run  as: 
./pack.sh CHCK  ## deployment verification database IDML_MANTISDW_KDM2_DEV
./pack.sh DEV   ## DEV MMD_DMI_PDM_BI
./pack.sh TEST  ## TST IDW_DML_SZ_MANTISDW_KDM_TST
./pack.sh UAT   ## UAT IDW_DML_SZ_MANTISDW_KDM


