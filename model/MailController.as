class MailController 
{
    var mail = [];
    //未读取的mail
    //已经读取mail
    //mail 类型  内容 处理方式
    //kind = 0 好友请求
    //kind = 1 解除好友请求
    var initYet = null;
    var mailId = 0;

    function MailController()
    {
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(INITDATA_OVER, this);
    }

    //获取邻居信息
    //获取好友赠送的礼物
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == INITDATA_OVER)//获取邮件信息 显示剩余的邮件数量
        {
            initYet = 0;
            global.httpController.addRequest("friendC/getMessage", dict([["uid", global.user.uid]]), getNeiborRequestOver, null);
            global.httpController.addRequest("goodsC/getGift", dict([["uid", global.user.uid]]), getGiftOver, null);
            global.httpController.addRequest("friendC/getUserMessage", dict([["uid", global.user.uid]]), getMessageOver, null);
        }
    }


    function getMail()
    {
        trace("mail", mail);
        if(initYet != 1)
            return null;
        return mail;
    }
    var initMessage = 0;
    function getMessageOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var msg = con["msg"];
            for(var i = 0; i < len(msg); i++)
            {
                var d = dict();
                for(var j = 0; j < len(MSG_KEY); j++)
                {
                    d.update(MSG_KEY[j], msg[i][j]);
                }
                d.update("mailId", mailId++);
                mail.append([OTHER_MSG, d]);
            }
            initMessage = 1;
        }
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
                var d = dict();
                for(var j = 0; j < len(NEIBOR_REQ_KEY); j++)
                {
                    d.update(NEIBOR_REQ_KEY[j], req[i][j]);
                }
                d.update("mailId", mailId++);
                mail.append([NEIBOR_REQ, d]);
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
                var d = dict();
                for(var j = 0; j < len(GIFT_KEY); j++)
                {
                    d.update(GIFT_KEY[j], gifts[i][j]);
                }
                d.update("mailId", mailId++);
                mail.append([GIFT_REQ, d]);
            }
            initGiftYet = 1;
        }
    }
    function readMail(mid)
    {
        for(var i = 0; i < len(mail); i++)
        {
            if(mail[i][1]["mailId"] == mid)
            {
                mail.pop(i);
                break;
            }
        }
    }

    //kind  
    //uid papayaId name level
    //每次读取mail 也要发送消息
    function update(diff)
    {
        if(initNeiborRequestYet == 1 && initGiftYet == 1 && initMessage && initYet == 0)
        {
            initYet = 1;
            global.msgCenter.sendMsg(UPDATE_MAIL, null);
        }
    }
    function getMailNum()
    {
        return len(mail);
    }
}
