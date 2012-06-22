/*
;首先获取所有好友的信息 friend 逐行显示
当好友没有的时候再去显示所有其它的好友
*/
class FriendDialog extends MyNode
{
    var cl;
    var flowNode;
    var friend = [["name0", 0], ["name1", 1], ["name2", 2], ["name3", 3], ["name4", 4], ["name5", 5], ["name6", 6], ["name7", 7], ["name8", 8], ["name9", 9]];

    const OFFX = 168;
    const OFFY = 165;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    //const HEIGHT = 159;
    const WIDTH = OFFX * ITEM_NUM;
    const HEIGHT = OFFY*ROW_NUM;
    function FriendDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("dialogFriendTitle.png").pos(60, 8);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        //482 45
        var but0 = bg.addsprite("roleNameBut0.png").pos(480, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, addFriend);
        but0.addlabel(getStr("addFriend", null), null, 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);
        
        //637 45
        var but1 = bg.addsprite("roleNameBut0.png").pos(635, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, sendGift);
        but1.addlabel(getStr("sendGift", null), null, 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        bg.addsprite("dialogNeibor.png").pos(396, 95).anchor(50, 50);

        cl = bg.addnode().pos(74, 120).size(WIDTH, HEIGHT-4).clipping(1);
        flowNode = cl.addnode();
        updateFlowNode();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
        
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
        var dify = lastPoints[1]-oldPos[1];

        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);
        accMove += abs(dify);
    }
    /*
    最小位置 当前 最大的行数 * 行偏移 + 总高度
    最大位置 0

    当整体高度小于显示高度的时候 向0 对齐
    */
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                global.director.popView();
                global.director.pushScene(new FriendScene());
                global.director.pushView(new VisitDialog(), 1, 0);
                return;
            }
        }
        var curPos = flowNode.pos();
        var rows = (len(friend)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
        flowNode.pos(curPos);
        updateFlowNode();
    }
    //getRange 显示 所有 行
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(friend)+ITEM_NUM-1)/ITEM_NUM;
        return [max(0, lowRow-1), min(rowNum, upRow+1)];
    }
    function updateFlowNode()
    {
        var colNum = len(friend);
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos).size(OFFX*colNum, HEIGHT);
        var rg = getRange();
        var curX = 0;
        //行号
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

                panel.addlabel(friend[curNum][0], null, 20).pos(66, 53).anchor(50, 50).color(0, 0, 0);
                panel.addsprite("roleLevel.png").pos(96, 80).anchor(50, 50).size(40, 40);
                panel.addlabel(str(friend[curNum][1]), null, 15).pos(96, 80).anchor(50, 50).color(0, 0, 0);
                panel.addlabel(getStr("get", null), null, 20, FONT_BOLD).pos(32, 22).anchor(0, 50).color(0, 0, 0);
                panel.addsprite("crystal.png").pos(85, 22).anchor(50, 50);
                panel.addlabel("4", null, 20).pos(100, 22).anchor(0, 50).color(0, 0, 0);
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
