#!/bin/bash
apt -y update
apt -y install apache2

cat <<EOF > /var/www/html/index.html
<html>
<h2>Ter <font color="red"> v0.12</font></h2><br>
Owner ${f_name} ${last_name} <br>

%{ for x in names ~}
HI ${x} ot ${f_name}<br>
%{ endfor ~}

sudo systemctl apache2 restart
