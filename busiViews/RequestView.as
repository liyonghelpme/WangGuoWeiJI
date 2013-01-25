/*
将显示数据 和 内部 消息数据 分离
onRefuse
onReceive

onGift
onMsg

发送清理内部数据信息
*/
class RequestView extends MyNode
{

    const OFFX = 0;//offx
    const OFFY = 63;//offy
    const ITEM_NUM = 1;//in
    const ROW_NUM = 5;//rn
    const WIDTH = 789;
    const HEIGHT = 315;
    const PANEL_HEIGHT = 63;//默认图片大小
    const PANEL_WIDTH = 789;
    const INIT_X = 8;//第一个面板的x y 值
    const INIT_Y = 155;


    //name object number
    var data = null;
    var flowNode;
    var cl;
    var initYet = 0;
    var giftNum;

    var recAllBut;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        but0 = new NewButton("greenButton0.png", [132, 49], getStr("recAll", null), null, 23, FONT_NORMAL, [100, 100, 100], receiveAll, null);
        but0.bg.pos(704, 115);
        addChild(but0);
        recAllBut = but0;

        giftNum = bg.addlabel(getStr("howManyGift", null), "fonts/heiti.ttf", 25).anchor(0, 50).pos(25, 115).color(100, 100, 100);
        temp = bg.addsprite("friendWhiteBack.png").anchor(0, 0).pos(8, 155).size(785, 315).color(100, 100, 100, 100);
    }
    
    function RequestView(p, s)
    {
        initView();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1); 
        flowNode = cl.addnode();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
        //setGiftNum();
    }
    function receiveAll()
    {
        if(data == null)
            return;
        for(var i = 0; i < len(data); i++)
        {
            if(data[i][0] == GIFT_REQ)
            {
                receiveGift(i);
            }
        }
        setGiftNum();
        updateTab();
    }
    function setVisualData()
    {
        data = [];
        var temp = global.mailController.getMail();
        for(var i = 0; i < len(temp); i++)
        {
            data.append([temp[i][0], temp[i][1], 0]);//KIND data readYet    
        }

    }
    //KIND data handled?
    function initData()
    {
        data = global.mailController.getMail();
        //initYet = 1;
        //updateTab();
        if(data == null)
        {
            initYet = 0;
        }
        else
        {
            setVisualData();
            initYet = 1;
            updateTab();
            setGiftNum();
        }
    }
    function update(diff)
    {
        if(data == null && global.mailController.initYet == 1)
        {
            setVisualData();
            initYet = 1;
            updateTab();
            setGiftNum();
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
        var temp;
        var sca;
        var but0;
        var TestTime = getclass("com.liyong.testTime.TestTime");
        var now;


        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addnode().size(PANEL_WIDTH, PANEL_HEIGHT).pos(0, OFFY*i);
            panel.addsprite("messageSeperate.png").pos(-1, 60);
            now = TestTime.callobj("getTime", data[i][1]["time"]);
            var readYet = data[i][2];
            if(data[i][0] == NEIBOR_REQ)
            {
                if(!readYet)
                {
                    but0 = new NewButton("greenButton0.png", [75, 36], getStr("cancel", null), null, 20, FONT_NORMAL, [100, 100, 100], onRefuse, i);
                    but0.bg.pos(723, 30);
                    panel.add(but0.bg);
                    but0 = new NewButton("greenButton0.png", [76, 36], getStr("agree", null), null, 20, FONT_NORMAL, [100, 100, 100], onReceive, i);
                    but0.bg.pos(634, 29);
                    panel.add(but0.bg);
                }

                panel.addlabel(getStr("neiborRequest", ["[NAME]", data[i][1]["name"], "[YEAR]", str(now["year"]), "[MON]", str(now["mon"]), "[DAY]", str(now["day"]), "[HOUR]", str(now["hour"]), "[MIN]", str(now["min"])]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(26, 30).color(54, 51, 51);

            }
            //uid name kind tid level time
            else if(data[i][0] == GIFT_REQ)
            {
                var uName = data[i][1]["name"];
                var gKind = data[i][1]["kind"];
                var gId = data[i][1]["tid"];
                var gLevel = data[i][1]["eqLevel"];
                var objData = getData(gKind, gId);
                if(gKind == EQUIP)
                {
                    panel.addlabel(getStr("friSendEquip", ["[NAME]", uName, "[ENAME]", objData["name"], "[LEVEL]", str(gLevel), "[YEAR]", str(now["year"]), "[MON]", str(now["mon"]), "[DAY]", str(now["day"]), "[HOUR]", str(now["hour"]), "[MIN]", str(now["min"])]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(26, 30).color(54, 51, 51);
                }
                else
                {

                    panel.addlabel(getStr("friSendOthers", ["[NAME]", uName, "[ONAME]", objData["name"], "[YEAR]", str(now["year"]), "[MON]", str(now["mon"]), "[DAY]", str(now["day"]), "[HOUR]", str(now["hour"]), "[MIN]", str(now["min"])]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(26, 30).color(54, 51, 51);
                }

                if(!readYet)
                {
                    but0 = new NewButton("greenButton0.png", [75, 36], getStr("receive", null), null, 20, FONT_NORMAL, [100, 100, 100], onGift, i);
                    but0.bg.pos(722, 30);
                    panel.add(but0.bg);
                }
            }
            else if(data[i][0] == OTHER_MSG)
            {
                var okKind = data[i][1]["kind"];
                if(okKind == PARAMS["MSG_CHALLENGE"])
                {
                    var robNum = json_loads(data[i][1]["param"]);
                    panel.addlabel(getStr("robCrystal", ["[NAME]", data[i][1]["name"], "[SIL]", str(robNum["silver"]), "[CRY]", str(robNum["crystal"]), "[YEAR]", str(now["year"]), "[MON]", str(now["mon"]), "[DAY]", str(now["day"]), "[HOUR]", str(now["hour"]), "[MIN]", str(now["min"])]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(26, 30).color(54, 51, 51);
                }
                if(!readYet)
                {
                    but0 = new NewButton("greenButton0.png", [75, 36], getStr("revenge", null), null, 20, FONT_NORMAL, [100, 100, 100], onRevange, i);
                    but0.bg.pos(722, 30);
                    panel.add(but0.bg);
                }

            }
            if(readYet)
            {
                panel.addlabel(getStr("handled", null), "fonts/heiti.ttf", 20, FONT_ITALIC).anchor(0, 50).pos(691, 31).color(54, 51, 51);
            }
        }
    }
    function setGiftNum()
    {
        if(data == null)
            return;
        var count = 0;
        for(var i = 0; i < len(data); i++)
        {
            if(data[i][0] == GIFT_REQ && data[i][2] == 0)
            {
                count++;
            }
        }
        if(count == 0)
        {
            recAllBut.setGray();
            recAllBut.setCallback(null);
        }
        else 
        {
            recAllBut.setWhite();
            recAllBut.setCallback(receiveAll);
        }
        giftNum.text(getStr("howManyGift", ["[NUM]", str(count)]));
    }
    function receiveGift(p)
    {
        var fid = data[p][1]["uid"];
        var gKind = data[p][1]["kind"];
        var gId = data[p][1]["tid"];
        var gLevel = data[p][1]["eqLevel"];
        var ti = data[p][1]["time"];
        var readYet = data[p][2];
        if(readYet)
            return;
        data[p][2] = 1;
        global.mailController.readMail(data[p][1]["mailId"]);
        if(gKind == EQUIP)
        {
            var eid = global.user.getNewEid();
            global.httpController.addRequest("goodsC/receiveGift", dict([["uid", global.user.uid], ["fid", fid], ["gid", data[p][1]["gid"] ], ["eid", eid]]), null, null);
            global.user.getNewEquip(eid, gId, gLevel);
        }
        //药水 材料 宝石 魔法石
        else
        {
            global.httpController.addRequest("goodsC/receiveGift", dict([["uid", global.user.uid], ["fid", fid], ["gid", data[p][1]["gid"]], ["eid", 0]]), null, null);
            global.user.changeGoodsNum(gKind, gId, 1);
        }

    }
    function onGift(p)
    {
        receiveGift(p);
        setGiftNum();
        updateTab();
    }
    //发送消息 接受消息使用time作为id 
    //即 uid fid 同1s钟只能发送一个消息
    //打开宝箱 赠送爱心 邻居请求 1s1次请求
    function onMsg(p)
    {
        var res = data[p];
        if(res[2] == 1)
            return;
        res[2] = 1;
        global.mailController.readMail(data[p][1]["mailId"]);
        updateTab();
        
        //挑战消息不需要同步服务器 在用户登录的时候 就已经删除了消息 同时扣除了资源
        if(res[1]["needRead"] == null)
        {
            global.httpController.addRequest("friendC/readMessage", dict([["uid", global.user.uid], ["fid", res[1]["uid"]], ["mid", res[1]["mid"]]]), null, null);
        }
    }
    function onRevange(p)
    {
        var res = data[p];
        if(res[2] == 1)
            return;
        res[2] = 1;
        global.mailController.readMail(data[p][1]["mailId"]);
        updateTab();
        global.director.popView();
        
        //挑战消息不需要同步服务器 在用户登录的时候 就已经删除了消息 同时扣除了资源
        var cs = new ChallengeScene(null, null, null, null, CHALLENGE_REVENGE, res[1]);
        global.director.pushScene(cs);
    }

    //请求由对方发送过来 接受和 拒绝的uid 和 fid 需要是相反的
    //uid papayaId name level
    function onReceive(p)
    {
        var res = data[p];
        if(res[2])
            return;
        res[2] = 1;
        global.mailController.readMail(data[p][1]["mailId"]);
        global.httpController.addRequest("friendC/acceptNeibor", dict([["uid", global.user.uid], ["fid", res[1]["uid"]]]), acceptOver, res[1]);
        updateTab();
    }
    function acceptOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con.get("id") == 1)//结邻居成功
            {
                global.friendController.addNeibor(dict([["uid", param["uid"]], ["id", param["papayaId"]], ["name", param["name"]], ["level", param["level"]]])); 
            }
            else
            {
                var status = con.get("status");
                if(status == 0)
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("noUser", null), [100, 100, 100], null));        
                else if(status == 1)
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("yourNeiborMax", null), [100, 100, 100], null));        
                else if(status == 2)
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("friNeiborMax", null), [100, 100, 100], null));        
                else if(status == 3)
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("neiborYet", null), [100, 100, 100], null));        
            }
        }
    }
    function onRefuse(p)
    {
        var res = data[p];
        if(res[2])
            return;
        res[2] = 1;
        global.mailController.readMail(data[p][1]["mailId"]);
        global.httpController.addRequest("friendC/refuseNeibor", dict([["uid", global.user.uid], ["fid", res[1]["uid"]]]), null, null);
        updateTab();
    }
}

