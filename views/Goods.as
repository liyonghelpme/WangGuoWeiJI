class Goods extends MyNode
{
    var goodNum;
    var flowNode;
    var lastPoints;
    var minPos;
    var store;
    var title;
    var cl;

    const offX = 168;
    const offY = 208;
    const HEIGHT = 314;
    const PAN_PER_ROW = 3;

    /*
    背景通常只是一个位置00的node
    其他元素的位置相对这个指定
    在flowNode 上添加一个NewButton 
    NewButton 没有enterScene exitScene
    */
    function Goods(s)
    {
        store = s;
        bg = node();//.pos(258, 129);
        init();
        cl = bg.addnode().size(500, HEIGHT).clipping(1).pos(271, 145);
        //title = bg.addsprite().pos(offX/2+offX, 103-129).anchor(50, 50);
        title = bg.addsprite("buyDrug.png", UPDATE_SIZE).anchor(50, 50).pos(515, 112);


        goodNum = [];
        flowNode = cl.addnode();
        flowNode.size(0, 0);
        minPos = 0;
        selTab = -1;

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

    }
    function initSameElement(buildData, panel)
    {
        var objKind = buildData[0];
        var objId = buildData[1];
        var cost = getCost(buildData[0], buildData[1]);
        var data = getData(buildData[0], buildData[1]);
        var needLevel = data.get("level", 0);
        var gain = getGain(buildData[0], buildData[1]);

        /*
        采用字符串替换的方法，这样如果图片不需要ID的话可以直接返回
        对于在字符串数组中不存在的字符串， 直接返回替换结果
        需要确保不存在
        */
        var buildPicName = replaceStr(KindsPre[buildData[0]], ["[ID]", str(buildData[1])]);
        //不显示属性 位置 缩放
        //显示属性位置 缩放

        var showGain = data.get("showGain", 1);
        var buildPic = panel.addsprite(buildPicName).pos(74, 88).anchor(50, 50);
        var ret;
        if(objKind == BUILD)
        {
            ret = checkBuildNum(objId);
            if(ret[0] == 0)
            {
                buildPic.texture(buildPicName, GRAY);
            }
            //普通农田显示 数量
            if(data["funcs"] == FARM_BUILD)
            {
                //普通 魔法农田都显示 数量
                panel.addlabel(str(getCurBuildNum(objId))+"/"+str(getBuildEnableNum(objId)[0]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(121, 134).color(43, 25, 9);
                showGain = 0;
            }
            else
            {
                //总量存在限制 则显示当前拥有的数字 
                if(ret[2] == 1)
                {
                    panel.addlabel(str(getCurBuildNum(objId))+"/"+str(getBuildEnableNum(objId)[0]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(121, 134).color(43, 25, 9);
                    showGain = 0;
                }
            }
        }
        var sca;
        if(showGain == 0)
        {
            buildPic.pos(74, 97);
            sca = getSca(buildPic, [121, 88]);
            buildPic.scale(sca);
        }
        else
        {
            buildPic.pos(74, 88);
            sca = getSca(buildPic, [121, 71]);
            buildPic.scale(sca);
        }
        

        var canBuy = 1;
        if(global.user.getValue("level") < needLevel)
        {
            buildPic.texture(buildPicName, BLACK);
            panel.addsprite("storeShadow.png").size(151, 191).color(100, 100, 100, 47);
            
            var cw = colorWordsNode(getStr("levelNot", ["[LEVEL]", str(needLevel)]), 20, [100, 100, 100], [0, 100, 0]);
            cw.anchor(50, 50).pos(75, 97);
            panel.add(cw); 

            canBuy = 0;
        }
        //物品属性
        else
        {
            panel.addlabel(data.get("name"), "fonts/heiti.ttf", 20).pos(78, 25).anchor(50, 50).color(29, 16, 4);
            var picCost = cost.items();
            if(len(picCost) > 0)
            {
                var c = [100, 100, 100];
                if(picCost[0][0] == "free")//免费物品只显示免费
                {
                    panel.addlabel(getStr("free", null), "fonts/heiti.ttf", 18).pos(83, 169).anchor(50, 50).color(c[0], c[1], c[2]);
                }
                else
                {
                    var picName = picCost[0][0]+".png";
                    var valNum = picCost[0][1];
                    var buyable = global.user.checkCost(cost);
                    if(buyable.get("ok") == 0)
                        c = [100, 0, 0];
                    /*
                    消耗图片采用 消耗资源的名字
                    消耗数值 
                    */
                    var cPic = panel.addsprite(picName).pos(31, 170).anchor(50, 50).size(30, 30);  
                    var cNum = panel.addlabel(str(valNum), "fonts/heiti.ttf", 18).pos(83, 169).anchor(50, 50).color(c[0], c[1], c[2]);
                }
            }


            /*
            客户端和后台的数据统一在数据库中
            showGain 默认没有 表示 显示 增加的数据
            对于 银币 金币 水晶 则不显示
            */

            //两步处理方法
            //特殊例子自动处理
            //一般物品普通处理
            //获取物体的storeWords 如果没有则 按照普通方式处理
            if(showGain == 1)
            {
                //药品显示技能的属性
                if(objKind == DRUG)
                {
                    gain = getGain(SKILL, data["skillId"]);
                }
                var w;
                var labelGain = gain.items();

                if(len(labelGain) > 0)
                {
                    var v = labelGain[0][1];
                    var k = getStr(StoreAttWords[labelGain[0][0]], ["[NUM]", str(v)]);

                    panel.addlabel(k, "fonts/heiti.ttf", 18).pos(78, 136).anchor(50, 50).color(43, 25, 9);
                }
            }
        }
        return canBuy;
    }
    /*
    根据移动的位置 计算需要显示的范围 预先显示额外的上下两行
    0-325
    */
    function getShowRange()
    {
        var p = flowNode.pos();
        var upRow = max(0, -p[1]/offY);
        var lowRow = (-p[1]+HEIGHT+offY)/offY;
        var rows = (len(goodNum)+PAN_PER_ROW-1)/PAN_PER_ROW;
        return [max(0, upRow-1), min(lowRow+1, rows)];
    }
    var selTab = -1;
    function updateTab(rg)
    {
        var posX = 0;
        var posY = -offY+rg[0]*offY;
        
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);


        var i = max(0, rg[0]*3);
        for(; i < len(goodNum) && i < rg[1]*3; i++)
        {
            if(i%3 == 0)
            {
                posX = 0;
                posY += offY;
            }
            else
            {
                posX += offX;
            }
            var panel = sprite("goodPanel.png").pos(posX, posY).size(149, 188);
            var buildData = store.allGoods[selTab][i];
            var canBuy = initSameElement(buildData, panel);

            panel.put([selTab, i, canBuy]);
            flowNode.add(panel, 0, i);
            if(curSel != null && curSel[1] == i)
            {
                showGreenBut(panel);
            }
        }

        var rows = (len(goodNum)+PAN_PER_ROW-1)/PAN_PER_ROW;
        flowNode.size(3*offX, rows*offY);
        var fSize = flowNode.size();
        var bSize = cl.size();
        minPos = min(-(fSize[1]-bSize[1]), 0);

    }
    /*
    切换tab 更新面板 更新物品信息
    */
    function setTab(g)
    {
        selTab = g;
        curSel = null;
        //trace(getStr(store.words[g], null));
        title.texture(store.titles[g], UPDATE_SIZE);

        goodNum = store.allGoods[selTab]; 

        flowNode.removefromparent();
        flowNode = cl.addnode();

        var rg = getShowRange();
        updateTab(rg);
    }
    var touchEventTime = [];
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        lastPoints = newPos;
        accMove = 0;
        curSel = null;
        touchEventTime = [[lastPoints, time()]];
    }
    function moveBack(dify)
    {
        var oldPos = flowNode.pos();
        flowNode.pos(oldPos[0], oldPos[1]+dify);
    }
    var accMove = 0;
    function touchMoved(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        var now = time();
        if(now - touchEventTime[len(touchEventTime)-1][1] > getParam("minInertiaTime"))
        {
            touchEventTime.append([newPos, now]);
            if(len(touchEventTime) > 2)
                touchEventTime.pop(0);
        }
        var oldPoints = lastPoints;
        lastPoints = newPos;
        var dify = lastPoints[1] - oldPoints[1];
        accMove += abs(dify);
        moveBack(dify);
    }
    /*
    物品选择面板包含物品选择框类型和选择编号 以及物品需要的等级条件是否满足的信息
    移动结束更新面板数据
    */
    function onBuy(param)
    {
        curSel = null;
        store.buy(param); 
    }
    //var greenBut = null;
    var curSel = null;
    var shadow = null;
    function showGreenBut(child)
    {
        shadow = child.addnode();
        shadow.addsprite("storeShadow.png").anchor(0, 0).pos(0, 0).size(151, 191).color(100, 100, 100, 47);
        var but0 = new NewButton("greenButton0.png", [128, 39], getStr("sureToBuy", null), null, 20, FONT_NORMAL, [100, 100, 100], onBuy, child.get());
        but0.bg.pos(75, 97);
        shadow.add(but0.bg);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
//        trace("goods flownode", newPos, accMove);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
//            trace("in which child", child);
            if(child != null)
            {
                var buildData = child.get();
                /*
                条件满足可以购买
                */
                if(buildData[2] == 1)
                {
                    curSel = child.get();
                    //store.buy(child.get());            
                }
            }
        }
        //需要惯性移动 最后位移足够， 时间足够
        var needInertia = 0;

        if(len(touchEventTime) >= 2)
        {
            var t0 = touchEventTime[0];
            var t1 = touchEventTime[1];
            var passTime = t1[1]-t0[1];
            var diffY = t1[0][1]-t0[0][1];
            var finishMove = diffY*getParam("inertiaTime")/passTime;
            var expMove = finishMove/6.931;//expout initSpeed
            if(abs(expMove) > 10)
                needInertia = 1;
            trace("inertiaTime", needInertia, diffY, passTime, finishMove, expMove, touchEventTime, getParam("inertiaTime"));
        }


        //if(needInertia)
        //    flowNode.addaction(sequence(moveby(getParam("inertiaTime"), 0, expMove)), callfunc(finishInertia));
        //else
        finishInertia();
    }
    function finishInertia()
    {
        trace("finishInertia", finishInertia);
        var oldPos = flowNode.pos();
        oldPos[1] = min(0, max(minPos, oldPos[1]));
        flowNode.pos(oldPos[0], oldPos[1]);

        var rg = getShowRange();
        updateTab(rg);
    }
}
