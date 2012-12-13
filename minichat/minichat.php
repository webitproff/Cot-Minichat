<?php

/* ====================
[BEGIN_COT_EXT]
Hooks=standalone,ajax,index.tags,page.tags,page.list.tags,users.details.tags
Tags=index.tpl:{MINICHAT};page.tpl:{MINICHAT};page.list.tpl:{MINICHAT};users.details.tpl:{MINICHAT}
[END_COT_EXT]
==================== */

/**
 * Cotonti Minichat
 *
 * @package Cotonti
 * @version 2.2
 * @author esclkm, Moool13
 * @copyright &copy; esclkm 2010
 */

/* @var $db CotDB */
/* @var $cache Cache */
/* @var $t Xtemplate */

defined('COT_CODE') OR die("Wrong URL.");

require_once cot_incfile('users', 'module');
require_once cot_incfile('forms');
require_once cot_langfile('minichat', 'plug');


global $db_chat, $db_x, $lang;
$db_chat = (isset($db_chat)) ? $db_chat : $db_x . 'chat';

$template = (cot_import('panel', 'G', 'BOL') || $env['ext'] != 'minichat') ? '.index' : '';

$cfg['plugin']['minichat']['minichat_css'] ? cot_rc_link_footer($cfg['plugins_dir'] . '/minichat/lib/mch_style.css') : '';
cot_rc_link_footer("./images/smilies/lang/$lang.lang.js");
cot_rc_link_footer('images/smilies/set.js');


/**
 * Builds minichat_box
 *
 * @param string $temlate Use temlate for minichat.
 * @param bool $ajax Use If loaded by ajax.
 * @param bool $jaxpagination Use If ajax paginated.
 * @return string
 */
function minichat_build($template, $ajax = false)
{
	global $usr, $error_string, $cfg, $db_chat, $db_users, $L, $t, $db, $sys;
	list(
        $usr['auth_read_chat'],
        $usr['auth_write_chat'],
        $usr['isadmin_chat']
    ) = cot_auth('plug', 'minichat');

	$mskin = cot_tplfile('minichat' . $template, true);
	$minichatt = new XTemplate($mskin);


    $shoutbox = trim(cot_import('shoutbox', 'P', 'HTM'));
    $edit = cot_import('edit', 'G', 'INT');
    $a = cot_import('a', 'G', 'ALP');
    $del = cot_import('del', 'G', 'INT');

	if ($edit > 0 && $usr['isadmin_chat'])
	{
        if($a == 'update' && $usr['isadmin_chat'])
        {
            $db->update($db_chat, array('chat_text' => $shoutbox), 'chat_id=' . $edit);
            !$ajax ? cot_redirect(cot_url('plug', 'e=minichat')) : '';

        }
		$sql = $db->query("
            SELECT * FROM $db_chat
            WHERE chat_id=$edit
        ");
        $row = $sql->fetch();
		$minichatt->assign(array(
			"MINICHAT_EDIT_ID" => $edit,
			"MINICHAT_EDIT_AUTHOR" => cot_build_user($row['chat_author_id'], $row['chat_author']),
			"MINICHAT_EDIT_TEXT" => $row['chat_text'],
			"MINICHAT_EDIT_DATE" => cot_date('datetime_medium', $row['chat_date']),
            "MINICHAT_EDIT_FORM_SEND" => cot_url('plug', ($ajax ? 'r' : 'e') . '=minichat&edit=' . $edit . '&a=update', '', 1),
            "MINICHAT_AJAX" => $ajax
		));
        $minichatt->parse("MINICHAT_EDIT");

		cot_shield_update(20, "Edit minichat message");
        cot_log('Edited minichat message #' . $edit, 'adm');
		$shoutbox = '';
		unset($_POST['shoutbox']);

		$res = $minichatt->text("MINICHAT_EDIT");
		return $res;
	}

	cot_shield_protect();
	$poster_name = $usr['name'];
	$poster_id = $usr['id'];
	$error_string .= ($poster_id == 0) ? $L['minichat_nouser_message'] . '<br>' : '';
	$error_string .= (!$usr['auth_write_chat']) ? $L['minichat_nowriterights'] . '<br>' : '';
	if (!empty($shoutbox))
	{
        $error_string .= (mb_strlen($shoutbox) > $cfg['plugin']['minichat']['minichat_maxchars']) ? $L['minichat_long_message'] . '<br>' : '';
     	$error_string .= (mb_strlen($shoutbox) < $cfg['plugin']['minichat']['minichat_minchars']) ? $L['minichat_short_message'] . '<br>' : '';
		if (empty($error_string))
		{
			$db->insert($db_chat, array(
                'chat_author' => $poster_name,
                'chat_author_id' => (int)$poster_id,
                'chat_author_ip' => $usr['ip'],
                'chat_text' => $shoutbox,
				'chat_date' => $sys['now_offset']
            ));
			cot_shield_update(20, "New minichat message");
			$shoutbox = '';
			unset($_POST['shoutbox']);
		}
	}
	if ($del > 0 && $usr['isadmin_chat'])
	{
		$db->delete($db_chat, "chat_id='$del'");
		cot_log('Deleted minichat message #' . $del, 'adm');
		unset($_GET['del']);
	}
	if ($template != '')
	{
		$perpage = $cfg['plugin']['minichat']['minichat_recent'];
		$panelchat = '&panel=1';
	}
	else
	{
		$perpage = $cfg['plugin']['minichat']['minichat_maxperpage'];
		$panelchat = '';
	}
	$d_var = 'd_mch';
	list($pg, $d, $durl) = cot_import_pagenav($d_var, $perpage);

	if (!empty($error_string))
	{
		$minichatt->assign("MINICHAT_ERROR", $error_string);
		$minichatt->parse("MINICHAT.MINICHAT_ERRORBLOCK");
	}
	if ($usr['auth_read_chat'])
	{
		$totalitems = $db->query("SELECT COUNT(*) FROM $db_chat  ")->fetchColumn();
        $DESC = $cfg['plugin']['minichat']['minichat_sort'] ? 'DESC' : '';
		$sql = $db->query("
            SELECT c.*, u.* FROM $db_chat AS c LEFT JOIN $db_users AS u
            ON u.user_id = c.chat_author_id
            ORDER BY chat_id
            $DESC LIMIT $d, $perpage
        ");
		$ii = 0;
		foreach ($sql->fetchAll() as $row)
		{
			$ii++;
			$minichatt->assign(array(
				"MINICHAT_ROW_ID" => $row['chat_id'],
				"MINICHAT_ROW_AUTHOR" => cot_build_user($row['chat_author_id'], $row['chat_author']),
				"MINICHAT_ROW_TEXT" => cot_parse($row['chat_text'], $cfg['plugin']['minichat']['minichat_markup']),
				"MINICHAT_ROW_DATE" => cot_date('datetime_medium', $row['chat_date']),
                "MINICHAT_ROW_ODDEVEN" => cot_build_oddeven($ii),
				"MINICHAT_ROW_DELETE_URL" => $usr['isadmin_chat'] ? cot_url("plug", "e=minichat&del=" . $row['chat_id']) : '',
				"MINICHAT_ROW_EDIT_URL" => $usr['isadmin_chat'] ? cot_url("plug", "e=minichat&edit=" . $row['chat_id']) : ''
			));
			$minichatt->assign(cot_generate_usertags($row, 'MINICHAT_ROW_AUTHOR_'), htmlspecialchars($row['chat_author']));
			$minichatt->parse("MINICHAT.CHAT.MINICHAT_ROW");
		}
        $minichatt->assign("MINICHAT_PAGE", ceil($d / $perpage) + 1);
		$pagenav = cot_pagenav('plug', 'e=minichat', $d, $totalitems, $perpage, $d_var, '#minichatajax', $cfg['jquery'] && $cfg['turnajax'], 'minichatajax', 'plug', "r=minichat" . $panelchat);

		$minichatt->assign(array(
			"MINICHAT_PAGENAV" => $pagenav['main'],
			"MINICHAT_PREV" => $pagenav['prev'],
			"MINICHAT_NEXT" => $pagenav['next'],
		));

		if ($ii == 0)
		{
			$minichatt->parse("MINICHAT.CHAT.MINICHAT_EMPTY");
		}
		$minichatt->parse("MINICHAT.CHAT");

		if ($ajax)
		{
			$res = $minichatt->text("MINICHAT.CHAT");
			return $res;
		}

		if ($usr['auth_write_chat'])
		{
			$minichatt->assign(array(
				"MINICHAT_FORM_SEND" => cot_url('plug', 'e=minichat'),
				"MINICHAT_FORM_PANEL" => ($template != '') ? 'Panel' : ''
			));
			$minichatt->parse("MINICHAT.MINICHAT_FORM");
		}

		$autoreloadtime = ($template != '') ? $cfg['plugin']['minichat']['minichat_recenttimer'] : $cfg['plugin']['minichat']['minichat_timer'];
		$minichatt->assign(array(
            "MINICHAT_TIMER" => $autoreloadtime * 1000,
            "MINICHAT_PANEL" => ($template != '') ? 1 : 0,
            "MINICHAT_ROW_ADMIN" => $usr['isadmin_chat']
        ));
		$minichatt->parse("MINICHAT");
		$res = $minichatt->text("MINICHAT");
	}

	return $res;
}


$MINICHAT = minichat_build($template, $r ? true : false);
if($r)
{
	cot_sendheaders();
	echo $MINICHAT;
}
else
{
	$t->assign("MINICHAT", $MINICHAT);
}

?>
