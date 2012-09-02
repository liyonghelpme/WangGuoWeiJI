/*
流程：
    rankOrder --- heartRank 用户当前排名 curRank
    
    updateTab ----> 获取当前显示的范围 getShowRangeAndBufferRange  
        如果显示区域数据不足 则  initYet = 0 等待数据
        如果缓存数据不足 则 获取数据
        计算获取数据的范围----> fetchData为1 防止多次发送数据请求
    
*/
class HeartRankBase extends MyNode 
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
    var minRank = 0;
    //预测得到的最大的数据范围
    var preMax;
    var preMin;
    var curRank;

    function getUserRow()
    {
        var rowBegin = curRank/ITEM_NUM;
        return rowBegin;
    }
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
    function HeartRankBase(p, s, sc)
    {
        curRank = global.user.heartRank;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        //爱心排行榜排名
        var row = global.user.heartRank/ITEM_NUM;
        flowNode = bg.addnode().pos(0, -row*OFFY); 

        updateTab();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }

    /*
    首先按照rank 从小到大排好序
    删除重复的排名
    补上没有的空洞

    和原始data进行拼接的时候 确保 是连接在一起的 如果有空洞则补上空洞
    */
    function adjustData(newData)
    {
        var error = 0;
        var i;
        var j;
//        trace("inPutData", newData);
        //检测一遍数据是否已经排好序列没有空洞 一般服务器是按照插入顺序返回数据的所以数据可能没有排好序列
        for(i = 1; i < len(newData); i++)
        {
            if(newData[i][3] != (newData[i-1][3]+1))
            {
                error = 1;
                break;
            }
        }
//        trace("error", error);
        if(error == 1)
        {
            //插入排好序列
            var temp = [];
            var k;
            for(i = 0; i < len(newData); i++)
            {
                var same = 0;
                for(j = 0; j < len(temp); j++)
                {
                    if(newData[i][3] < temp[j][3])//找到插入点
                    {
                        break;
                    }
                    else if(newData[i][3] == temp[j][3])//排名重复 则忽略 如果新的是自身 则替换
                    {
                        same = 1;
                        if(newData[i][0] == global.user.uid)
                        {
                            temp[j]= newData[i];
                        }
                        break;
                    }
                }
                if(same == 0)
                    temp.insert(j, newData[i]);
                
                if(len(temp) > 1)
                {
                    var l = len(temp);
                    //补上 数据内部的空洞
                    if((temp[l-1][3]-temp[l-2][3]) > 1)
                    {
                        var beginRank = temp[l-2][3]+1;
                        var endRank = temp[l-1][3];
                        for(k = beginRank; k < endRank; k++)
                        {
                            //uid=-1 papayaId score rank name finish
                            temp.insert(l-1, [-1, 0, 0, k, "", 1]);
                        }
                    }
                }
            }
            newData = temp;
        }
//        trace("adjustData", newData);
        return newData;
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
        var newData;
        var beginRank;
        var endRank;
        var k;

//        trace("getRankOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            con = json_loads(con);
            //同时考虑 最大最小 数据为空
            if(param == 2)
            {
                newData = adjustData(con.get("res"));
                data = newData;

//                trace("param1", data, len(data));
                if(data[0][3] > preMin)
                    minRank = data[0][3];
                if(data[len(data)-1][3] < (preMax-1))
                {
                    maxRank = data[len(data)-1][3];   
                }
                //获取的数据过多丢弃一半
                if(len(data) > MAX_BUFFER)
                {
                    temp = [];
                    for(i = len(data)/2; i < len(data); i++)
                        temp.append(data[i]);
                    data = temp;
                }
                
            }
            else if(param == 1)
            {
                newData = adjustData(con.get("res"));
                //判断data 和 newData 之间是否存在 间隙
                if(len(data) > 0 && len(newData) > 0)
                {
                    beginRank = data[len(data)-1][3];
                    endRank = newData[0][3];
                    if((endRank-beginRank) > 1)
                    {
                        for(k=beginRank+1; k < endRank; k++)
                        {
                            data.append([-1, 0, 0, k, "", 1]);
                        }
                    }
                }

                data += newData;

                //data += con.get("res");
//                trace("param1", data, len(data));
                if(data[len(data)-1][3] < (preMax-1))
                {
                    maxRank = data[len(data)-1][3];   
                }
                //获取的数据过多丢弃一半
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
                newData = adjustData(con.get("res"));

                if(len(data) > 0 && len(newData) > 0)
                {
                    beginRank = newData[len(newData)-1][3];
                    endRank = data[0][3];

                    if((endRank-beginRank) > 1)
                    {
                        for(k=beginRank+1; k < endRank; k++)
                        {
                            newData.append([-1, 0, 0, k, "", 1]);
                        }
                    }
                }

                data = newData+data;
                if(data[0][3] > preMin)//没有小于某个某个数据的数据
                    minRank = data[0][3];
//                trace("param0", data, len(data));
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
//            trace("getRankDataOver", data);
//            trace("getRankDataOver", len(data));
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
            var rowBegin = global.user.heartRank/ITEM_NUM;   
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
        //显示范围 minRank 如果获取的数据上边界有洞则minRank 
        var lowRow = max(-curPos[1]/OFFY, minRank);
        var upRow = min((-curPos[1]+HEIGHT+OFFY-1)/OFFY, (maxRank+ITEM_NUM-1)/ITEM_NUM);
        var rowNum = (maxRank+ITEM_NUM-1)/ITEM_NUM;

        var myRow = curRank/ITEM_NUM;
        if(lowRow < myRow)
        {
            scene.upArrow.scale(100, -100).setevent(EVENT_TOUCH, onDown);
        }
        else
        {
            scene.upArrow.scale(100, 100).setevent(EVENT_TOUCH, onUp);
        }

        //缓存范围
        var beginRank = max(lowRow*ITEM_NUM-FETCH_NUM, minRank);
        var endRank = min(upRow*ITEM_NUM+FETCH_NUM, maxRank);

        if(len(data) > 0)
        {
            //判定显示范围是否足够 不足进入更新状态
            var beginItem = data[0][3];
            var endItem = data[len(data)-1][3];
            //数据区域是半开半闭区间[a, b)
            var showBegin = max(lowRow*ITEM_NUM, minRank);
            var showEnd = min(upRow*ITEM_NUM, maxRank)
            if(beginItem > showBegin || endItem < (showEnd-1))
                initYet = 0;

//            trace("getShowRangeAndBufferRange", "maxRank", maxRank, "minRank", minRank, "lowRow", lowRow, "upRow", upRow, "rowNum", rowNum, beginRank, endRank, beginItem, endItem, "fetchData",fetchData, "initYet", initYet);
        }
//        trace("data", data);
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
            //[ )
            if(len(data) == 0)//计算整个缓存范围
            {
                limit = endRank - beginRank;
                fetchData = 1;
                initYet = 0;
                preMax = endRank;
                preMin = beginRank;
                //考虑最小最大范围
                global.httpController.addRequest("friendC/getHeartRank", dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, 2);


            }
            //获取缓存数据 判定显示数据足够则继续显示 否则停止显示更新
            else
            {
                //如果没有超出范围 则 尽量获取FETCH_NUM 的数据 
                if(beginItem > beginRank && beginItem > minRank)//上部缓存数据不足 且上部没有到达顶部
                {
                    beginRank = min(beginRank, max(beginItem-FETCH_NUM, minRank));
                    limit = beginItem-beginRank;
                    fetchData = 1;
                    preMin = beginRank;
                    global.httpController.addRequest("friendC/getHeartRank", dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, 0);
                }
                else if((endRank-1) > endItem && endItem < maxRank)//下部缓存数据不足 且下部没有到达最后
                {
                    endRank = min(max(endRank, endItem+FETCH_NUM), maxRank);
                    limit = endRank-endItem;
                    fetchData = 1;
                    preMax = endRank;
                    // 当前数据中的 >= endItem 
                    global.httpController.addRequest("friendC/getHeartRank", dict([["uid", global.user.uid], ["offset", endItem+1], ["limit", limit]]), getRankOver, 1);
                }
            }
        }

        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    /*
    maxRank 所有数据已经获取 同一时刻 只能进行一个数据获取
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
//        trace("updateTab", initYet, fetchData, rg, oldPos);
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
                    continue;
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
        //访问的数据超出范围
        if(diff < 0 || diff >= len(data))
            return;
        var uid = data[diff][0];
        //数据漏洞补偿的数据 
        if(uid == -1)
        {   
            return;
        }

        var papayaId = data[diff][1];
        var score = data[diff][2];
        var rank = data[diff][3];
        /*
        挑战自己 则进入 服务器获取怪兽数据模式
        */
        if(uid == global.user.uid)
            return;

        var shadow = sprite("dialogRankShadow.png").pos(PANEL_WIDTH/2, PANEL_HEIGHT/2).anchor(50, 50);
//        trace("child", child, shadow);
        child.add(shadow, 100, 1);


        var but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, doVisit, curNum);
        but0.addlabel(getStr("visit", null), null, 21).pos(47, 19).anchor(50, 50);

        //but0 = shadow.addsprite("greenButton.png").pos(PANEL_WIDTH/2, 16+40+16).anchor(50, 0).size(95, 40).setevent(EVENT_TOUCH, challengeHero, curNum);
        //but0.addlabel(getStr("challengeHero", null), null, 21).pos(47, 19).anchor(50, 50);

        //未挑战过 且不是自身
        if(global.user.checkChallengeYet(uid) == 0 )//挑战自身显示按钮 || uid == global.user.uid
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

        var cs = new ChallengeScene(uid, papayaId, score, rank, CHALLENGE_FRI, null);
        global.director.pushScene(cs);
        global.director.pushView(new VisitDialog(cs), 1, 0);
        cs.initData();

        //map 5 挑战页面
    }
    function doVisit(n, e, p, x, y, points)
    {
        var userData = data[p];
        global.director.popView();
        var papayaId = data[p][1];
        //排行榜不是好友 不能进行下一个
        var friend = new FriendScene(papayaId, -1, VISIT_RANK, null, dict([["uid", userData[0]], ["id", userData[1]], ["name", userData[4]]])); 
        global.director.pushScene(friend);
        global.director.pushView(new VisitDialog(friend), 1, 0);
    }

}
