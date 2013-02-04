class InviteList extends MyNode
{
    var data;
    var cl;
    var flowNode;

    const OFFX = 155;
    const OFFY = 0;
    const ITEM_NUM = 4;
    const ROW_NUM = 1;
    const WIDTH = 609;
    const HEIGHT = 170;
    const PANEL_HEIGHT = 156;
    const PANEL_WIDTH = 144;
    const INIT_X = 93;
    const INIT_Y = 174;

    var scene;
    var initYet = 0;
    function InviteList(s)
    {
        scene = s;
        bg = node();
        init();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        //updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
    }
    //显示数据和内部数据分开
    function initData()
    {
        data = global.friendController.getInviteList();
        if(data == null)
        {
            initYet = 0;
        }
        else
        {
            data = copy(data);
            initYet = 1;
            updateTab();
        }
    } 
    function update(diff)
    {
        if(global.friendController.initInvite && data == null)
        {
            initYet = 1;
            data = global.friendController.getInviteList();
            data = copy(data);
            updateTab();
        }
    }

    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

    var lastPoints;
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];

        var curPos = flowNode.pos();
        curPos[0] += difx;
        flowNode.pos(curPos);
        accMove += abs(difx);
    }

    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
            }
        }
        var curPos = flowNode.pos();
        var cols = (len(data)+ROW_NUM-1)/ROW_NUM;
        curPos[0] = min(0, max(-cols*OFFX+WIDTH, curPos[0]));
        flowNode.pos(curPos);
        updateTab();
    }
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowCol = -curPos[0]/OFFX;
        var upCol = (-curPos[0]+WIDTH+OFFY-1)/OFFX;
        var colNum = (len(data)+ROW_NUM-1)/ROW_NUM;
        return [max(0, lowCol-ITEM_NUM), min(colNum, upCol+ITEM_NUM)];
    }
    //如果用户清空数据 重新邀请 就有刷银币的可能性 这个需要小心
    function updateTab()
    {
        if(data == null)
            return;

        var oldPos = flowNode.pos();    
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ROW_NUM; j++)
            {
                var curNum = i*ROW_NUM+j;
                if(curNum >= len(data))
                    break;

                var panel = flowNode.addsprite("dialogFriendPanel.png").pos(i*OFFX, j*OFFY).size(PANEL_WIDTH, PANEL_HEIGHT); 
                panel.put(curNum);

                var papayaId = data[curNum].get("id");
                var name = data[curNum].get("name");
                panel.addsprite("friendBlock.png").anchor(50, 50).pos(74, 82).size(55, 55).color(100, 100, 100, 100);
                panel.addlabel(name, "fonts/heiti.ttf", 16).anchor(50, 50).pos(76, 25).color(28, 15, 4);
                panel.addsprite(avatar_url(papayaId)).anchor(50, 50).pos(74, 82).size(55, 55).color(100, 100, 100, 100);
                if(data[curNum].get("invited", 0) == 0)
                {
                    var but0 = new NewButton("violetBut.png", [92, 33], getStr("invite", null), null, 18, FONT_NORMAL, [100, 100, 100], onInvite, curNum);
                    but0.bg.pos(77, 152);
                    panel.add(but0.bg);
                }
                else
                {
                    panel.addlabel(getStr("sendSuc", null), "fonts/heiti.ttf", 15).anchor(0, 50).pos(48, 135).color(28, 15, 4);
                    panel.addsprite("hook.png").anchor(0, 0).pos(14, 120).size(31, 26).color(100, 100, 100, 100);
                    panel.addlabel(getStr("reward10Sil", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(74, 180).color(43, 25, 9);
                }
            }
        }
    }
    //服务器mongodb 检测是否已经邀请过该玩家
    function onInvite(curNum)
    {
        var papayaId = data[curNum]["id"];
        ppy_query("send_notification", dict([["message", getStr("inviteGame", null)], ["uid", papayaId]]), null);
        global.httpController.addRequest("friendC/inviteFriend", dict([["uid", global.user.uid], ["oid", papayaId], ["silver", getParam("inviteRewardSilver")]]), inviteSuc, null);
        global.friendController.inviteFriend(papayaId);
        data[curNum]["invited"] = 1;
        updateTab();
        global.taskModel.doAllTaskByKey("inviteFriend", 1);
    }
    function inviteSuc(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con["id"] != 0)
            {
                var gain = dict([["silver", getParam("inviteRewardSilver")]]);
                global.user.doAdd(gain);
            }
        }
    }
}
