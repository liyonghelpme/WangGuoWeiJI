class RankDialog extends MyNode
{
    var cl;
    var flowNode;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const OFFX = 166;
    const OFFY = 179;
    const PANEL_WIDTH = 154;
    const PANEL_HEIGHT = 167;
    const HEIGHT = ROW_NUM*OFFY;
    //显示高度 和 移动高度不同
    /*
    点击clip的对象 移动 flowNode 对象
    计算上下行范围
    更新显示的内容
    */
    var rank = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9]];
    function RankDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("dialogRankTitle.png").pos(66, 7);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        var but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37);
        but0.addlabel(getStr("heroRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);

        but0 = bg.addsprite("roleNameBut0.png").pos(505, 24).size(96, 37);
        but0.addlabel(getStr("groupRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);

        but0 = bg.addsprite("roleNameBut0.png").pos(620, 24).size(96, 37);
        but0.addlabel(getStr("newRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);


        cl = bg.addnode().pos(66, 96).size(665, 346).clipping(1);
        flowNode = cl.addnode();
        updateTab();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var lastPoints;
    var accMove;
    //var selectedChild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        selectNum = -1;
        /*
        if(selectN != null)
        {
            trace("touchBegan");
            selectedChild.remove(1);
            //selectedChild = null;
            selectNum = -1;
        }
        */
        accMove = 0;
        lastPoints = n.node2world(x, y);
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

    /*
    touch 对象 cl
    检测的是 flowNode 的 孩子节点
    */
    function showShadow(child)
    {
        var shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
        trace("child", child, shadow);
        child.add(shadow, 100, 1);
        var but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, doVisit);
        but0.addlabel(getStr("visit", null), null, 21).pos(47, 19).anchor(50, 50);
        but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+40+16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeHero);
        but0.addlabel(getStr("challengeHero", null), null, 21).pos(47, 19).anchor(50, 50);
        but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeGroup);
        but0.addlabel(getStr("challengeGroup", null), null, 21).pos(47, 19).anchor(50, 50);
        //selectedChild = child;
    }
    function challengeHero()
    {
    }
    function challengeGroup()
    {
    }
    function doVisit()
    {
        global.director.popView();
        global.director.pushScene(new FriendScene());
        global.director.pushView(new VisitDialog(), 1, 0);
    }

    var selectNum = -1;
    /*
    确定选择子节点编号
    在updateTab 如果刷新子节点则在此子节点上显示shadow
    */
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {   
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                selectNum = child.get();
                /*
                var shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
                trace("child", child, shadow);
                child.add(shadow, 100, 1);
                var but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40);
                but0.addlabel(getStr("visit", null), null, 21).pos(47, 19).anchor(50, 50);
                but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+40+16).anchor(50, 0).size(95, 40);
                but0.addlabel(getStr("challengeHero", null), null, 21).pos(47, 19).anchor(50, 50);
                but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40);
                but0.addlabel(getStr("challengeGroup", null), null, 21).pos(47, 19).anchor(50, 50);
                selectedChild = child;
                */
            }
        }
        var curPos = flowNode.pos();
        var rows = (len(rank)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(rank)+ITEM_NUM-1)/ITEM_NUM;
        return [max(0, lowRow-1), min(rowNum, upRow+1)];
    }
    function updateTab()
    {
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);
        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= len(rank))
                    break;
                var panel = flowNode.addsprite("dialogFriendPanel.png").size(PANEL_WIDTH, PANEL_HEIGHT).pos(j*OFFX, i*OFFY);
                panel.addsprite("dialogRankCup.png").anchor(50, 50).pos(35, 23);
                panel.addlabel(str(rank[curNum][1]), null, 20).anchor(50, 50).pos(88, 23).color(0, 0, 0);
                panel.put(curNum);
                if(curNum == selectNum)
                {
                    showShadow(panel);
                }
            }
        }
    }
}
