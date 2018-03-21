#!/bin/bash

ERROR=0

if [[ -f /var/www/html/settings.php ]]; then

    echo "settings.php exists, starting without setup."

else

    echo "settings.php does not exist, running database setup."
    if [[ "${DBTYPE}" == "sqlite" ]]; then

        echo "DBTYPE=sqlite (default), running setup.php with dbType=sqlite, action=step1"
        echo | php -B "\$_POST = array('dbType' => 'sqlite', 'action' => 'step1');" -F setup.php --
        ERROR=$?
        echo -e "\n\n"
        rm /var/www/html/setup.php

    elif [[ "${DBTYPE}" == "mysql" ]]; then

        echo "DBTYPE=mysql"
        echo "running setup.php with dbType=mysql, action=step1"
        echo | php -B "\$_POST = array('dbType' => 'mysql', 'action' => 'step1');" -F setup.php --
        echo -e "\n\nrunning setup.php with dbhost=${DBHOST}, dbname=${DBNAME}, dbuser=${DBUSER}, dbpass=${DBPASS}, dbType=mysql, action=step2"
        echo | php -B "\$_POST = array('dbhost' => '${DBHOST}', 'dbname' => '${DBNAME}', 'dbuser' => '${DBUSER}', 'dbpass' => '${DBPASS}', 'dbType' => 'mysql', 'action' => 'step2');" -F setup.php --
        ERROR=$?
        echo -e "\n\n"
        rm /var/www/html/setup.php

    else

        echo "DBTYPE must be 'sqlite' or 'mysql'"
        exit 1

    fi

    if [[ ! "${ERROR}" -eq "0" ]]; then

        echo "error ${ERROR} during database setup."
        exit 1

    fi
fi

if [[ "${ENABLE_REGISTER}" == "true" || "${ENABLE_REGISTER}" == "false" ]]; then

    #https://stackoverflow.com/questions/12144158/how-to-check-if-sed-has-changed-a-file#28966696
    sed -i -e "s/ENABLE_REGISTER\", (false\|true)/${ENABLE_REGISTER})/w changed.txt" /var/www/html/settings.php
    if [[ -s changed.txt ]]; then
        echo "ENABLE_REGISTER changed to ${ENABLE_REGISTER}"
    fi
    rm changed.txt

else

    echo "ENABLE_REGISTER must be 'true' or 'false'"
    exit 1

fi

exit 0
