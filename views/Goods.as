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

    function Goods(s)
    {
        store = s;
        bg = node().pos(258, 129);
        cl = bg.addnode().size(500, 330).clipping(1);
        title = bg.addsprite().pos(offX/2+offX, 103-129).anchor(50, 50);
        init();
        goodNum = [];
        flowNode = cl.addnode();
        flowNode.size(0, 0);
        minPos = 0;

    }
    function setTab(g)
    {
        trace(getStr(store.words[g]));
        //title.text(getStr(store.words[g]));
        title.texture(store.titles[g]);
        var posX = 0;
        var posY = -offY;

        flowNode.removefromparent();
        flowNode = cl.addnode();

        goodNum = store.allGoods[g];
        for(var i = 0; i < len(goodNum); i++)
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
            var buildData = store.allGoods[g][i];
            if(buildData[0] == 0)
            {
                var bAllData = getBuild(buildData[1]); 
                var buildPic = panel.addsprite("build"+str(buildData[1])+".png").pos(83, 110).anchor(50, 50);
                buildPic.prepare();
                var buildSize = buildPic.size();
                var bl = min(127*100/buildSize[0], 101*100/buildSize[1]);
                bl = min(120, max(40, bl));
                buildPic.scale(bl);
                panel.addlabel(bAllData.get("name"), null, 25).pos(79, 28).anchor(50, 50).color(0, 0, 0);
                var cost = getBuildCost(buildData[1]);
                var picCost = cost.items();
                trace("buildCost", cost);

                var picName = picCost[0][0]+".png";
                var valNum = picCost[0][1];
                var buyable = global.user.checkCost(cost);
                var c = [100, 100, 100];
                if(buyable.get("ok") == 0)
                    c = [100, 0, 0];
                var cPic = panel.addsprite(picName).pos(35, 189).anchor(50, 50);  
                var cNum = panel.addlabel(str(valNum), null, 18).pos(95, 188).anchor(50, 50).color(c[0], c[1], c[2]);
            }
            panel.put([g, i]);
            flowNode.add(panel, 0, i);
        }
        var rows = (len(goodNum)+2)/3;
        flowNode.size(3*offX, rows*offY);
        var fSize = flowNode.size();
        var bSize = cl.size();
        minPos = min(-(fSize[1]-bSize[1]), 0);

        flowNode.setevent(EVENT_TOUCH, touchBegan);
        flowNode.setevent(EVENT_MOVE, touchMoved);
        flowNode.setevent(EVENT_UNTOUCH, touchEnded);
    }
    //var choosePanel = null;
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
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        trace("goods flownode", newPos, accMove);
        if(accMove < 10)
        {
            var child = checkInChild(n, newPos);
            if(child != null)
            {
                store.buy(child.get());            
            }
        }

        //accMove = 0;
        var oldPos = flowNode.pos();
        oldPos[1] = min(0, max(minPos, oldPos[1]));
        flowNode.pos(oldPos[0], oldPos[1]);
    }
}
