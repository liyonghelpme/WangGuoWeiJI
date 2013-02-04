class MoreView extends MyNode
{
    var initYet = 1;

    const OFFX = 0;//offx
    const OFFY = 100;//offy
    const ITEM_NUM = 1;//in
    const ROW_NUM = 4;//rn
    const WIDTH = 785;
    const HEIGHT = 384;
    const PANEL_HEIGHT = 97;//默认图片大小
    const PANEL_WIDTH = 785;
    const INIT_X = 8;//第一个面板的x y 值
    const INIT_Y = 85;



    //desc
    var data = [["desc"], ["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"],["desc"]];
    var cl;
    var flowNode;
    function initData()
    {
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("moreWhiteBack.png").anchor(0, 0).pos(8, 85).size(785, 384).color(100, 100, 100, 100);
    }
    function MoreView(p, s)
    {
        initView();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
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
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        var temp;
        var sca;
        var but0;
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addnode().size(PANEL_WIDTH, PANEL_HEIGHT).pos(0, OFFY*i);
            temp = panel.addsprite("messageSeperate.png").anchor(0, 0).pos(0, 98).size(784, 3).color(100, 100, 100, 100);

            temp = panel.addsprite("gameIcon.png").anchor(50, 50).pos(52, 50).color(100, 100, 100, 100);
            sca = getSca(temp, [72, 71]);
            temp.scale(sca);
            panel.addlabel(data[i][0], "fonts/heiti.ttf", 20).anchor(0, 50).pos(118, 54).color(54, 51, 51);
            but0 = new NewButton("greenButton0.png", [103, 37], getStr("download", null), null, 20, FONT_NORMAL, [100, 100, 100], onDownload, i);
            but0.bg.pos(700, 52);
            panel.add(but0.bg);
        }
    }
    function onDownload(p)
    {
    }

}
