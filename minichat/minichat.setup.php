<?php
/* ====================
[BEGIN_COT_EXT]
Code=minichat
Name=Minichat
Description=Cotonti Minichat
Version=2.2
Date=23-Aug-2010 (UPD 12-Now-2012)
Author=esclkm, Moool13
Copyright=&copy; esclkm 2010
Notes=
SQL=
Auth_guests=R
Lock_guests=12345A
Auth_members=RW
Lock_members=12345
[END_COT_EXT]

[BEGIN_COT_EXT_CONFIG]
minichat_recent=01:select:0,5,10,15,20,25,30,35,40,45,50,100:30:Recent minichat
minichat_maxperpage=02:select:0,5,10,15,20,25,30,35,40,45,50,100:30:Max. Shouts per page
minichat_maxchars=03:string::200:Max. Chars for shouts
minichat_minchars=04:string::2:Min. Chars for shouts
minichat_markup=05:radio:0,1:1:Allow BBCodes & Smiles in Shoutminichat
minichat_recenttimer=06:select:0,15,20,30,50:0:Autoreload minichat panel
minichat_timer=07:select:0,5,10,15,20,30,50:0:Autoreload, in ... seconds
minichat_css=10:radio:0,1:1:Enable plugin CSS
[END_COT_EXT_CONFIG]

[BEGIN_COT_EXT_CONFIG_STRUCTURE]
minichat_sort=08:select:0,1:1:Sorting direction
[END_COT_EXT_CONFIG_STRUCTURE]
==================== */

/**
 * Cotonti Minichat
 *
 * @package Cotonti
 * @version 1.00
 * @author esclkm
 * @copyright &copy; esclkm 2010
 */

defined('COT_CODE') or die("Wrong URL.");
?>
