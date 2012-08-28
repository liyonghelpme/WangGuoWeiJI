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
    
    const OFFX = 102;
    const ITEM_NUM = 6;
    const WIDTH = ITEM_NUM * OFFX;

    const CLIP_HEIGHT = 90;
    const CLIP_WIDTH = WIDTH;

    var data;
    
    //sid inMap
    function cmp(a, b)
    {
        var sa = global.user.getSoldierData(a);
        var sb = global.user.getSoldierData(b);
        return sb.get("level")-sa.get("level");
    }
    //sid not dead 
    function initData()
    {
        data = [];
        var sols = global.user.soldiers.items();
        for(var i = 0; i < len(sols); i++)
        {
            var sdata = sols[i][1];
            if(sdata.get("dead", 0) == 0)//soldierId
            {
                data.append(sols[i][0]);//是否已经放置
            }
        }
        bubbleSort(data, cmp);
    }
    var leftArr;
    var rightArr;
    var shadowWord;
    var words;

    /*
    将剩余士兵尽量全部放置到地面上
    每行一个逐个放置直到没有
    */
    function MapBanner(sc)
    {
        scene = sc;
        bg = node();
        init();
        initData();
        
        //117

        if(scene.kind != CHALLENGE_TRAIN)
        {
            bg.addsprite("mapMenuOk.png").pos(440, 19).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("mapMenuCancel.png").pos(557, 19).setevent(EVENT_TOUCH, onCancel);
            //练级没有随机放置功能

            bg.addsprite("random.png").pos(674, 19).setevent(EVENT_TOUCH, onRandom);
        }
        else
        {
            bg.addsprite("mapMenuOk.png").pos(557, 19).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("mapMenuCancel.png").pos(674, 19).setevent(EVENT_TOUCH, onCancel);
        }

        cl = bg.addnode().pos(103, 451).size(CLIP_WIDTH, CLIP_HEIGHT).clipping(1).anchor(0, 100);
        flowNode = cl.addnode().pos(0, CLIP_HEIGHT);

        leftArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(57, 411).scale(-100, 100).setevent(EVENT_TOUCH, onMove, 1);
        rightArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(754, 411).setevent(EVENT_TOUCH, onMove, -1);

        shadowWord = bg.addsprite("storeBlack.png").pos(10, 323).visible(0);
        words = null;

        /*
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
        */
        //updateTab();
        onMove(null, null, 0, null, null, null);
    }

    //本地显示数据删除所有 被移除的士兵
    //map设定所有士兵之后 data remove sid list 更新数据
    //更新view
    function onRandom(n, e, p, x, y, points)
    {
        var removed = scene.map.randomAllSoldier(data);
        for(var i = 0; i < len(removed); i++)
        {
            data.remove(removed[i]);
        }
        updateTab();
    }
    //var lastPoints;
    //var accMove;
    /*
    点击某个士兵 之后士兵出现在场景中 
    点击士兵的头上的取消按钮 则士兵消失
    士兵显示的位置应该不变
    只是决定是否显示而已
    */
    function clearSoldier(so)
    {
        var sid = so.sid;
//        trace("soldier clear", sid);

        insertArr(data, sid, cmp);
        updateTab();
    }

    function getRange()
    {
        var oldPos = flowNode.pos(); 
        var lowCol = -oldPos[0]/OFFX;
        var upCol = (-oldPos[0]+WIDTH+OFFX-1)/OFFX;
        var total = len(data);
//        trace("getRange", data);
        return [max(0, lowCol-1), min(upCol+1, total)];

    }
    //但是数据显示的时候需要小心
    //因为人物会突然重新出现
    function updateTab()
    {
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("mapUnSel.png").pos(i*OFFX, 0).anchor(0, 100);

            panel.setevent(EVENT_TOUCH, touchBegan, data[i]);
            panel.setevent(EVENT_MOVE, touchMoved);
            panel.setevent(EVENT_UNTOUCH, touchEnded);

            var sdata = global.user.getSoldierData(data[i]);
//            trace("soldierData", sdata, data[i], i);
            //0 30 60 90
            var id = sdata.get("id");
            var solPic;
            //同动画使用 spritesheet图片
            if(id == 0 || id == 30 || id == 60 || id == 90)
                solPic = panel.addsprite("solAva"+str(sdata.get("id"))+".png").pos(45, 45).anchor(50, 50);
            else
                solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png").pos(45, 45).anchor(50, 50);

            var sca = getSca(solPic, [80, 80]);
            solPic.scale(-sca, sca);

            //panel.addlabel(sdata.get("name"), null, 18).pos(61, 40).color(0, 0, 0);
            panel.put(data[i]);
            
            panel.addsprite("skillLevel.png").pos(53, 66).anchor(50, 50);
            panel.addlabel(getStr("skillLevel", ["[LEV]", str(sdata.get("level"))]), null, 15).pos(53, 66).anchor(50, 50).color(100, 100, 100);
        }
    }

    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        var sid = p;
        controlSoldier = scene.map.addSoldier(sid);
        if(controlSoldier == null)
            return;

        var solData = global.user.getSoldierData(sid);
        var w = getStr("dragSol", ["[NAME]", solData.get("name")]);
        words = shadowWord.addlabel(w, null, 25);
        var wSize = words.prepare().size();
        var sSize = shadowWord.prepare().size();
        sSize[0] = max(wSize[0], sSize[0]);
        shadowWord.size(sSize);
        words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);
        shadowWord.visible(1);

        var nPos = n.node2world(x, y);
        var mPos = scene.map.bg.world2node(nPos[0], nPos[1]);
        controlSoldier.setPos(mPos);
        
        controlSoldier.touchWorldBegan(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
        data.remove(sid);
        //n.visible(0);//背景变蓝色
        n.texture("mapSel.png");
    }
    function touchMoved(n, e, p, x, y, points)
    {
        if(controlSoldier != null)
        {
            var nPos = n.node2world(x, y);
            controlSoldier.touchWorldMoved(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
        }
    }
    //点击士兵结束
    //如果放置士兵成功 则 删除旧士兵
    //如果放置失败 则 士兵 clearSoldier 自身 重新放置数据
    function touchEnded(n, e, p, x, y, points)
    {
        //在点击之后更新panel
        var curPos = flowNode.pos();
        var cols = -len(data)*OFFX+WIDTH;
        curPos[0] = min(0, max(cols, curPos[0]));
        flowNode.pos(curPos);
        updateTab();

        shadowWord.visible(0);
        words.removefromparent();
        words = null;

        if(controlSoldier != null)
        {
            var nPos = n.node2world(x, y);
            //nPos = controlSoldier.bg.world2node(nPos[0], nPos[1]);
//            trace("sol node end", nPos);
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
        scene.finishArrange();
    }
    function onCancel()
    {
        global.director.popScene();
    }
}
