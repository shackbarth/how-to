#!/bin/bash
# Reset DB and install orms

cd ~/Devel/git/xtuple/enyo-client/database
./resetdb.py -d instance -u shackbarth -b ~/Devel/tools/xtuple/demo-current.backup
#./resetdb.py -d qatest -u shackbarth -b ~/Devel/tools/xtuple/demo-current.backup

#~/Devel/install_orms.sh
echo "Reset DB complete"
