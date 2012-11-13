<!-- BEGIN: MINICHAT_EDIT -->
<form action="{MINICHAT_EDIT_FORM_SEND}" method="post" name="mcFormEdit" id="mcFormEdit">
    <!-- IF !{MINICHAT_AJAX} --><h3>{PHP.L.Edit}:</h3><!-- ENDIF -->
    <div>
        <textarea id="shoutbox" name="shoutbox" rows="5" cols="64">{MINICHAT_EDIT_TEXT}</textarea>
    </div>
    <input type="submit" value="{PHP.L.Submit}" />
</form>
<!-- END: MINICHAT_EDIT -->



<!-- BEGIN: MINICHAT -->
<div class="mcHead">{PHP.L.minichat_shoutbox}</div>
<!-- BEGIN: CHAT -->
<div id="minichatajax">
    <script>d_var = {MINICHAT_PAGE};</script>
    <div class="mcBody">
        <div class="mcBodyScroll">
            <!-- IF {MINICHAT_NEXT} OR {MINICHAT_PREV} -->
            <div class="mcPag mcPagOdd">
                {MINICHAT_PREV}{MINICHAT_PAGENAV}{MINICHAT_NEXT}
            </div>
            <!-- ENDIF -->
            <!-- BEGIN: MINICHAT_ROW -->
            <div class="mcPost{MINICHAT_ROW_ODDEVEN}">
                <div class="mcInfo fl_r">
                    {MINICHAT_ROW_DATE}
                    <!-- IF {MINICHAT_ROW_DELETE_URL} -->
                    | <a href="{MINICHAT_ROW_EDIT_URL}" class="mcAjaxEdit" rel="{MINICHAT_ROW_ID}">{PHP.L.Edit}</a>
                    <!-- ENDIF -->
                    <!-- IF {MINICHAT_ROW_DELETE_URL} -->
                    | <a href="{MINICHAT_ROW_DELETE_URL}" class="mcAjaxDelete" rel="{MINICHAT_ROW_ID}">{PHP.L.Delete}</a>
                    <!-- ENDIF -->
                </div>
                {MINICHAT_ROW_AUTHOR} <a href="javascript:;" class="toUser" rel="{MINICHAT_ROW_AUTHOR_NICKNAME}">↓</a>
                <p>{MINICHAT_ROW_TEXT}</p>
            </div>
            <!-- END: MINICHAT_ROW -->
            <!-- BEGIN: MINICHAT_EMPTY -->
            <div class="error">{PHP.L.minichat_empty}</div>
            <!-- END: MINICHAT_EMPTY -->
            <!-- IF {MINICHAT_NEXT} OR {MINICHAT_PREV} -->
            <div class="mcPag mcPagEven">
                {MINICHAT_PREV}{MINICHAT_PAGENAV}{MINICHAT_NEXT}
            </div>
            <!-- ENDIF -->
        </div>
    </div>
</div>
<!-- END: CHAT -->
<div class="mcBottom">
    <a href="javascript:;" id="update" class="fl_r">{PHP.L.Update}</a>
    <a href="javascript:;" id="smilies">{PHP.L.Smilies}</a>
    <!-- BEGIN: MINICHAT_ERRORBLOCK -->
    <div class="error">{MINICHAT_ERROR} </div>
    <!-- END: MINICHAT_ERRORBLOCK -->
    <!-- BEGIN: MINICHAT_FORM -->
    <form action="{MINICHAT_FORM_SEND}" method="post" name="mcForm" id="mcForm">
        <div class="mcText <!-- IF {MINICHAT_FORM_PANEL} -->mcText{MINICHAT_FORM_PANEL} <!-- ENDIF -->fl_l">
            <div>
                <textarea id="shoutbox" name="shoutbox" onkeypress="if(event.keyCode==10||(event.ctrlKey && event.keyCode==13))$(this.form).submit();" placeholder="{PHP.L.minichat_yourmessage}"></textarea>
            </div>
        </div>
        <div class="mcSubmin <!-- IF {MINICHAT_FORM_PANEL} -->mcSubmin{MINICHAT_FORM_PANEL} <!-- ENDIF -->fl_l">
            <div>
                <input type="submit" value="OK" title="Ctrl + Enter" />
            </div>
        </div>
        <div class="clear"></div>
    </form>
    <!-- END: MINICHAT_FORM -->
</div>
<script type="text/javascript">
$(document).ready(function(){
    function mcFormAdd(name)
    {
        $('#shoutbox')[0].value += name;
        $('#shoutbox').focus();
    }
    mcAjax = {
        'widthEdit': 400,
        'heightEdit': 160,
        'pag': $('.mcHead').html(),
        'loading': '<span style="position:absolute;left:' + ($('#minichatajax').width()/2 - 110) + 'px;top:' + ($('#minichatajax').height()/2 - 9) + 'px;" class="loading" id="loading"><img src="./images/spinner.gif" alt="loading"/></span>'
    };
    $("#mcForm").live('submit', function(){
        if($('#shoutbox').val().length < {PHP.cfg.plugin.minichat.minichat_minchars})
        {
            alert('{PHP.L.minichat_short_message}');
            return false;
        }
        if($('#shoutbox').val().length > {PHP.cfg.plugin.minichat.minichat_maxchars})
        {
            alert('{PHP.L.minichat_long_message}');
            return false;
        }
        $.ajax(
            {
                type: 'POST',
                url: 'index.php?r=minichat&panel={MINICHAT_PANEL}',
                data: 'shoutbox=' + $('#shoutbox').val() + '&x={PHP.sys.xk}',
                beforeSend: function()
                {
                    $('.mcHead').text('Постинг..');
                    $('#minichatajax').append(mcAjax.loading);
                    $('#mcForm input[type="submit"]').attr('disabled', 'disabled');
                },
                success: function(data)
                {
                    $("#minichatajax").html(data);
                    $('#loading').remove();
                    $('#shoutbox').val('');
                    $('#mcForm input[type="submit"]').removeAttr('disabled', 'disabled');
                    $('.mcHead').html(mcAjax.pag);
                },
                error: function()
                {
                    alert('AJAX Error');
                    $('#loading').remove();
                    $('.mcHead').html(mcAjax.pag);
                    return true;
                }
            }
        );
        return false;
    });
    $('#update').live('click', function(){
        mcReload();
        return false;
    });
    <!-- IF {MINICHAT_TIMER} -->
    setInterval(function(){(d_var != 1) ? '' : mcReload();}, {MINICHAT_TIMER});
    <!-- ENDIF -->
    function mcReload()
    {
        $.ajax(
            {
                type: 'GET',
                url: 'index.php?r=minichat',
                data: 'panel={MINICHAT_PANEL}',
                beforeSend: function()
                {
                    $('.mcHead').text('{PHP.L.minichat_search_posts}');
                },
                success: function(data)
                {
                    $('#minichatajax').html(data);
                    $('.mcHead').html(mcAjax.pag);
                },
                error: function()
                {
                    alert('AJAX Error');
                    $('.mcHead').html(mcAjax.pag);
                    return true;
                }
            }
        );
    }
    $('.toUser').live('click', function(){
        mcFormAdd('[b]' + $(this).attr('rel') + '[/b], ');
        return false;
    });
    <!-- IF {PHP.cfg.plugin.minichat.minichat_markup} -->
    $('#smilies').live('click', function(){
        var perRow = smileBox.perRow;
        if($('#smileBox').length != 1)
        {
            var smileHtml = '<table class="cells" cellpadding="0">';
            for(i = 0; i < smileSet.length; i++)
            {
                if(i % perRow == 0)
                {
                    if(i != 0) smileHtml += '</tr>';
                    smileHtml += '<tr>';
                }
                code = smileSet[i].code;
                code = code.replace(/</g, '&lt;');
                code = code.replace(/>/g, '&gt;');
                smileHtml += '<td><a class="smlink" href="#" name="' + code + '" title="' + smileSet[i].lang + '"><img src="./images/smilies/' + smileSet[i].file + '" alt="' + code + '" /></a></td>';
            }
            if(i % perRow > 0)
            {
                for(j = i % perRow; j < perRow; j++)
                {
                    smileHtml += '<td>&nbsp;</td>';
                }
            }
            smileHtml += '</tr></table>';
            styleSm = 'margin-left:-' + (smileBox.width/2) + 'px;margin-top:-' + (smileBox.height/2) + 'px;width:' + smileBox.width + 'px;height:' + smileBox.height + 'px';
            $('body').append('<div id="smileBox" class="jqmWindow" style="' + styleSm + '"><h4>{PHP.L.Smilies}</h4>' + smileHtml + '<p><a href="#" class="jqmClose">{PHP.L.Close}</a></p></div>');
            $('#smileBox a.smlink').click(function(){
                mcFormAdd(' ' + $(this).attr('name') + ' ');
                return false;
            });
            $('#smileBox').jqm();
        }
        $('#smileBox').jqmShow();
        return false;
    });
    <!-- ENDIF -->
    <!-- IF {MINICHAT_ROW_ADMIN} -->
    $(".mcAjaxDelete").live('click', function(){
        $.ajax(
            {
                type: 'GET',
                url: 'index.php?r=minichat&panel={MINICHAT_PANEL}&del=' + $(this).attr('rel'),
                beforeSend: function()
                {
                    $('#minichatajax').append(mcAjax.loading);
                },
                success: function(data)
                {
                    $("#minichatajax").html(data);
                    $('#loading').remove();
                },
                error: function()
                {
                    alert('AJAX Error');
                    $('#loading').remove();
                    return true;
                }
            }
        );
        return false;
    });
    style = 'margin-left:-' + (mcAjax.widthEdit/2 + 10) + 'px;margin-top:-' + (mcAjax.heightEdit/2 + 30) + 'px;width:' + mcAjax.widthEdit + 'px;height:' + mcAjax.heightEdit + 'px';
    $('body').append('<div id="mcAjax" class="jqmWindow" style="' + style + '"><div></div><a href="#" class="jqmClose">{PHP.L.Close}</a></div>');
    $('#mcAjax').jqm();
    $('.mcAjaxEdit').live('click', function(){
        rel = $(this).attr('rel');
        $.ajax(
            {
                type: 'POST',
                url: 'index.php?r=minichat&edit=' + rel + '&x={PHP.sys.xk}',
                beforeSend: function(){
                    $('#minichatajax').append(mcAjax.loading);
                },
                success: function(data){
                    $("#mcAjax > div").html(data);
                    $('#loading').remove();
                    $('#mcAjax').jqmShow();
                }
            }
        );
        return false;
    });
    $("#mcFormEdit").live('submit', function(){
        $.ajax(
            {
                type: 'POST',
                url: 'index.php?r=minichat&edit=' + rel + '&a=update&x={PHP.sys.xk}',
                data: 'shoutbox=' + $('#mcFormEdit #shoutbox').val() + '&x={PHP.sys.xk}',
                beforeSend: function()
                {
                    $('#minichatajax').append(mcAjax.loading);
                },
                success: function()
                {
                    $('#loading').remove();
                    $('#mcAjax').jqmHide();
                    mcReload();
                },
                error: function(){
                    alert('AJAX Error');
                    $('#loading').remove();
                    return true;
                }
            }
        );
        return false;
    });
    <!-- ENDIF -->
});
</script>
<!-- END: MINICHAT -->
