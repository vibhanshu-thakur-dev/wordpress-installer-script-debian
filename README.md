# wordpress-installer-script-debian
This interactive script can install wordpress in debian 8, 9 and 10.

This script installs latest version of wordpress in debian(OS) in one shot.

## Software Stack to be installed by the script
- Apache Server
- MariaDB
- PHP
- PHP Command Line Interface
- Wordpress

Interactive steps include securing MariaDB with root password.

## Interactive questions while running script
- Root password > enter root password
- Do you want to remove test database? > Y
- Do you want to reload permissions table? > Y
- Do you want to block remote login to database? Y

## Steps to be done post running the script
Get unique salt values by doing this: `curl -s https://api.wordpress.org/secret-key/1.1/salt/`
This will give a response like below:
define('AUTH_KEY',         'i5Mn8TXsm[g) /qbzev[e74^$T)iiM)rLy-KZm-giI#AKTW0*q JQCfpMwZI%I&>');
define('SECURE_AUTH_KEY',  '7$G,+%4K;ks)Xg>%z+7=8[IFb;z>Er}L&Qv7~Vx|+5M]8_&hBe37cc0{yw=*Hq');
define('LOGGED_IN_KEY',    '|fniEr@6->8>E=4)&&|T^,-i0)RLrh&|V_LLr(1LX[I%)mz~Nw|[R)p}Q8A^2nM');
define('NONCE_KEY',        'N!}T;{Q5%[m5-|}[b)>q^n5.9&LieshK#DO+iCPBaJgW1Fs&el[1 78l|)]5JyT[');
define('AUTH_SALT',        'f}l@W12^i.vX_T_,)P1D5S|OjmQqzk9G-#L)e7Lk)}-IR%g6X$0)>-MCaIsYbsrB');
define('SECURE_AUTH_SALT', ']_Rp3V^z?=rC/#@n#UF}+pc,CfL($-58>OWB<H/T^l;WWJVe~$OLCRpZXN$UB>/');
define('LOGGED_IN_SALT',   ';~&DMn8NaJEDgiAYA<0MiV&$y|N93hs{j=jLquic*zP?oSk+hhL5F5 z9+6e[t%!');
define('NONCE_SALT',       '_2w/%vxo6P%]u?o%6cuw--HJ3YGyCnvk4Tgg,rgW,$IfI+HKUXWw3<}|{p~VqqA!');

After getting the reponse from above command, replace values from /var/www/wordpress/wp-config.php file. This must be self explanatory.

## Updates
I am currently in the process of updating the script to automate the copying of salt keys part as well. 
