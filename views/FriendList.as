/*
显示好友的信息:
id papayaId 
name 名字
level 等级 getLevel
得到用户的uid
*/
class FriendList extends MyNode
{
    const OFFX = 168;
    const OFFY = 165;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const WIDTH = OFFX * ITEM_NUM;
    const HEIGHT = OFFY*ROW_NUM;

    const PANEL_WIDTH = 154;
    const PANEL_HEIGHT = 160;

    //uid id level name 字典存储 推荐好友 木瓜  邻居数据
    //邻居包含额外的 水晶矿数据
    var data;
    var flowNode;
    var scene;
    var initYet;
    var selectNum;

    var friendKind;

    override function init()
    {
        super.init();
        selectNum = -1;
    }
    function initData()
    {
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
    //getRange 显示 所有 行
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }

    //showData = papayaFriendList 
    function updateTab()
    {
        if(data == null)//数据未初始化完成 则不更新列表
            return;


        var colNum = len(data);
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = bg.addnode().pos(oldPos);
        var rg = getRange();
        var curX = 0;
        //行号
        trace("updateTab", len(data), rg);



        for(var i = rg[0]; i < rg[1]; i++)
        {
            curX = 0;
            var curY = i*OFFY;
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= colNum)
                    break;

                var panel = flowNode.addsprite("dialogFriendPanel.png").pos(j*OFFX, curY);
                panel.put(curNum);

                var papayaId = data[curNum].get("id");


                if(data[curNum].get("uid") == ADD_NEIBOR_MAX)
                {
                    var head = panel.addsprite("loginQuestionMark.png").pos(68, 105).anchor(50, 50);

                }
                else if(data[curNum].get("uid") == EMPTY_SEAT)
                {
                }
                else
                {
                    panel.addsprite(avatar_url(papayaId)).anchor(50, 50).pos(69, 105);

                    var level = data[curNum].get("level");
                    var name = data[curNum].get("name");

panel.addlabel(name, "fonts/heiti.ttf", 20).pos(66, 53).anchor(50, 50).color(0, 0, 0);
                    panel.addsprite("roleLevel.png").pos(96, 80).anchor(50, 50).size(40, 40);

panel.addlabel(str(level + 1), "fonts/heiti.ttf", 15).pos(96, 80).anchor(50, 50).color(0, 0, 0);


                    //访问好友 清除其士兵的状态可以得到水晶 但是邻居
                    //随机的几个位置的好友有水晶 可以通过初始化数据列表的时候随机生成 data hasCrystal = 1
                    //数据有水晶可以
                    if(data[curNum].get("crystal") != null)
                    {
panel.addlabel(getStr("get", null), "fonts/heiti.ttf", 20, FONT_BOLD).pos(32, 22).anchor(0, 50).color(0, 0, 0);
                        panel.addsprite("crystal.png").pos(85, 22).anchor(50, 50).size(30, 30);
panel.addlabel(str(data[curNum].get("crystal")), "fonts/heiti.ttf", 20).pos(100, 22).anchor(0, 50).color(0, 0, 0);
                    }
                }

                if(curNum == selectNum)
                {
                    showShadow(panel);
                }
            }
        }
    }

    var lastPoints;
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        if(initYet == 1)
        {
            selectNum = -1;
            accMove = 0;
            lastPoints = n.node2world(x, y);
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        if(initYet == 1)
        {
            var oldPos = lastPoints;
            lastPoints = n.node2world(x, y);
            var dify = lastPoints[1]-oldPos[1];

            var curPos = flowNode.pos();
            curPos[1] += dify;
            flowNode.pos(curPos);
            accMove += abs(dify);
        }
    }

    /*
    点击士兵显示shadow页面 updateTab 之后显示
    */

    function updateData()
    {
    }
    function sureToAddMax()
    {
        global.httpController.addRequest("friendC/addNeiborMax", dict([["uid", global.user.uid]]), null, null);
        global.user.changeValue("neiborMax", 1);
        global.user.changeValue("gold", -ADD_MAX_CAE);

        updateData();
        //selectNum = -1;
        updateTab();
    }
    /*
    凯撒币不足
    */
    function onAddNeiborMax(n, e, curNum, x, y, points)
    {
        var cost = dict([["gold", ADD_MAX_CAE]]);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            global.director.pushView();
        }
        global.director.pushView(new MyWarningDialog(getStr("addNeiMaxTit", null), getStr("addNeiMaxCon", ["[NUM]", str(global.user.getValue("neiborMax")), "[CAE]", str(ADD_MAX_CAE)]), sureToAddMax), 1, 0);

        selectNum = -1;
        updateTab();
    }
    function onHelp()
    {
        selectNum = -1;
        updateTab();
    }
    function onSend(n, e, curNum, x, y, points)
    {
        var nei = data[curNum].get("uid");
        global.director.pushView(new GiftDialog(nei), 1, 0);
        selectNum = -1; 
        updateTab();
    }
    const SHADOW_WIDTH = 66;
    const BUT0_Y = 16;
    const BUT1_Y = 16+56;
    const BUT2_Y = 16+56+56;
    function showShadow(child)
    {
        var curNum = child.get();

        var uid = data[curNum].get("uid");
        if(uid == EMPTY_SEAT)
        {
            global.director.pushView(new MyWarningDialog(getStr("addNeiTit", null), getStr("addNeiCon", null), null), 1, 0);
            return;
        }
        var shadow;
        var but0;

        var pSize = child.prepare().size();
        shadow = sprite("dialogRankShadow.png").pos(pSize[0]/2, pSize[1]/2).anchor(50, 50).size(pSize[0], pSize[1]);
        child.add(shadow, 100, 1);
        shadow.put(curNum);

        if(uid == ADD_NEIBOR_MAX)
        {
            //shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
            //child.add(shadow, 100, 1);
            //shadow.put(curNum);

            but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT0_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onAddNeiborMax, curNum);
but0.addlabel(getStr("addNeiborMax", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);

            but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT1_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onHelp);
but0.addlabel(getStr("help", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
            return;
        }

        //shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
        //child.add(shadow, 100, 1);
        //shadow.put(curNum);

        //visit
        but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT0_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onVisit, curNum);
but0.addlabel(getStr("visit", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);

        //不是自己的邻居 则 添加邻居 
        //是自己的邻居 则 解除邻居

        
        //好友的uid数据没有被更新不显示添加邻居和删除邻居
        if(uid == -1)
        {
            return;
        }
        //send
        //访问邻居 赠送礼物 可以多次赠送
        if(friendKind == VISIT_NEIBOR)
        {
            but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT1_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onSend, curNum);
but0.addlabel(getStr("sendGift", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
        }
        /*
        if(friendKind == VISIT_RECOMMAND)
        {

            if(global.user.checkChallengeYet(uid) == 0)//挑战自身显示按钮 || uid == global.user.uid
            {
                but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT1_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onChallenge, curNum);
but0.addlabel(getStr("sendGift", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
            }
        }
        */

        //非邻居
        if(global.friendController.checkNeibor(uid) == null)
        {
            //没有发送过邻居请求
            if(global.friendController.checkRequest(uid) == null)
            {
                but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT2_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onAddNeibor, curNum);
but0.addlabel(getStr("addNeibor", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
            }
        }
        else//已经是邻居 没有发送过请求
        {
            if(global.friendController.checkRequest(uid) == null)
            {
                but0 = shadow.addsprite("greenButton.png").pos(SHADOW_WIDTH, BUT2_Y).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onRemoveNeibor, curNum);
but0.addlabel(getStr("removeNeibor", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
            }
        }
    }
    function onChallenge(n, e, curNum, x, y, points)
    {
        
    }
    //解除邻居关系不算发送请求
    function onRemoveNeibor(n, e, curNum, x, y, points)
    {
        global.httpController.addRequest("friendC/removeNeibor", dict([["uid", global.user.uid], ["fid", data[curNum].get("uid")]]), null, null);
        //global.friendController.sendRequest(data[curNum].get("uid"));
        global.friendController.removeNeibor(data[curNum].get("uid"));
        //清除选择
        selectNum = -1;
        updateData();
        updateTab();
    }
    /*
    发送过请求的用户不能再次发送
    */
    function clearShadow()
    {
        selectNum = -1;
        updateTab();
    }
    /*
    问题是不知道B的名额是否满了只有发送请求过去得到返回值才会知道
    */
    function onAddNeibor(n, e, curNum, x, y, points)
    {
        var neiborMax = global.user.getValue("neiborMax");
        var curNeiborNum = global.friendController.getNeiborNum();
        if(curNeiborNum >= neiborMax)
        {
            global.director.pushView(new MyWarningDialog(getStr("neiborFullTit", null), getStr("neiborFullCon", null), sureToAddMax), 1, 0);
        }
        else
        {
            global.httpController.addRequest("friendC/sendNeiborRequest", dict([["uid", global.user.uid], ["fid", data[curNum].get("uid")]]), sendRequestOver, null);
            global.friendController.sendRequest(data[curNum].get("uid"));
        }
        clearShadow();
    }
    function sendRequestOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con.get("id") == 0)
            {
                var status = con.get("status");
                if(status == 1)
                {
                    global.director.pushView(new MyWarningDialog(getStr("friNeiFullTit", null), getStr("friNeiFullCon", null), null), 1, 0);
                }
            }
        }
    }

    function onVisit(n, e, curNum, x, y, points)
    {
        global.director.popView();
        //var curNum = child.get();
        var papayaId = data[curNum].get("id");
        var friendScene = new FriendScene(papayaId, curNum, friendKind, data[curNum].get("crystal"), data[curNum]);
        global.director.pushScene(friendScene);
        global.director.pushView(new VisitDialog(friendScene), 1, 0);
    }
    /*
    最小位置 当前 最大的行数 * 行偏移 + 总高度
    最大位置 0

    当整体高度小于显示高度的时候 向0 对齐

    好友页面的 papayaId fid level 名字
    */
    function touchEnded(n, e, p, x, y, points)
    {
        if(initYet == 1)
        {
            var newPos = n.node2world(x, y);
            if(accMove < 10)
            {
                var child = checkInChild(flowNode, newPos);
                if(child != null)
                {
                    selectNum = child.get();
                }
            }
            var curPos = flowNode.pos();
            var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
            curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
            flowNode.pos(curPos);
            updateTab();
        }
    }

}
