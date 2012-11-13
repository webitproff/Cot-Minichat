CREATE TABLE IF NOT EXISTS `cot_chat` (
	`chat_id` int(11) NOT NULL auto_increment,
	`chat_author` varchar(100) collate utf8_unicode_ci NOT NULL,
	`chat_author_id` int(11) default NULL,
	`chat_author_ip` varchar(15) collate utf8_unicode_ci NOT NULL default '',
	`chat_text` text collate utf8_unicode_ci NOT NULL,
	`chat_date` int(11) NOT NULL default '0',
	PRIMARY KEY (`chat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
