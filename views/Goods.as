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
    const offY = 220;
    const HEIGHT = 325;
    const PAN_PER_ROW = 3;

    function Goods(s)
    {
        store = s;
        bg = node().pos(258, 129);
        cl = bg.addnode().size(500, HEIGHT).clipping(1);
        title = bg.addsprite().pos(offX/2+offX, 103-129).anchor(50, 50);
        init();
        goodNum = [];
        flowNode = cl.addnode();
        flowNode.size(0, 0);
        minPos = 0;
        selTab = -1;

    }
    function initSameElement(buildData, panel)
    {
        var cost = getCost(buildData[0], buildData[1]);
        var data = getData(buildData[0], buildData[1]);
        var needLevel = data.get("level", 0);
        var gain = getGain(buildData[0], buildData[1]);
//        trace("initSameElement", cost, data, gain);

        /*
        采用字符串替换的方法，这样如果图片不需要ID的话可以直接返回
        对于在字符串数组中不存在的字符串， 直接返回替换结果
        需要确保不存在
        */
        var buildPicName = replaceStr(KindsPre[buildData[0]], ["[ID]", str(buildData[1])]);
        var buildPic = panel.addsprite(buildPicName).pos(83, 110).anchor(50, 50);
        //storeScalePic(buildPic);

        buildPic.prepare();
        var bSize = buildPic.size();
        var bl = min(120*100/bSize[0], 100*100/bSize[1]);
        bl = min(120, max(40, bl));
        buildPic.scale(bl);

        var canBuy = 1;
        if(global.user.getValue("level") < needLevel)
        {
            buildPic.texture(buildPicName, BLACK);
            panel.addsprite("storeNotLev.png");
            var words = colorWords(getStr("levelNot", ["[LEVEL]", str(needLevel)]));
            panel.addlabel(words[0], null, 20).pos(110-20*words[2], 99).anchor(0, 50).color(100, 100, 100);
            panel.addlabel(words[1], null, 20).pos(110, 99).anchor(0, 50).color(0, 100, 0);
            //panel.addlabel(getStr("levelNot", ["[LEVEL]", str(needLevel)]), null, 20).pos(84, 99).anchor(50, 50).color(100, 100, 100);
            canBuy = 0;
        }
        //物品属性
        else
        {
            panel.addlabel(data.get("name"), null, 25).pos(79, 28).anchor(50, 50).color(0, 0, 0);
            var picCost = cost.items();
//            trace("buildCost", cost);
            if(len(picCost) > 0)
            {
                var c = [100, 100, 100];
                if(picCost[0][0] == "free")//免费物品只显示免费
                {
                    panel.addlabel(getStr("free", null), null, 18).pos(95, 188).anchor(50, 50).color(c[0], c[1], c[2]);
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
                    var cPic = panel.addsprite(picName).pos(35, 189).anchor(50, 50).size(30, 30);  
                    var cNum = panel.addlabel(str(valNum), null, 18).pos(95, 188).anchor(50, 50).color(c[0], c[1], c[2]);
                }
            }


            /*
            客户端和后台的数据统一在数据库中
            showGain 默认没有 表示 显示 增加的数据
            对于 银币 金币 水晶 则不显示
            */
            var showGain = data.get("showGain", 1);
            if(showGain == 1)
            {
                var labelGain = gain.items();
                if(len(labelGain) != 0)
                {
                    /*
                    图片向上移动用于显示增加
                    */
                    buildPic.pos(83, 100);
                    var sca = getSca(buildPic, [120, 90]);
                    buildPic.scale(sca);

                    //trace("labelGain", labelGain[0]);
                    var k = getStr(labelGain[0][0], null);
                    var v = labelGain[0][1];
                    if(v < 0)
                        k = k + getStr("unlimit", null);
                    else
                        k = k + str(v);
                    panel.addlabel(k, null, 18).pos(79, 152).anchor(50, 50).color(0, 0, 0);
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
    /*
    两种思路， 每次移动结束更新状态
    移动过程中， 每次检测，对于溢出的进行删除，没有显示的进行补偿显示
    */
    function updateTab(rg)
    {
        var posX = 0;
        var posY = -offY+rg[0]*offY;
//        trace("update Tab", posX, posY, rg, len(goodNum));
        
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
            var panel = sprite("goodPanel.png").pos(posX, posY);
            var buildData = store.allGoods[selTab][i];

            var canBuy = initSameElement(buildData, panel);
//            trace("canBuy", canBuy);

            panel.put([selTab, i, canBuy]);
            flowNode.add(panel, 0, i);

        }

        var rows = (len(goodNum)+PAN_PER_ROW-1)/PAN_PER_ROW;
        flowNode.size(3*offX, rows*offY);
        var fSize = flowNode.size();
        var bSize = cl.size();
        minPos = min(-(fSize[1]-bSize[1]), 0);

        flowNode.setevent(EVENT_TOUCH, touchBegan);
        flowNode.setevent(EVENT_MOVE, touchMoved);
        flowNode.setevent(EVENT_UNTOUCH, touchEnded);
    }
    /*
    切换tab 更新面板 更新物品信息
    */
    function setTab(g)
    {
        selTab = g;
        //trace(getStr(store.words[g], null));
        title.texture(store.titles[g]);

        goodNum = store.allGoods[selTab]; 

        flowNode.removefromparent();
        flowNode = cl.addnode();

        var rg = getShowRange();
        updateTab(rg);
    }
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        lastPoints = newPos;
        accMove = 0;
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
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
//        trace("goods flownode", newPos, accMove);
        if(accMove < 10)
        {
            var child = checkInChild(n, newPos);
//            trace("in which child", child);
            if(child != null)
            {
                var buildData = child.get();
                /*
                条件满足可以购买
                */
                if(buildData[2] == 1)
                    store.buy(child.get());            
            }
        }

        //accMove = 0;
        var oldPos = flowNode.pos();
        oldPos[1] = min(0, max(minPos, oldPos[1]));
        flowNode.pos(oldPos[0], oldPos[1]);

        var rg = getShowRange();
        updateTab(rg);
    }
}
