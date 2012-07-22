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
        //scene = s;
        building = b;
        bg = node();
        bg.addsprite("plantChoice.png").pos(440, 0);
        var back = bg.addnode().pos(544, 39).size(219, 437).clipping(1);
        flowNode = back.addnode();
        bg.addsprite("plantShadow.png", ARGB_8888).pos(544, 39);
        //var sc = 330*100/253;
        //bg.addsprite("goodsChoice.png").pos(807, 119).scale(-sc, sc);
        var pback = bg.addsprite("plantBack.png").pos(442, 43);
        new Button(pback, onBack, null);

        initPlant();

        showCastleDialog();
    }
    function onBack(p)
    {
        //global.director.popView();
        closeCastleDialog();
    }
    var minPos;
    function initPlant()
    {
        for(var i = 0; i < len(plantData); i++)
        {
            var planting = getData(PLANT, i);//getPlant(i);
            var panel = flowNode.addsprite("plantPanel.png").pos(0, i*Height);
            panel.addsprite("Wplant"+str(i)+".png").pos(169, 48).anchor(50, 50);

            
            /*
            var cost = planting.get("silver");
            var cur = global.user.getValue("silver");
            var cl = [0, 0, 0];
            if(cur < cost)
                cl = [100, 0, 0];
            */

            var cost = getCost(PLANT, i);
            var buyable = global.user.checkCost(cost);
            var cl = [0, 0, 0];
            if(buyable.get("ok") == 0)
            {
                cl = [100, 0, 0];
            }
            var key = cost.keys();
            key = key[0];
            var val = cost.values();
            val = val[0];

            panel.addsprite(key+".png").pos(31, 24).anchor(50, 50).size(30, 30);
            panel.addlabel(str(val), null, 18).anchor(0, 50).pos(51, 24).color(cl[0], 0, 0);

            panel.addlabel(getTimeStr(planting.get("time")), null, 18).anchor(0, 50).pos(7, 50).color(0, 0, 0);

            panel.addsprite("exp.png").size(30, 30).pos(80, 50).anchor(100, 50);
            panel.addlabel(str(planting.get("exp")), null, 18).pos(83, 50).color(0, 0, 0).anchor(0, 50);

            panel.addsprite("silver.png").pos(31, 76).anchor(50, 50).size(30, 30);
            panel.addlabel(str(planting.get("gainsilver")), null, 18).anchor(0, 50).pos(51, 76).color(0, 0, 0);
            panel.put(i);
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
                    global.director.pushView(new MyWarningDialog(getStr("levelNotTitle", null), getStr("plantLevel", ["[NAME]", plantData.get("name"), "[LEVEL]", str(needLevel)]), null), 1, 0);
                }
                else if(buyable.get("ok") == 0)
                {
                    //资源不足 欠一种类型的资源
                    var key = cost.keys()[0];
                    //var val = cost.values()[0];

                    global.director.pushView(
                        new MyWarningDialog(getStr("resNot", null), getStr("resLack", ["[NAME]", getStr(key, null),  "[NUM]", str(buyable[key])]),  null), 1, 0);
                }
                else
                {
                    global.httpController.addRequest("buildingC/beginPlant", dict([["uid", global.user.uid], ["bid", building.bid], ["objectId", child.get()]]), beginPlant, [cost, child.get()]);
                    building.waitLock("feeding");
                    //global.user.doCost(cost);
                    //building.waitLock();
                    //building.funcBuild.beginPlant(child.get()); 
                    //global.director.popView();
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
    function beginPlant(rid, rcode, con, req, param)
    {
        if(rcode != 0)
        {
            var cost = param[0];
            var id = param[1];

            global.user.doCost(cost);
            building.removeLock();
            building.funcBuild.beginPlant(id); 
        }
    }   
}
