class RankBase extends MyNode 
{
    var flowNode;
    //uid papayaId score rank
    var data = [];

    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const OFFX = 169;
    const OFFY = 180;
    const PANEL_WIDTH = 144;
    const PANEL_HEIGHT = 156;
    const WIDTH = 661;
    const HEIGHT = 336;
    //const HEIGHT = ROW_NUM*OFFY;
    const INIT_X = 70;
    const INIT_Y = 103;



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

    var lock = null;

    function update(diff)
    {
        if(initYet == 0)
        {
            if(lock == null)
            {
                var sz = bg.size();
                lock = node();

                lock.addsprite().pos(310, 228).addaction(
                repeat(
                    animate(1000, "heartLoad0.png", "heartLoad1.png", "heartLoad2.png", "heartLoad3.png", "heartLoad4.png", "heartLoad5.png", "heartLoad6.png", "heartLoad7.png", "heartLoad8.png", "heartLoad9.png")
                )); 
                lock.addsprite("heartLoading.png").pos(396, 253);
                bg.parent().add(lock, 10);
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
    var URL_API;
    var rankKind;
    
    //需要保持前后台数据格式一致 最简单的方式 是 后台直接返回 dict 而不是 数组
    //挑战数据格式 转化成  dict 数据

    var cl;
    function initView()
    {
        bg = node();
        init();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        var row = curRank/ITEM_NUM;
        flowNode = cl.addnode().pos(0, -row*OFFY); 

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);


    }
    function RankBase(sc, k)
    {
        scene = sc;
        rankKind = k;

        if(rankKind == CHALLENGE_RANK)
        {
            curRank = global.user.rankOrder; 
            //URL_API = "challengeC/getRank";
        }
        else if(rankKind == HEART_RANK)
        {
            curRank = global.user.heartRank;
            //URL_API = "friendC/getHeartRank";
        }
        else if(rankKind == FIGHT_RANK)
        {
            curRank = 0;
            //URL_API = "fightC/getDefenseRank";
        }
        else if(rankKind == INVITE_RANK)
        {
            curRank = global.user.invite["rank"];
            //URL_API = "friendC/getInviteRank";
        }
        URL_API = RANK_API[rankKind];
        /*
        else if(rankKind == ATTACK_RANK)
        {
            curRank = 0;
            URL_API = "fightC/getAttackRank";
        }
        else if(rankKind == DEFENSE_RANK)
        {
            curRank = 0;
            URL_API = "fightC/getDefenseRank";
        }
        */

        initView();
        updateTab();


    }

    /*
    首先按照rank 从小到大排好序
    删除重复的排名
    补上没有的空洞

    和原始data进行拼接的时候 确保 是连接在一起的 如果有空洞则补上空洞
    */
    //不要考虑空洞问题 服务器在生成排行榜时 是连续的数据
    //根据排行类型将数组数据转化成dict
    function adjustData(newData)
    {
        var table = RANK_KEY[rankKind];
        var temp = [];
        for(var i = 0; i < len(newData); i++)
        {
            var d = dict();
            for(var j = 0; j < len(table); j++)
            {
                d.update(table[j], newData[i][j]);
            }
            temp.append(d);
        }
        return temp;
    }
    /*
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
    */
    /*
    排名是连续的
    根据当前位置计算排名
    根据数据开始排名 和 结束排名 
   

    拖动的数据返回的数据必须是连续的可以直接拼接
    */
    //data 中数据 变成 dict形式
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
        //返回数据长度为0 则已经到达最大或者最小
        if(rcode != 0)
        {
            con = json_loads(con);
            newData = adjustData(con.get("res"));
            //同时考虑 最大最小 数据为空
            if(param == RANK_INIT)
            {

                data = newData;
                if(len(data) == 0)
                {
                    trace("noData return");
                    minRank = 0;
                    maxRank = 0;
                }
                else
                {

    //                trace("param1", data, len(data));
                    if(data[0]["rank"] > preMin)
                        minRank = data[0]["rank"];
                    if(data[len(data)-1]["rank"] < (preMax-1))
                    {
                        maxRank = data[len(data)-1]["rank"];   
                    }
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
            else if(param == RANK_END)
            {
                //newData = adjustData(con.get("res"));
                //判断data 和 newData 之间是否存在 间隙 则忽略数据uid -1 无效数据
                if(len(data) > 0 && len(newData) > 0)
                {
                    beginRank = data[len(data)-1]["rank"];
                    endRank = newData[0]["rank"];
                    if((endRank-beginRank) > 1)
                    {
                        for(k=beginRank+1; k < endRank; k++)
                        {
                            data.append(dict([["uid", -1]]));//[-1, 0, 0, k, "", 1]);
                        }
                    }
                }

                data += newData;

                if(data[len(data)-1]["rank"] < (preMax-1))
                {
                    maxRank = data[len(data)-1]["rank"];   
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
            else if(param == RANK_BEGIN)
            {

                //数据头部存在空隙
                if(len(data) > 0 && len(newData) > 0)
                {
                    beginRank = newData[len(newData)-1]["rank"];
                    endRank = data[0]["rank"];

                    if((endRank-beginRank) > 1)
                    {
                        for(k=beginRank+1; k < endRank; k++)
                        {
                            newData.append(dict([["uid", -1]]));//([-1, 0, 0, k, "", 1]);
                        }
                    }
                }

                data = newData+data;
                if(data[0]["rank"] > preMin)//没有小于某个某个数据的数据
                    minRank = data[0]["rank"];
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
            var rowBegin = curRank/ITEM_NUM;   
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
            scene.blueArrow.scale(100, -100).setevent(EVENT_TOUCH, onDown);
        }
        else
        {
            scene.blueArrow.scale(100, 100).setevent(EVENT_TOUCH, onUp);
        }

        //缓存范围
        var beginRank = max(lowRow*ITEM_NUM-FETCH_NUM, minRank);
        var endRank = min(upRow*ITEM_NUM+FETCH_NUM, maxRank);

        if(len(data) > 0)
        {
            //判定显示范围是否足够 不足进入更新状态
            var beginItem = data[0]["rank"];
            var endItem = data[len(data)-1]["rank"];
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
                if(limit > 0)
                    global.httpController.addRequest(URL_API, dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, RANK_INIT);
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
                    if(limit > 0)
                        global.httpController.addRequest(URL_API, dict([["uid", global.user.uid], ["offset", beginRank], ["limit", limit]]), getRankOver, RANK_BEGIN);
                }
                else if((endRank-1) > endItem && endItem < maxRank)//下部缓存数据不足 且下部没有到达最后
                {
                    endRank = min(max(endRank, endItem+FETCH_NUM), maxRank);
                    limit = endRank-endItem;
                    fetchData = 1;
                    preMax = endRank;
                    // 当前数据中的 >= endItem 
                    if(limit > 0)
                        global.httpController.addRequest(URL_API, dict([["uid", global.user.uid], ["offset", endItem+1], ["limit", limit]]), getRankOver, RANK_END);
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
        flowNode = cl.addnode().pos(oldPos);

        var begin = data[0]["rank"];
        var end = data[len(data)-1]["rank"]+1;
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


                //采用size的机制 这样panel上图片采用相对psd坐标
                //排行榜数据格式: 挑战排行 爱心排行 擂台排行 更多排行显示的数据view 是不同的
                //但是都是在显示人 数据的内容是类似的
                //排行的量是一致的
                var papayaId = data[diff]["id"];
                var panel = flowNode.addsprite("dialogFriendPanel.png").pos(j*OFFX, i*OFFY).size(PANEL_WIDTH, PANEL_HEIGHT);
                panel.addsprite("friendBlock.png").anchor(50, 50).pos(74, 82).size(55, 55).color(100, 100, 100, 100);
                panel.addsprite(avatar_url(papayaId)).anchor(50, 50).pos(74, 82).size(55, 55).color(100, 100, 100, 100);

                panel.addsprite("dialogRankCup.png").anchor(0, 0).pos(22, 8).size(35, 32).color(100, 100, 100, 100);
                panel.addlabel(getStr("Num", ["[NUM]", str(data[diff]["rank"])] ), "fonts/heiti.ttf", 23).anchor(0, 50).pos(63, 24).color(29, 16, 4);

                panel.addsprite("levelStar.png").anchor(50, 50).pos(100, 56).size(31, 31).color(100, 100, 100, 100);
                panel.addlabel(str(data[diff]["level"]) , "fonts/heiti.ttf", 15).anchor(50, 50).pos(101, 58).color(0, 0, 0);

                panel.addlabel(data[diff]["name"], "fonts/heiti.ttf", 18).anchor(50, 50).pos(77, 120).color(43, 25, 9);

                var scoreLabel = panel.addlabel(getStr(Kind2Num[rankKind], ["[NUM]", str(data[diff]["score"])]), "fonts/heiti.ttf", 18).anchor(50, 50).pos(77, 142).color(43, 25, 9);

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
        var beginRank = data[0]["rank"];
        var diff = curNum-beginRank;
        //访问的数据超出范围
        if(diff < 0 || diff >= len(data))
            return;
        var uid = data[diff]["uid"];
        //数据漏洞补偿的数据 
        if(uid == -1)
        {   
            return;
        }

        var papayaId = data[diff]["id"];
        var score = data[diff]["score"];
        var rank = data[diff]["rank"];
        /*
        挑战自己 则进入 服务器获取怪兽数据模式
        访问自己 阻止 
        */
        if(uid == global.user.uid)
            return;
        var but0;

        var shadow = child.addnode();
        shadow.addsprite("dialogFriendShadow.png").anchor(50, 50).pos(73, 79).size(144, 164).color(100, 100, 100, 100);
        if(rankKind == CHALLENGE_RANK)
        {
            but0 = new NewButton("violetBut.png", [92, 39], getStr("visit", null), null, 18, FONT_NORMAL, [100, 100, 100], onVisit, curNum);
            but0.bg.pos(75, 79);
            shadow.add(but0.bg);
        }
        else
        {
            but0 = new NewButton("violetBut.png", [92, 39], getStr("visit", null), null, 18, FONT_NORMAL, [100, 100, 100], onVisit, curNum);
            but0.bg.pos(75, 82);
            shadow.add(but0.bg);
        }

    }


    function onVisit(curNum)
    {
        var beginRank = data[0]["rank"];
        var diff = curNum-beginRank;
        if(diff < 0 || diff >= len(data))
            return;

        global.director.popView();
        var userData = data[diff];
        var papayaId = data[diff]["id"];
        //排行榜不是好友 不能进行下一个
        var friend = new FriendScene(papayaId, -1, VISIT_RANK, null, userData); 
        global.director.curScene.addChildZ(FriendScene, -1);
        //global.director.pushScene(friend);
        global.director.pushView(new VisitDialog(friend, FRIEND_DIA_HOME), 1, 0);
    }

}
