class GiftView extends MyNode
{
    const OFFY = 62;
    const ROW_NUM = 5;
    const PANEL_WIDTH = 784;
    const PANEL_HEIGHT = 60;
    const ITEM_NUM = 1;
    const HEIGHT = OFFY*ROW_NUM;


    //name object number
    var data = [["haha", "crystal", 4], ["haha", "silver", 4],["haha", "gold", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4],["haha", "crystal", 4]]; 
    var flowNode;
    var initYet = 1;

    function initData()
    {
    }
    var cl;
    var giftNum;
    function GiftView(p, s)
    {
        bg = node();
giftNum = bg.addlabel(getStr("howManyGift", null), getFont(), 25).color(100, 100, 100).pos(26, 103);
        var but0 = bg.addsprite("greenButton0.png").pos(623, 87).size(148, 53).setevent(EVENT_TOUCH, receiveAll);
but0.addlabel(getStr("recAll", null), getFont(), 25).color(0, 0, 0).anchor(50, 50).pos(74, 26);

        init();
        initData();
        cl = bg.addnode().pos(p).size(s).clipping(1); 
        flowNode = cl.addnode();
        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function updateGiftNum()
    {
        giftNum.text(getStr("howManyGift", ["[NUM]", str(len(data))]));
    }
    function receiveAll()
    {
        for(var i = 0; i < len(data); i++)
        {
            global.user.changeValue(data[i][1], data[i][2]);
        }
        data = [];
        updateTab();
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
        }
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
        flowNode.pos(curPos);
        updateTab();
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
        updateGiftNum();
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i).size(PANEL_WIDTH, PANEL_HEIGHT);
panel.addlabel(getStr("friSendGift", ["[NAME]", data[i][0], "[NUM]", str(data[i][2]), "[KIND]", getStr(data[i][1], null)]), getFont(), 25).pos(42, 20).anchor(0, 0).color(78, 78, 78);
            panel.addsprite(data[i][1]+".png").pos(556, 13).size(30, 30);
            var but0 = panel.addsprite("greenButton0.png").pos(640, 8).size(119, 42).setevent(EVENT_TOUCH, onReceive, i);
but0.addlabel(getStr("receive", null), getFont(), 22).color(0, 0, 0).pos(60, 21).anchor(50, 50);
        }
    }
    function onReceive(n, e, p, x, y, points)
    {
        var res = data.pop(p);
        global.user.changeValue(res[1], res[2]);
        updateTab();
    }
}

class MoreView extends MyNode
{
    const OFFY = 96;
    const ROW_NUM = 4;
    const PANEL_WIDTH = 786;
    const PANEL_HEIGHT = 90;
    const ITEM_NUM = 1;
    const HEIGHT = OFFY*ROW_NUM;

    //desc
    var data = [["desc"], ["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"]];
    var flowNode;
    var initYet = 1;
    function initData()
    {
    }
    function MoreView(p, s)
    {
        bg = node().pos(p).size(s).clipping(1); 
        init();
        initData();
        flowNode = bg.addnode();
        updateTab();
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
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
        }
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
        flowNode.pos(curPos);
        updateTab();
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
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i).size(PANEL_WIDTH, PANEL_HEIGHT);
panel.addlabel(data[i][0], getFont(), 25).pos(122, 20).anchor(0, 0).color(78, 78, 78);
            var but0 = panel.addsprite("greenButton0.png").pos(636, 30).size(118, 45).setevent(EVENT_TOUCH, onDownload, i);
but0.addlabel(getStr("download", null), getFont(), 22).color(0, 0, 0).pos(59, 22).anchor(50, 50);
        }
    }
    function onDownload(n, e, p, x, y, points)
    {
    }

}
