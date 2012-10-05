
class GloryDialog extends MyNode
{
    
    var cl;
    var flowNode;
    const INIT_X = 97;
    const INITY_Y = 152;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const OFFX = 157;
    const OFFY = 149;
    const WIDTH = OFFX*ITEM_NUM;
    const HEIGHT = OFFY*ROW_NUM;

    const PANEL_WIDTH = 110;
    const PANEL_HEIGHT = 138;

    /*
    当前拥有的士兵类型
    hashmap 0  ---> level >
    排序 按照 决定显示
    id level
    0 1 2 3 ----> name 
    10 11 12 13 ---> name 

    但是glory 这个数据格式可能本身依赖于多个关联关系
    所以应该在游戏初始化的时候初始化模板
    接着后续来动态填充数据
    */
    var glory = [[0, -1], [10, -1], [20, -1], [30, -1], [40, -1], [50, -1], [60, -1], [70, -1], [80, -1], [90, -1], [100, -1], [110, -1], [120, -1], [130, -1], [140, -1], [150, -1], [160, -1], [170, -1], [180, -1], [190, -1]];
    /*
    glory 可能由多个部分组成:
     例如士兵数据， 任务完成状态， 用户的其它数据
     总的长度在初始化glory列表的时候完成

    初始化可以如下：
            第一次使用初始化 glory 模板
            初始化 glory数据

    */
    function initGlory()
    {
        var map = dict();
        var soldiers = global.user.soldiers;
        var it = soldiers.values();
        for(var i = 0; i < len(it); i++)
        {
            var id = it[i].get("id");
            var level = id%10;
            id = id-level;

            var val = map.get(id, -1);
            if(val < level)
                map.update(id, level);
        }
        it = map.items();
//        trace("gloryMap", map);
        for(i = 0; i < len(it); i++)
        {
            id = it[i][0]/10;
            id *= 10;
            glory[it[i][0]/10] = [id, it[i][1]]; 
        }
    }

    function GloryDialog()
    {
        initGlory();

        bg = sprite("dialogGlory.jpg");
        init();
        bg.addsprite("closeBut.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
bg.addlabel("B+", "fonts/heiti.ttf", 40).pos(85, 98).anchor(50, 50).color(43, 24, 11);
bg.addlabel(getStr("collectRole", null), "fonts/heiti.ttf", 30).pos(389, 106).anchor(50, 50).color(43, 24, 11);

        cl = bg.addnode().pos(97, 152).size(630, 298).clipping(1);
        flowNode = cl.addnode();
        updateTab();


        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = (len(glory)+ITEM_NUM-1)/ITEM_NUM;
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
                if(curNum >= len(glory))
                    break;
                var sca = PANEL_WIDTH*100/165;
                var panel = flowNode.addsprite("soldierPanel.png").scale(sca).pos(j*OFFX, i*OFFY);
                var id = glory[curNum][0];
                var level = glory[curNum][1];
                //var data = getData(SOLDIER, id+level);
                if(level == -1)
                    panel.addsprite("soldier"+str(id)+".png", BLACK).pos(83, 110).anchor(50, 50);
                else
                    panel.addsprite("soldier"+str(id+level)+".png").pos(83, 110).anchor(50, 50);

                var initX = 33;
                var initY = 186;
                for(var k = 0; k < 4; k++)
                {
                    var filter = WHITE;
                    if(k > level)
                        filter = GRAY;
                    if(k < 3)
                        panel.addsprite("soldierLev0.png", filter).pos(initX, initY).anchor(50, 50);
                    else
                        panel.addsprite("soldierLev1.png", filter).pos(initX, initY).anchor(50, 50);
                    initX += 30;
                }
            }
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
//        trace("oldPos", lastPoints, oldPos);
        var dify = lastPoints[1] - oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);
        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowNode.pos();
        var rows = (len(glory)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(curPos[1], -rows*OFFY+HEIGHT));
        flowNode.pos(curPos);
        updateTab();
    }

}
