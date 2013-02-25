class FriendList extends MyNode
{
    var initYet;
    var data;
    var cl;
    var flowNode;

    const OFFX = 170;//offx
    const OFFY = 187;//offy
    const ITEM_NUM = 4;//in
    const ROW_NUM = 2;//rn
    const WIDTH = 704;
    const HEIGHT = 331;
    const PANEL_HEIGHT = 156;//默认图片大小
    const PANEL_WIDTH = 144;
    const INIT_X = 70;//第一个面板的x y 值
    const INIT_Y = 131;

    var scene;
    var selectNum = -1;
    var friendKind;
    /*
    function FriendList(s)
    {
        scene = s;
        bg = node();
        init();
        initData();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    */
    //子类构造时无法初始化父类成员 因此需要显式初始化
    override function init()
    {
        super.init();
        selectNum = -1;
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

    function update(diff)
    {
    }

    function initData()
    {
    } 

    function updateData()
    {
    }

    var lastPoints;
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        removed = 0;
        accMove = 0;
        lastPoints = n.node2world(x, y);
        selectNum = -1;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];

        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);
        accMove += abs(dify);
    }

    //数据未初始化
    function touchEnded(n, e, p, x, y, points)
    {
        if(data == null)    
            return;
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                selectNum = child.get();
                var uid = data[selectNum]["uid"];
                if(uid == INVITE_FRIEND)
                {
                    global.director.pushView(new InviteDialog(), 1, 0);
                }
            }
        }
        var curPos = flowNode.pos();
        trace("data", len(data));
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    //修正好友数据的编号
    //otherPlayer： 第一格子显示 邀请好友图标 所以需要手动修正-1
    //邻居页面不需要修正 因为邻居的空位功能图标在后面
    //或者 查找用户的 UID 来确定位置
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    const PAN_OFFY = 5;
    function updateTab()
    {
        if(data == null)//数据未初始化完成 则不更新列表
            return;

        var oldPos = flowNode.pos();    
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        //trace("data", data);
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= len(data))
                    break;

                var panel = flowNode.addsprite("dialogFriendPanel.png").pos(j*OFFX, i*OFFY+PAN_OFFY).size(PANEL_WIDTH, PANEL_HEIGHT); 
                panel.put(curNum);

                var papayaId = data[curNum].get("id");
                var level = data[curNum].get("level", 0);
                var name = data[curNum].get("name");
                
                if(data[curNum].get("uid") == ADD_NEIBOR_MAX)
                {
panel.addlabel(getStr("addSeat", null), getFont(), 18).anchor(50, 50).pos(77, 135).color(43, 25, 9);
                    panel.addsprite("addSeat.png").anchor(50, 50).pos(73, 86).size(46, 44).color(100, 100, 100, 100);
                }
                else if(data[curNum].get("uid") == EMPTY_SEAT)
                {
                    panel.addsprite("friendBlock.png").anchor(50, 50).pos(74, 82).size(getParam("blockSize"), getParam("blockSize")).color(100, 100, 100, 100);
                    panel.addsprite("unkownFriendHead.png").anchor(0, 0).pos(47, 55).size(55, 55).color(100, 100, 100, 100);
panel.addlabel(getStr("addPlayerNeibor", null), getFont(), 18).anchor(50, 50).pos(75, 135).color(43, 25, 9);
                }
                else if(data[curNum]["uid"] == INVITE_FRIEND)
                {
                    panel.addsprite("unkownFriendHead.png").anchor(0, 0).pos(47, 55).size(55, 55).color(100, 100, 100, 100);
panel.addlabel(getStr("inviteFriend", null), getFont(), 18).anchor(50, 50).pos(75, 135).color(43, 25, 9);
                }
                else if(friendKind == VISIT_NEIBOR || friendKind == VISIT_OTHER)
                {
                    panel.addsprite("friendBlock.png").anchor(50, 50).pos(74, 82).size(getParam("blockSize"), getParam("blockSize")).color(100, 100, 100, 100);

                    panel.addsprite(avatar_url(papayaId)).anchor(50, 50).pos(74, 82).size(55, 55).color(100, 100, 100, 100);
panel.addlabel(name, getFont(), 20).anchor(50, 50).pos(76, 132).color(43, 25, 9);

                    if(data[curNum].get("crystal") != null)
                    {
                        var temp = picNumWord(getStr("getCrystal", ["[KIND]", "crystal.png"]), 22, [28, 15, 4], 1).pos(74, 22).anchor(50, 0);//文字相对于node是0 50
                        panel.add(temp);
                    }

                    panel.addsprite("levelStar.png").anchor(0, 0).pos(85, 41).size(31, 31).color(100, 100, 100, 100);
panel.addlabel(str(level + 1), getFont(), 15).anchor(50, 50).pos(101, 58).color(0, 0, 0);
                }

                if(curNum == selectNum)
                {
                    showShadow(panel);
                }
                
            }
        }
    }
    function onAddGoldSeat()
    {
        var cost = dict([["gold", getParam("addSeatGold")]]);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            var it = cost.items();
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]), [100, 100, 100], null));
            return;
        }

        global.httpController.addRequest("friendC/addNeiborMax", dict([["uid", global.user.uid], ["gold", cost["gold"]]]), null, null);
        global.user.changeValue("neiborMax", 1);
        global.user.doCost(cost);

        showMultiPopBanner(cost2Minus(cost));

        updateData();
        clearShadow();
    }
    function onSearchPlayer()
    {
        clearShadow();
        global.director.pushView(new SearchDialog(), 1, 0);
    }
    function onOtherPlayer()
    {
        scene.switchView(1);
    }

    var removed = 0;
    function onRemoveNeibor(curNum)
    {
        if(removed == 0)
        {
            removed = 1;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("touchRemoveNeibor", null), [100, 100, 100], null));
        }
        else
        {
            removed = 0;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("relationBreak", ["[NAME]", data[curNum]["name"]]), [100, 100, 100], null));
            global.httpController.addRequest("friendC/removeNeibor", dict([["uid", global.user.uid], ["fid", data[curNum].get("uid")]]), null, null);
            global.friendController.removeNeibor(data[curNum].get("uid"));
            updateData();
            clearShadow();
        }
    }
    function onSendGift(curNum)
    {
        var nei = data[curNum].get("uid");
        global.director.pushView(new GiftDialog(nei), 1, 0);
        clearShadow();
    }
    function onVisit(curNum)
    {
        global.director.popView();
        var papayaId = data[curNum].get("id");
        //修正好友的编号
        var friendScene = new FriendScene(papayaId, data[curNum]["curNum"], friendKind, data[curNum].get("crystal"), data[curNum]);
        global.director.emptyScene.addChildZ(friendScene, -1);
        global.director.pushView(new VisitDialog(friendScene, scene.kind), 1, 0);
    }

    function clearShadow()
    {
        selectNum = -1;
        updateTab();
    }
    function onAddNeibor(curNum)
    {
        var neiborMax = global.user.getValue("neiborMax");
        var curNeiborNum = global.friendController.getNeiborNum();
        if(curNeiborNum >= neiborMax)
        {
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("neiborFullCon", null), [100, 100, 100], null));
        }
        else
        {
            global.httpController.addRequest("friendC/sendNeiborRequest", dict([["uid", global.user.uid], ["fid", data[curNum].get("uid")]]), null, null);
            global.friendController.sendRequest(data[curNum].get("uid"));
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("neiReqSuc", null), [100, 100, 100], null));
            global.taskModel.doAllTaskByKey("sendNeiborRequest", 1);
        }
        clearShadow();
    }
    function showShadow(child)
    {
        var curNum = child.get();

        var uid = data[curNum].get("uid");
        var shadow;
        var but0;

        if(uid == INVITE_FRIEND)
        {
            return;
        }
        shadow = child.addnode();
        shadow.addsprite("dialogFriendShadow.png").anchor(50, 50).pos(73, 78).size(144, 164).color(100, 100, 100, 100);
        if(uid == ADD_NEIBOR_MAX)
        {
            but0 = new NewButton("roleNameBut0.png", [129, 39], getStr("addGoldSeat", ["[KIND]", "gold.png", "[NUM]", str(getParam("addSeatGold"))]), null, 18, FONT_NORMAL, [100, 100, 100], onAddGoldSeat, curNum);
            but0.bg.pos(72, 82);
            shadow.add(but0.bg);
        }
        else if(uid == EMPTY_SEAT)
        {
            but0 = new NewButton("roleNameBut0.png", [92, 39], getStr("searchPlayer", null), null, 18, FONT_NORMAL, [100, 100, 100], onSearchPlayer, curNum);
            but0.bg.pos(72, 115);
            shadow.add(but0.bg);

            but0 = new NewButton("roleNameBut0.png", [92, 39], getStr("otherPlayer", null), null, 18, FONT_NORMAL, [100, 100, 100], onOtherPlayer, curNum);
            but0.bg.pos(72, 56);
            shadow.add(but0.bg);
        }
        else if(uid == INVITE_FRIEND)
        {
        }
        else if(friendKind == VISIT_NEIBOR)
        {
            but0 = new NewButton("roleNameBut0.png", [92, 39], getStr("removeNeibor", null), null, 18, FONT_NORMAL, [100, 100, 100], onRemoveNeibor, curNum);
            but0.bg.pos(72, 130);
            shadow.add(but0.bg);

            but0 = new NewButton("roleNameBut0.png", [92, 39], getStr("sendGift", null), null, 18, FONT_NORMAL, [100, 100, 100], onSendGift, curNum);
            but0.bg.pos(72, 82);
            shadow.add(but0.bg);

            but0 = new NewButton("roleNameBut0.png", [92, 39], getStr("visit", null), null, 18, FONT_NORMAL, [100, 100, 100], onVisit, curNum);
            but0.bg.pos(73, 33);
            shadow.add(but0.bg);
        }
        else if(friendKind == VISIT_OTHER)
        {

            var ret = global.friendController.checkRequest(uid);
            but0 = new NewButton("violetBut.png", [92, 39], getStr("addNeibor", null), null, 18, FONT_NORMAL, [100, 100, 100], onAddNeibor, curNum);
            but0.bg.pos(72, 115);
            shadow.add(but0.bg);
            if(ret)
            {
                but0.setGray();
                but0.setCallback(null);
            }

            but0 = new NewButton("violetBut.png", [92, 39], getStr("visit", null), null, 18, FONT_NORMAL, [100, 100, 100], onVisit, curNum);
            but0.bg.pos(72, 56);
            shadow.add(but0.bg);
        }
    }
}
