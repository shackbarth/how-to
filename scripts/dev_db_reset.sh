#!/bin/bash

cd ~/Devel/git/xtuple/enyo-client/database/source
psql -d dev -f init_instance.sql
cd ~/Devel/git/xtuple/enyo-client/extensions/source/crm/database/source
psql -d dev -f init_script.sql
cd ~/Devel/git/xtuple/enyo-client/extensions/source/project/database/source
psql -d dev -f init_script.sql
cd ~/Devel/git/xtuple/enyo-client/extensions/source/sales/database/source
psql -d dev -f init_script.sql
cd ~/Devel/git/private-extensions/source/incident_plus/database/source
psql -d dev -f init_script.sql

cd ~/Devel/git/xtuple/node-datasource/installer
./installer.js -h localhost -d dev -u shackbarth -p 5432 --path ../../enyo-client/database/orm -P
./installer.js -h localhost -d dev -u shackbarth -p 5432 --path ../../enyo-client/extensions/source/crm/database/orm -P
./installer.js -h localhost -d dev -u shackbarth -p 5432 --path ../../enyo-client/extensions/source/project/database/orm -P
./installer.js -h localhost -d dev -u shackbarth -p 5432 --path ../../enyo-client/extensions/source/sales/database/orm -P
./installer.js -h localhost -d dev -u shackbarth -p 5432 --path ../../../private-extensions/source/incident_plus/database/orm -P
