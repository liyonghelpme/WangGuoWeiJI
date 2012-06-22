class MapBanner extends MyNode
{
    var scene;
    var cl;
    var flowNode;
    var controlSoldier = null;
    
    const OFFX = 104;
    const ITEM_NUM = 6;
    const WIDTH = ITEM_NUM * OFFX;
    const CLIP_HEIGHT = 200;

    const CLIP_WIDTH = 619;

    var data;
    //sid not dead 
    function initData()
    {
        data = [];
        var sols = global.user.soldiers.items();
        for(var i = 0; i < len(sols); i++)
        {
            var sdata = sols[i][1];
            if(sdata.get("dead", 0) == 0)
            {
                data.append(sols[i][0]);
            }
        }
    }
    function MapBanner(sc)
    {
        scene = sc;
        bg = node();
        init();
        initData();

        bg.addsprite("mapMenuOk.png").pos(557, 19).setevent(EVENT_TOUCH, onOk);
        bg.addsprite("mapMenuCancel.png").pos(674, 19).setevent(EVENT_TOUCH, onCancel);
        cl = bg.addnode().pos(103, 451).size(CLIP_WIDTH, CLIP_HEIGHT).clipping(1).anchor(0, 100);
        flowNode = cl.addnode().pos(0, CLIP_HEIGHT);

        bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(57, 411).scale(-100, 100).setevent(EVENT_TOUCH, onMove, -1);
        bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(754, 411).setevent(EVENT_TOUCH, onMove, 1);

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var lastPoints;
    var accMove;
    /*
    点击某个士兵 之后士兵出现在场景中 
    点击士兵的头上的取消按钮 则士兵消失
    */
    function touchBegan(n, e, p, x, y, points)
    {
        controlSoldier = null;
        accMove = 0;
        lastPoints = n.node2world(x, y);

    }
    function moveBack(difx)
    {
        var curPos = flowNode.pos();
        curPos[0] += difx;
        flowNode.pos(curPos);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        /*    
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        moveBack(difx);
        accMove += abs(difx);
        */
    }

    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, lastPoints);
            if(child != null)
            {
                var sid = child.get(); 
                controlSoldier = scene.map.addSoldier(sid);
                data.remove(sid);
            }
        }
        var curPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        curPos[0] = max(cols, min(0, curPos[0]));
        flowNode.pos(curPos);
        updateTab();
    }
    function clearSoldier(so)
    {
        var sid = so.sid;
        data.append(sid);
        updateTab();
    }

    function getRange()
    {
        var oldPos = flowNode.pos(); 
        var lowCol = -oldPos[0]/OFFX;
        var upCol = (-oldPos[0]+WIDTH+OFFX-1)/OFFX;
        var total = len(data);
        return [max(0, lowCol-1), min(upCol+1, total)];

    }
    function updateTab()
    {
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("mapMenuBlock.png").pos(i*OFFX, 0).anchor(0, 100);
            var sdata = global.user.getSoldierData(data[i]);
            panel.addsprite("soldier"+str(sdata.get("id"))+".png").pos(40, 76).anchor(50, 100);
            panel.addlabel(sdata.get("name"), null, 25).pos(61, 20).color(0, 0, 0);
            panel.put(data[i]);
        }
    }
    function onMove(n, e, p, x, y, points)
    {
        var oldPos = flowNode.pos();
        if(p == 1)
            oldPos[0] += ITEM_NUM*OFFX;
        else
            oldPos[0] -= ITEM_NUM*OFFX;

        var total = len(data);
        oldPos[0] = max(-total*OFFX+WIDTH, min(0, oldPos[0])); 
        flowNode.pos(oldPos);
        updateTab();
    }
    function onOk()
    {
        scene.finishArrage();
    }
    function onCancel()
    {
    }
}
/*
选择人物
进入地图

显示地图  显示控制banner

进行我方人物布局---->  布局确定  点击人物 拖动 位置
     人物状态 地图状态
     c
 
*/
class BattleScene extends MyNode
{
    var map;
    var banner;

    /*
    var leftHealth = 100;
    var leftBound = 100;
    var rightHealth = 50;
    var rightBound = 100;
    */

    var pausePage;
    function BattleScene(k, s)
    {
        bg = node();
        init();
        map = new Map(k, s, this);
        addChild(map);
        banner = new MapBanner(this);
        addChild(banner);
    }
    function finishArrage()
    {
        banner.removeSelf();
        map.finishArrage();
        pausePage = new MapPause(this);
        addChild(pausePage);
    }
    function clearSoldier(so)
    {
        banner.clearSoldier(so);
    }
    function getDefense(id)
    {
        return map.getDefense(id);
    }
}
