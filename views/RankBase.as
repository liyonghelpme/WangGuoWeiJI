class RankBase extends MyNode 
{
    var flowNode;
    //uid papayaId score rank
    var data = [];

    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const OFFX = 166;
    const OFFY = 175;
    const PANEL_WIDTH = 154;
    const PANEL_HEIGHT = 160;
    const HEIGHT = ROW_NUM*OFFY;

    var initYet = 0;
    const FETCH_NUM = 16;
    const MIN_LIMIT = 8;
    
    //var startOff;

    var maxRank = 9999999;
    //预测得到的最大的数据范围
    var preMax;

    function getUserRow()
    {
        var rankOrder = global.user.rankOrder;
        var rowBegin = rankOrder/ITEM_NUM;
        return rowBegin;
    }
    /*

    function getUserItem()
    {
        var rowBegin = getUserRow();
        var beginItem = rowBegin*ITEM_NUM;
        preMax = beginItem+FETCH_NUM;
        initYet = 0;
        trace("initDataOver", initYet, beginItem, preMax);
        global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", beginItem], ["limit", FETCH_NUM]]), getDataOver, null);
    }

    //offset of Array
    //得到用户的初始化行 以及
    function initData()
    {
        data = [];
        getUserItem();
        //var rankOrder = global.user.rankOrder;
        //global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", rankOrder], ["limit", 16]]), getDataOver, null);
        //starOff = rankOrder;
        //data = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9]];
    }

    //如何给并列的用户排序？
    //根据rank范围得到需要的用户？
    //rankOrder - 8
    //rankOrder + 8
    function getDataOver(rid, rcode, con, param)
    {
        //uid papayaId score rank
        if(rcode != 0)
        {
            con = json_loads(con);
            data = con.get("res");
            initYet = 1;
            var beginItem = data[0][3];
            trace("initRank", data, -beginItem*OFFY);
            if(data[len(data)-1][3] < (preMax-1))
                maxRank = data[len(data)-1][3];
            flowNode.pos(0, -beginItem*OFFY);
            updateTab();
        }
    }
    */
    var lock = null;

    function update(diff)
    {
        if(initYet == 0)
        {
            if(lock == null)
            {
                var sz = bg.size();
                lock = sprite().pos(sz[0]/2, sz[1]/2).anchor(50, 50).addaction(
                repeat(
                    animate(1000, "feed0.png", "feed1.png", "feed2.png", "feed3.png", "feed4.png", "feed5.png", "feed7.png" )
                )); 
                bg.add(lock, 10);
            }
        }
        else
        {
            if(lock != null)
            {
                lock.removefromparent();
                lock = null;
            }
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

    var scene;
    var flowLayer;
    function RankBase(p, s, sc)
    {
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();

        var row = global.user.rankOrder/ITEM_NUM;
        flowNode = bg.addnode().pos(0, -row*OFFY); 


        updateTab();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }


    /*
    排名是连续的
    根据当前位置计算排名
    根据数据开始排名 和 结束排名 
   

    拖动的数据返回的数据必须是连续的可以直接拼接
    */
    const MAX_BUFFER = 100;
    function getRankOver(rid, rcode, con, param)
    {
        var temp;
        var i;
        trace("getRankOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            con = json_loads(con);

            if(param == 1)
            {
                data += con.get("res");
                trace("param1", data);
                if(data[len(data)-1][3] < (preMax-1))
                {
                    maxRank = data[len(data)-1][3];   
                }
                if(len(data) > MAX_BUFFER)
                {
                    temp = [];
                    for(i = len(data)/2; i < len(data); i++)
                        temp.append(data[i]);
                    data = temp;
                }
            }
            else if(param == 0)
            {
                data = con.get("res")+data;
                trace("param0", data);
                if(len(data) > MAX_BUFFER)
                {
                    temp = [];
                    for(i = 0; i < len(data)/2; i++)
                        temp.append(data[i]);
                    data = temp;
                }
                    
            }
            initYet = 1;
            fetchData = 0;
            trace("getRankDataOver", data);
            trace("getRankDataOver", len(data));
            updateTab();
        }
    }

    //清空数据获得最底端
    function onUp()
    {
        if(initYet == 1)
        {
            //data = [];
            flowNode.pos(0, 0);
            updateTab();
        }
    }
    //清空数据 获取最顶端
    function onDown()
    {
        if(initYet == 1)
        {
            //data = [];
            var rowBegin = global.user.rankOrder/ITEM_NUM;   
            flowNode.pos(0, -rowBegin*OFFY);
            updateTab();
        }
    }

    const MAX_FETCH = 50;
    //记录是否正在获取数据
    //同一时间只能进行一个数据获取
    var fetchData = 0;
    function getShowRangeAndBufferRange()
    {
        var curPos = flowNode.pos();
        //显示范围
        var lowRow = max(-curPos[1]/OFFY, 0);
        var upRow = min((-curPos[1]+HEIGHT+OFFY-1)/OFFY, (maxRank+ITEM_NUM-1)/ITEM_NUM);
        var rowNum = (maxRank+ITEM_NUM-1)/ITEM_NUM;

        var myRow = global.user.rankOrder/ITEM_NUM;
        if(lowRow < myRow)
        {
            scene.upArrow.scale(100, -100).setevent(EVENT_TOUCH, onDown);
        }
        else
        {
            scene.upArrow.scale(100, 100).setevent(EVENT_TOUCH, onUp);
        }

        //缓存范围
        var beginRank = max(lowRow*ITEM_NUM-FETCH_NUM, 0);
        var endRank = min(upRow*ITEM_NUM+FETCH_NUM, maxRank);

        if(len(data) > 0)
        {
            //判定显示范围是否足够 不足进入更新状态
            var beginItem = data[0][3];
            var endItem = data[len(data)-1][3];
            if(beginItem > beginRank || endItem < endRank)
                initYet = 0;

            trace("getShowRangeAndBufferRange", "maxRank", maxRank, "lowRow", lowRow, "upRow", upRow, "rowNum", rowNum, beginRank, endRank, beginItem, endItem, "fetchData",fetchData, "initYet",initYet);
        }
        trace("data", data);
        var limit;
        //获取缓存数据
        //当前的数据范围 如果data 为空 0 - 0 [-1, 0) 显示范围
        if(fetchData == 0)//如果没有获取数据则获取缓存数据
        {
            //如果beginRank 和 beginItem 或者 endRank 和 endItem 相差悬殊 则 清空数据 重新获得数据
            
            //缓存区域 与 当前数据没有交集
            if(len(data) > 0 && (beginItem > endRank || beginRank > endItem))
            {
                data = [];
            }

            if(len(data) == 0)//计算整个缓存范围
            {
                limit = endRank - beginRank;
                fetchData = 1;
                initYet = 0;
                preMax = endRank;
                global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, 0);

            }
            //获取缓存数据 判定显示数据足够则继续显示 否则停止显示更新
            else
            {

                //如果没有超出范围 则 尽量获取FETCH_NUM 的数据 
                if(beginItem > beginRank && beginItem > 0)//上部缓存数据不足 且上部没有到达顶部
                {
                    beginRank = min(beginRank, max(beginItem-FETCH_NUM, 0));
                    limit = beginItem-beginRank;
                    fetchData = 1;
                    global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, 0);
                }
                else if(endRank > endItem && endItem < maxRank)//下部缓存数据不足 且下部没有到达最后
                {
                    endRank = min(max(endRank, endItem+FETCH_NUM), maxRank);
                    limit = endRank-endItem;
                    fetchData = 1;
                    preMax = endRank;
                    global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, 1);
                }
            }
        }

        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    /*
    maxRank 所有数据已经获取 同一时刻 只能进行一个数据获取
    */
    /*
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;

        var rowNum = (maxRank+ITEM_NUM-1)/ITEM_NUM;

        var beginItem = max(0, lowRow-ROW_NUM)*ITEM_NUM;
        var endItem = (upRow+ROW_NUM)*ITEM_NUM;
        
        var beginRank = data[0][3];
        var endRank = data[len(data)-1][3];
        var limit;
        trace("beginRank", beginRank, endRank, beginItem, endItem, maxRank);

        if(beginRank > beginItem)
        {
            beginItem = min(beginItem, max(beginRank-FETCH_NUM, 0));
            limit = beginRank - beginItem;  
            global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", beginItem], ["limit", limit]]), getRankOver, 0);
            initYet = 0;
        }

        else if(endRank < endItem && endRank < maxRank)
        {
            endItem = max(min(endRank+FETCH_NUM, maxRank), endItem);
            limit = endItem-endRank;
            preMax = endItem;
            global.httpController.addRequest("challengeC/getRank", dict([["uid", global.user.uid], ["offset", endRank], ["limit", limit]]), getRankOver, 1);
            initYet = 0;
        }
        //计算data data[0][3] 是开始的rank编号
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    */

    /*
    如果新的数据不能显示 initYet == 0
    则停止更新tab 
    */
    function updateTab()
    {
        //var rg = getRange();
        var rg = getShowRangeAndBufferRange();
        var oldPos = flowNode.pos();
        trace("updateTab", initYet, fetchData, rg, oldPos);
        if(initYet == 0)
            return;


        flowNode.removefromparent();
        flowNode = bg.addnode().pos(oldPos);

        var begin = data[0][3];
        var end = data[len(data)-1][3]+1;
        //curNum 就是rank排名
        //uid papayaId score rank name
        for(var i = rg[0]; i < rg[1]; i++)
        {
            for(var j = 0; j < ITEM_NUM; j++)
            {
                var curNum = i*ITEM_NUM+j;
                if(curNum >= end)
                    break;
                var diff = curNum-begin;
                if(diff < 0)
                    break;
                var panel = flowNode.addsprite("dialogFriendPanel.png").pos(j*OFFX, i*OFFY);
                var sca = getSca(panel, [PANEL_WIDTH, PANEL_HEIGHT]);
                panel.scale(sca);

                panel.addsprite("dialogRankCup.png").anchor(50, 50).pos(35, 23);
                panel.addlabel(str(data[diff][3]), null, 20).anchor(50, 50).pos(88, 23).color(0, 0, 0);
                
                var papayaId = data[diff][1];
                panel.addsprite(avatar_url(papayaId)).anchor(50, 50).pos(69, 105);
                panel.addlabel(data[diff][4], null, 20).anchor(50, 50).pos(66, 53).color(0, 0, 0);

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
    /*
    只有在获得数据之后才可以移动更新数据
    */
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
    头部数据 不更新页面
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

            var rows = (maxRank+ITEM_NUM-1)/ITEM_NUM;
            //var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
            curPos[1] = min(0, max(-rows*OFFY+HEIGHT,curPos[1]));
            flowNode.pos(curPos);
            updateTab();
        }
    }


    /*
    touch 对象 cl
    检测的是 flowNode 的 孩子节点
    
    如果我方处于新手阶段 而对方不属于新手阶段 则不能挑战对方
    
    除非保存有对方处于新手阶段的士兵数据
    每天生成新的排名的时候将会删除这些新手排名数据
    */

    function showShadow(child)
    {
        var curNum = child.get();
        var beginRank = data[0][3];
        var diff = curNum-beginRank;
        if(diff < 0 || diff >= len(data))
            return;
        var uid = data[diff][0];
        var papayaId = data[diff][1];
        var score = data[diff][2];
        var rank = data[diff][3];
        if(uid == global.user.uid)
            return;

        var shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
        trace("child", child, shadow);
        child.add(shadow, 100, 1);


        var but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, doVisit, curNum);
        but0.addlabel(getStr("visit", null), null, 21).pos(47, 19).anchor(50, 50);

        //but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+40+16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeHero, curNum);
        //but0.addlabel(getStr("challengeHero", null), null, 21).pos(47, 19).anchor(50, 50);

        //未挑战过 且不是自身
        if(global.user.checkChallengeYet(uid) == 0)
        {
            but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeGroup, curNum);
            but0.addlabel(getStr("challengeGroup", null), null, 21).pos(47, 19).anchor(50, 50);
            
        }

        //but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+56+56).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeGroup, curNum);
        //but0.addlabel(getStr("challengeGroup", null), null, 21).pos(47, 19).anchor(50, 50);
        //selectedChild = child;
    }



    function challengeGroup(n, e, p, x, y, points)
    {
        var curNum = p;
        var beginRank = data[0][3];
        var diff = curNum-beginRank;
        if(diff < 0 || diff >= len(data))
            return;
        global.director.popView();
        var uid = data[diff][0];
        var papayaId = data[diff][1];
        var score = data[diff][2];
        var rank = data[diff][3];

        var cs = new ChallengeScene(uid, papayaId, score, rank);
        global.director.pushScene(cs);
        global.director.pushView(new VisitDialog(cs), 1, 0);
        cs.initData();

        //map 5 挑战页面
    }
    function doVisit(n, e, p, x, y, points)
    {
        global.director.popView();
        var papayaId = data[p][1];
        //排行榜不是好友 不能进行下一个
        var friend = new FriendScene(papayaId, -1); 
        global.director.pushScene(friend);
        global.director.pushView(new VisitDialog(friend), 1, 0);
    }

}
