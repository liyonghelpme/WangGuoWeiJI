class FloatPanelTemplate extends MyNode 
{
    var flowNode;
    var data;

    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const OFFX = 166;
    const OFFY = 179;
    const PANEL_WIDTH = 154;
    const PANEL_HEIGHT = 167;
    const HEIGHT = ROW_NUM*OFFY;


    function initData()
    {
        data = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9]];
    }

    function FloatPanelTemplate(p, s)
    {
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode(); 
        initData();
        updateTab();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }



    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }

    function updateTab()
    {
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = bg.addnode().pos(oldPos);
        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= len(data))
                    break;
                var panel = flowNode.addsprite("dialogFriendPanel.png").size(PANEL_WIDTH, PANEL_HEIGHT).pos(j*OFFX, i*OFFY);
                panel.addsprite("dialogRankCup.png").anchor(50, 50).pos(35, 23);
panel.addlabel(str(data[curNum][1]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(88, 23).color(0, 0, 0);
                panel.put(curNum);
                if(curNum == selectNum)
                {
                    showShadow(panel);
                }
            }
        }
    }

    var lastPoints;
    var accMove;
    var selectNum = -1;

    function touchBegan(n, e, p, x, y, points)
    {
        selectNum = -1;

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




    function touchEnded(n, e, p, x, y, points)
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


    /*
    touch 对象 cl
    检测的是 flowNode 的 孩子节点
    */

    function showShadow(child)
    {
        var shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
//        trace("child", child, shadow);
        child.add(shadow, 100, 1);
        var but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, doVisit);
but0.addlabel(getStr("visit", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
        but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+40+16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeHero);
but0.addlabel(getStr("challengeHero", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
        but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeGroup);
but0.addlabel(getStr("challengeGroup", null), "fonts/heiti.ttf", 21).pos(47, 19).anchor(50, 50);
        //selectedChild = child;
    }



    function challengeHero()
    {
        global.director.popView();
        global.director.pushScene(new BattleScene(5, 0, 
[[1, 0], [1, 10], [1, 20], [1, 30], [1, 40], [1, 50], [1, 60], [1, 70], [1, 80], [1, 90], [1, 100], [1, 110], [1, 120], [1, 130], [1, 140], [1, 150], [1, 160], [1, 170], [1, 180], [1, 190]]
        ));
    }
    function challengeGroup()
    {
        global.director.popView();
        //map 5 挑战页面
        global.director.pushScene(new BattleScene(5, 0,  
[[1, 0], [1, 10], [1, 20], [1, 30], [1, 40], [1, 50], [1, 60], [1, 70], [1, 80], [1, 90], [1, 100], [1, 110], [1, 120], [1, 130], [1, 140], [1, 150], [1, 160], [1, 170], [1, 180], [1, 190]]

        ));
    }
    function doVisit()
    {
        global.director.popView();
        global.director.pushScene(new FriendScene());
        global.director.pushView(new VisitDialog(), 1, 0);
    }

}
