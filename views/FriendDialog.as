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

                    panel.addlabel(name, null, 20).pos(66, 53).anchor(50, 50).color(0, 0, 0);
                    panel.addsprite("roleLevel.png").pos(96, 80).anchor(50, 50).size(40, 40);

                    panel.addlabel(str(level), null, 15).pos(96, 80).anchor(50, 50).color(0, 0, 0);


                    //访问好友 清除其士兵的状态可以得到水晶 但是邻居
                    //随机的几个位置的好友有水晶 可以通过初始化数据列表的时候随机生成 data hasCrystal = 1
                    //数据有水晶可以
                    if(data[curNum].get("crystal") != null)
                    {
                        panel.addlabel(getStr("get", null), null, 20, FONT_BOLD).pos(32, 22).anchor(0, 50).color(0, 0, 0);
                        panel.addsprite("crystal.png").pos(85, 22).anchor(50, 50).size(30, 30);
                        panel.addlabel(str(data[curNum].get("crystal")), null, 20).pos(100, 22).anchor(0, 50).color(0, 0, 0);
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
        if(uid == ADD_NEIBOR_MAX)
        {
            shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
            child.add(shadow, 100, 1);
            shadow.put(curNum);

            but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onAddNeiborMax, curNum);
            but0.addlabel(getStr("addNeiborMax", null), null, 21).pos(47, 19).anchor(50, 50);

            but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onHelp);
            but0.addlabel(getStr("help", null), null, 21).pos(47, 19).anchor(50, 50);
            return;
        }

        shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
        child.add(shadow, 100, 1);
        shadow.put(curNum);

        but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onVisit, curNum);
        but0.addlabel(getStr("visit", null), null, 21).pos(47, 19).anchor(50, 50);

        //不是自己的邻居 则 添加邻居 
        //是自己的邻居 则 解除邻居

        
        //好友的uid数据没有被更新不显示添加邻居和删除邻居
        if(uid == -1)
        {
            return;
        }
        //访问邻居 赠送礼物 可以多次赠送
        if(friendKind == VISIT_NEIBOR)
        {
            but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onSend, curNum);
            but0.addlabel(getStr("sendGift", null), null, 21).pos(47, 19).anchor(50, 50);
        }

        //非邻居
        if(global.friendController.checkNeibor(uid) == null)
        {
            //没有发送过邻居请求
            if(global.friendController.checkRequest(uid) == null)
            {
                but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onAddNeibor, curNum);
                but0.addlabel(getStr("addNeibor", null), null, 21).pos(47, 19).anchor(50, 50);
            }
        }
        else//已经是邻居 没有发送过请求
        {
            if(global.friendController.checkRequest(uid) == null)
            {
                but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, onRemoveNeibor, curNum);
                but0.addlabel(getStr("removeNeibor", null), null, 21).pos(47, 19).anchor(50, 50);
            }
        }
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

//根据 用户的邻居上限
class Neibor extends FriendList
{
    function Neibor(p, s, sc)
    {
        friendKind = VISIT_NEIBOR;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode();
        initData();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    //正常获取数据之后 更新座位数据
    //水晶在数据初始化的时候生成
    function showEmptySeat()
    {
        data = global.friendController.getNeibors();
        //setCrystal();//只在邻居数据中增加水晶
        data = copy(data);

        var neiborMax = global.user.getValue("neiborMax");

        if(neiborMax > len(data))
        {
            for(var i = 0; i < (neiborMax-len(data)); i++)
                data.append(dict([["uid", EMPTY_SEAT], ["id", -1], ["name", getStr("emptySeat", null)], ["level", 0]]));
        }
        //增加邻居上限
        data.append(dict([["uid", ADD_NEIBOR_MAX], ["id", -1], ["name", getStr("addNeiborMax", null)], ["level", 0]]));
        trace("neiborMax", neiborMax, len(data));
    }
    override function updateData()
    {
        showEmptySeat();
    }

    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initNeiborYet == 1 && data == null)
        {
            data = global.friendController.getNeibors();
            initYet = 1;
            updateData();
            updateTab();
        }
    }

    override function initData()
    {
        data = global.friendController.getNeibors();
        if(data == null)
        {
            initYet = 0;
        }
        else 
        {
            initYet = 1;
            updateData();
            updateTab();
        }
    }
}
class PapayaFriend extends FriendList
{
    function PapayaFriend(p, s, sc)
    {
        friendKind = VISIT_PAPAYA;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode();
        initData();


        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }



    override function initData()
    {
        data = global.friendController.getPapayaList();
        if(data == null)
        {
            initYet = 0;
        }
        else
        {
            initYet = 1;
            //setCrystal();
            updateTab();
        }
    }


    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initFriend == 1 && data == null)
        {
            data = global.friendController.getPapayaList();
            //setCrystal();
            initYet = 1;
            updateTab();
        }
    }
}
class Recommand extends FriendList
{
    function Recommand(p, s, sc)
    {
        friendKind = VISIT_RECOMMAND;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode();
        initData();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }


    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initYet == 1 && data == null)
        {
            data = global.friendController.getRecommand();
            initYet = 1;
            trace("getRecommand", data);
            updateTab();
        }
    }

    override function initData()
    {
        data = global.friendController.getRecommand();
        trace("getRecommand", data);
        if(data == null)
        {
            initYet = 0;
        }
        else
        {
            initYet = 1;
            updateTab();
        }
    }
}
/*
;首先获取所有好友的信息 friend 逐行显示
当好友没有的时候再去显示所有其它的好友
*/
class FriendDialog extends MyNode
{
    //var cl;
    //var flowNode;
    //var friend;//FriendControler

    const OFFX = 168;
    const OFFY = 165;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const WIDTH = OFFX * ITEM_NUM;
    const HEIGHT = OFFY*ROW_NUM;
    

    var views;
    var curSel = -1;

    var titles = ["dialogNeibor.png", "dialogPapa.png", "dialogRec.png"];
    var showTitle;
    function FriendDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        //initData();
        bg.addsprite("dialogFriendTitle.png").pos(60, 8);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        var but1 = bg.addsprite("roleNameBut0.png").pos(350, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, switchView, 0);
        but1.addlabel(getStr("showNeibor", null), null, 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        but1 = bg.addsprite("roleNameBut0.png").pos(500, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, switchView, 1);
        but1.addlabel(getStr("showPapaya", null), null, 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        var but0 = bg.addsprite("roleNameBut0.png").pos(650, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, switchView, 2);
        but0.addlabel(getStr("recFriend", null), null, 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        showTitle = bg.addsprite("dialogNeibor.png").pos(396, 95).anchor(50, 50);
        
        var po = [74, 120];
        var sz = [WIDTH, HEIGHT-4];

        var nei = new Neibor(po, sz, this);
        var paf = new PapayaFriend(po, sz, this);
        var rec = new Recommand(po, sz, this);
        views = [nei, paf, rec];
        
        switchView(null, null, 0, null, null, null);

    }
    function switchView(n, e, sel, x, y, points)
    {
        if(curSel != sel)
        {
            if(curSel != -1)
                views[curSel].removeSelf();
            curSel = sel;

            addChild(views[curSel]);
            showTitle.texture(titles[curSel]);
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
    var showRefresh = null;
    function update(diff)
    {
        if(curSel != -1)
        {
            //trace("initYet", views[curSel].initYet);
            if(views[curSel].initYet != 1)
            {
                if(showRefresh == null)
                {
                    showRefresh = bg.addsprite().addaction(repeat(animate(2000, "feed0.png", "feed1.png","feed2.png","feed3.png","feed4.png","feed5.png","feed6.png","feed7.png"))).anchor(50, 50).pos(402, 239);
                }
            }
            else
            {
                if(showRefresh != null )
                {
                    showRefresh.removefromparent();
                }
            }
        }
    }

    function closeDialog()
    {
        global.director.popView();
    }
    function addFriend()
    {
    }
    function sendGift()
    {
    }
}
