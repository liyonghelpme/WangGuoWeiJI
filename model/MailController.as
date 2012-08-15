class MailController 
{
    var mail = [];
    //未读取的mail
    //已经读取mail
    //mail 类型  内容 处理方式
    //kind = 0 好友请求
    //kind = 1 解除好友请求
    var initYet = null;

    function MailController()
    {
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(INITDATA_OVER, this);
    }

    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == INITDATA_OVER)//获取邮件信息 显示剩余的邮件数量
        {
            initYet = 0;
            global.httpController.addRequest("friendC/getMessage", dict([["uid", global.user.uid]]), getNeiborRequestOver, null);
            global.httpController.addRequest("goodsC/getGift", dict([["uid", global.user.uid]]), getGiftOver, null);
        }
    }

    function getMail()
    {
        trace("mail", mail);
        return mail;
    }
    var initNeiborRequestYet = 0;
    //uid papayaId name level
    function getNeiborRequestOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var req = con.get("req");
            for(var i = 0; i < len(req); i++)
            {
                mail.append([NEIBOR_REQ, req[i]]);
            }
            initNeiborRequestYet = 1;
        }
    }

    var initGiftYet = 0;
    //获取所有的请求礼物信息之后
    //uid name kind tid level time
    function getGiftOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var gifts = con.get("gifts");
            for(var i = 0; i < len(gifts); i++)
            {
                mail.append([GIFT_REQ, gifts[i]]);
            }
            initGiftYet = 1;
        }
    }

    //kind  
    //uid papayaId name level
    /*
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
            getNeiborRequest = 1;
            initYet = 1;
        }
    }
    */

    function update(diff)
    {
        if(initNeiborRequestYet == 1 && initGiftYet == 1)
        {
            initYet = 1;
        }
    }
}
