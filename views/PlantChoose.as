class PlantChoose extends MyNode
{
    var building;
    //var scene;
    var flowNode;
    const Height = 113;
    const BackHei = 452;
    const InitOff = 113;
    function PlantChoose(b)
    {
        building = b;
        bg = node().size(global.director.disSize).setevent(EVENT_TOUCH|EVENT_MOVE|EVENT_UNTOUCH, doNothing);
        init();

        bg.addsprite("plantChoice.png").pos(440, 0);
        var back = bg.addnode().pos(544, 39).size(219, 437).clipping(1);
        flowNode = back.addnode();
        bg.addsprite("plantShadow.png", ARGB_8888).pos(544, 39);
        var pback = bg.addsprite("plantBack.png").pos(442, 43).setevent(EVENT_TOUCH, onBack);

        initPlant();

        showCastleDialog();
    }
    function onBack(e, p, x, y, points)
    {
        closeCastleDialog();
    }
    var minPos;
    function initPlant()
    {
        var but0;
        var line;
        var temp;
        var sca;
        var level = global.user.getValue(level);
        for(var i = 0; i < len(plantData); i++)
        {
            var planting = getData(PLANT, i);
            var panel = sprite("plantPanel.png").pos(0, i*Height);

            var zOrd = 0;
            if(i == 0)
                zOrd = 3;
            flowNode.add(panel, zOrd);
            panel.addsprite("Wplant"+str(i)+".png").pos(169, 48).anchor(50, 50);

            panel.addlabel(getWorkTime(planting.get("time")), "fonts/heiti.ttf", 24).anchor(0, 50).pos(16, 84).color(0, 0, 0);
            panel.addlabel(str(planting.get("exp")), "fonts/heiti.ttf", 24).anchor(0, 50).pos(47, 20).color(0, 0, 0);
            temp = panel.addsprite("exp.png").anchor(0, 0).pos(10, 7).size(30, 30).color(100, 100, 100, 100);
            panel.addlabel(str(planting.get("gainsilver")), "fonts/heiti.ttf", 24).anchor(0, 50).pos(48, 54).color(0, 0, 0);
            temp = panel.addsprite("silver.png").anchor(0, 0).pos(11, 38).size(30, 30).color(100, 100, 100, 100);

            var needLevel = planting.get("level");
            if(needLevel > level)
            {
                panel.addsprite("dialogRankShadow.png").size(230, 106);
                var words = colorWordsNode(getStr("levelNot", ["[LEVEL]", str(needLevel)]), 20, [100, 100, 100], [getParam("notRed"), getParam("notGreen"), getParam("notBlue")]);
                words.anchor(50, 50).pos(115, 53);
                panel.add(words);

            }
            panel.put(i);
            if(i == 0)
            {
                global.taskModel.showHintArrow(panel, panel.prepare().size(), PLANT_ICON);
            }

        }
        var row = len(plantData)*Height;
        minPos = min(-(row-BackHei), 0);
        flowNode.size(219, row);
        flowNode.setevent(EVENT_TOUCH, touchBegan);
        flowNode.setevent(EVENT_MOVE, touchMoved);
        flowNode.setevent(EVENT_UNTOUCH, touchEnded);
        



    }
    var lastPoints;
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function moveBack(dify)
    {
        var curPos = flowNode.pos();
        flowNode.pos(curPos[0], curPos[1]+dify);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1] - oldPos[1];
        moveBack(dify);   
        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(accMove < 10)
        {
            var newPos = n.node2world(x, y);
            var child = checkInChild(n, newPos);
            if(child != null)
            {
                var id = child.get();

                var cost = getCost(PLANT, id);
                var buyable = global.user.checkCost(cost);
                var level = global.user.getValue("level");
                var plantData = getData(PLANT, id);
                var needLevel = plantData.get("level");
                if(level < needLevel)
                {
                }
                else if(buyable.get("ok") == 0)
                {
                    //资源不足 欠一种类型的资源
                    var key = cost.keys()[0];

                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr(key, null),  "[NUM]", str(buyable[key])]), [100, 100, 100], null));

                }
                //回调函数的上下文可能已经失去 
                else
                {
                    var callback = building.beginPlant;
                    global.httpController.addRequest("buildingC/beginPlant", dict([["uid", global.user.uid], ["bid", building.bid], ["objectId", child.get()]]), callback, [cost, child.get()]);
                    building.waitLock("feeding");
                    closeCastleDialog();
                }
            }
        }
        var oldPos = flowNode.pos();
        oldPos[1] = min(0, max(minPos, oldPos[1]));
        var sel = oldPos[1]/Height;
        oldPos[1] = sel*Height;
        flowNode.pos(oldPos[0], oldPos[1]);
    }
}
