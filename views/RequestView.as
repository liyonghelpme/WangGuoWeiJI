class RequestView extends MyNode
{
    const OFFY = 62;
    const ROW_NUM = 6;
    const PANEL_WIDTH = 784;
    const PANEL_HEIGHT = 60;
    const ITEM_NUM = 1;
    const HEIGHT = OFFY*ROW_NUM;


    //name object number
    var data = null;
    var flowNode;
    var cl;
    var initYet = 0;
    
    function RequestView(p, s)
    {
        bg = node();
        init();
        cl = bg.addnode().pos(p).size(s).clipping(1); 
        flowNode = cl.addnode();
        initData();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function initData()
    {
        data = global.mailController.getMail();
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
    function update(diff)
    {
        if(data == null && global.mailController.initYet == 1)
        {
            data = global.mailController.getMail();
            initYet = 1;
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
        if(initYet == 1)
        {
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
    最小位置 当前 最大的行数 * 行偏移 + 总高度
    最大位置 0

    当整体高度小于显示高度的时候 向0 对齐
    */
    function touchEnded(n, e, p, x, y, points)
    {
        if(initYet == 1)
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
        if(initYet == 0)
            return;

        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i).size(PANEL_WIDTH, PANEL_HEIGHT);
            panel.addlabel(getStr("neiborRequest", ["[NAME]", data[i][1][2]]), null, 25).pos(42, 20).anchor(0, 0).color(78, 78, 78);

            var but0 = panel.addsprite("greenButton.png").pos(500, 8).size(119, 42).setevent(EVENT_TOUCH, onReceive, i);
            but0.addlabel(getStr("receive", null), null, 22).color(0, 0, 0).pos(60, 21).anchor(50, 50);

            but0 = panel.addsprite("greenButton.png").pos(640, 8).size(119, 42).setevent(EVENT_TOUCH, onRefuse, i);
            but0.addlabel(getStr("refuse", null), null, 22).color(0, 0, 0).pos(60, 21).anchor(50, 50);
        }
    }

    //请求由对方发送过来 接受和 拒绝的uid 和 fid 需要是相反的
    //uid papayaId name level
    function onReceive(n, e, p, x, y, points)
    {
        var res = data.pop(p);
        global.httpController.addRequest("friendC/acceptNeibor", dict([["uid", global.user.uid], ["fid", res[1][0]]]), acceptOver, res[1]);
        updateTab();
    }
    function acceptOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con.get("id") == 1)//结邻居成功
            {
                global.friendController.addNeibor(dict([["uid", param[0]], ["id", param[1]], ["name", param[2]], ["level", param[3]]])); 
            }
            else
            {
                var status = con.get("status");
                if(status == 0)
                {
                    global.director.pushView(new MyWarningDialog(getStr("accRequestError", null), getStr("noUser", null), null), 1, 0);
                }
                else if(status == 1)
                {
                    global.director.pushView(new MyWarningDialog(getStr("accRequestError", null), getStr("yourNeiborMax", null), null), 1, 0);
                }
                else if(status == 2)
                    global.director.pushView(new MyWarningDialog(getStr("accRequestError", null), getStr("friNeiborMax", null), null), 1, 0);
                else if(status == 3)
                    global.director.pushView(new MyWarningDialog(getStr("accRequestError", null), getStr("neiborYet", null), null), 1, 0);
            }
        }
    }
    function onRefuse(n, e, p, x, y, points)
    {
        var res = data.pop(p);
        global.httpController.addRequest("friendC/acceptNeibor", dict([["uid", global.user.uid], ["fid", res[1][0]]]), null, null);
        updateTab();
    }
}

