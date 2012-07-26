/*
普通闯关页面: 怪兽倍率
挑战好友其它人: 人物实际属性
*/
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
    var leftArr;
    var rightArr;
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

        leftArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(57, 411).scale(-100, 100).setevent(EVENT_TOUCH, onMove, 1);
        rightArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(754, 411).setevent(EVENT_TOUCH, onMove, -1);

        /*
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
        */
        //updateTab();
        onMove(null, null, 0, null, null, null);
    }
    //var lastPoints;
    //var accMove;
    /*
    点击某个士兵 之后士兵出现在场景中 
    点击士兵的头上的取消按钮 则士兵消失
    */
    /*
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
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        moveBack(difx);
        accMove += abs(difx);
    }

    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        var sid = p;
        controlSoldier = scene.map.addSoldier(sid);
        //士兵没有位置放置所以失败
        if(controlSoldier == null)
            return;

        data.remove(sid);

        var curPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        curPos[0] = min(0, max(cols, curPos[0]));
        flowNode.pos(curPos);
        updateTab();
    }
    */
    function clearSoldier(so)
    {
        var sid = so.sid;
        trace("soldier clear", sid);
        data.append(sid);
        updateTab();
    }

    function getRange()
    {
        var oldPos = flowNode.pos(); 
        var lowCol = -oldPos[0]/OFFX;
        var upCol = (-oldPos[0]+WIDTH+OFFX-1)/OFFX;
        var total = len(data);
        trace("getRange", data);
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

            panel.setevent(EVENT_TOUCH, touchBegan, data[i]);
            panel.setevent(EVENT_MOVE, touchMoved);
            panel.setevent(EVENT_UNTOUCH, touchEnded);

            var sdata = global.user.getSoldierData(data[i]);
            trace("soldierData", sdata, data[i], i);
            var solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png").pos(40, 76).anchor(50, 100);
            var sca = getSca(solPic, [120, 120]);
            solPic.scale(-sca, sca);

            //panel.addlabel(sdata.get("name"), null, 18).pos(61, 40).color(0, 0, 0);
            panel.put(data[i]);
        }
    }
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        var sid = p;
        controlSoldier = scene.map.addSoldier(sid);
        if(controlSoldier == null)
            return;

        var nPos = n.node2world(x, y);
        var mPos = scene.map.bg.world2node(nPos[0], nPos[1]);
        controlSoldier.setPos(mPos);
        trace("controller setPos", nPos);
        
        //nPos = controlSoldier.bg.world2node(nPos[0], nPos[1]);
        trace("sol node began", nPos);
        controlSoldier.touchWorldBegan(controlSoldier.bg, e, null, nPos[0], nPos[1], points);

        data.remove(sid);
        n.visible(0);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        if(controlSoldier != null)
        {
            var nPos = n.node2world(x, y);
            //nPos = controlSoldier.bg.world2node(nPos[0], nPos[1]);
            //trace("sol node move", nPos);
            controlSoldier.touchWorldMoved(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
        }
    }
    function touchEnded(n, e, p, x, y, points)
    {
        //在点击之后更新panel
        var curPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        curPos[0] = min(0, max(cols, curPos[0]));
        flowNode.pos(curPos);
        updateTab();

        if(controlSoldier != null)
        {
            var nPos = n.node2world(x, y);
            //nPos = controlSoldier.bg.world2node(nPos[0], nPos[1]);
            trace("sol node end", nPos);
            controlSoldier.touchWorldEnded(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
        }
        controlSoldier = null;
    }

    //-1 0 1
    function onMove(n, e, p, x, y, points)
    {
        var oldPos = flowNode.pos();
        oldPos[0] += p*ITEM_NUM*OFFX;

        var total = len(data);
        oldPos[0] = min(0, max(-total*OFFX+WIDTH, oldPos[0])); 
        flowNode.pos(oldPos);
        if(oldPos[0] >= 0)
            leftArr.texture("mapMenuArr.png", GRAY);    
        else
            leftArr.texture("mapMenuArr.png");    

        if(oldPos[0] <= (-total*OFFX+WIDTH))
            rightArr.texture("mapMenuArr.png", GRAY);    
        else   
            rightArr.texture("mapMenuArr.png");    
        updateTab();
    }
    function onOk()
    {
        scene.finishArrage();
    }
    function onCancel()
    {
        global.director.popScene();
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
    var kind;//0 闯关 1 挑战

    var param;


    var pausePage;
    //big small soldierData
    function BattleScene(k, sm, s, ki, par, eq)
    {
        param = par;
        kind = ki;
        bg = node();
        init();
        map = new Map(k, sm, s, this, eq);
        addChild(map);
        banner = new MapBanner(this);
        addChild(banner);
    }
    function finishArrage()
    {
        banner.removeSelf();
        banner = null;
        map.finishArrage();
        pausePage = new MapPause(this);
        addChild(pausePage);
    }
    function stopGame()
    {
        map.stopGame();
    }
    function continueGame()
    {
        map.continueGame();
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
