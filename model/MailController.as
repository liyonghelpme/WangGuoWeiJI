class MailController 
{
    var mail = null;
    //未读取的mail
    //已经读取mail
    //mail 类型  内容 处理方式
    //kind = 0 好友请求
    //kind = 1 解除好友请求
    var initYet = null;

    function MailController()
    {
        global.msgCenter.registerCallback(INITDATA_OVER, this);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == INITDATA_OVER)//获取邮件信息 显示剩余的邮件数量
        {
            initYet = 0;
            global.httpController.addRequest("friendC/getMessage", dict([["uid", global.user.uid]]), getMessageOver, null);
        }
    }
    function getMail()
    {
        trace("mail", mail);
        return mail;
    }
    //kind  
    //uid papayaId name level
    function getMessageOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var req = con.get("req");
            mail = [];
            for(var i = 0; i < len(req); i++)
            {
                mail.append([NEIBOR_REQ, req[i]]);
            }
            initYet = 1;
        }
    }

}
