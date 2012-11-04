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

    const INIT_X = 80;
    const INIT_Y = 402;
    
    const OFFX = 80;
    const ITEM_NUM = 8;

    const WIDTH = 640;
    const HEIGHT = 80;

    const PANEL_WIDTH = 71;
    const PANEL_HEIGHT = 70;

    var data;
    
    //sid inMap
    function cmp(a, b)
    {
        var sa = global.user.getSoldierData(a[0]);
        var sb = global.user.getSoldierData(b[0]);
        return sb.get("level")-sa.get("level");
    }
    //[士兵sid,  0/1] 是否放置 
    //所有
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
                data.append([sols[i][0], 0]);//是否已经放置
            }
        }
        bubbleSort(data, cmp);
    }
    var leftArr;
    var rightArr;
    var shadowWord;
    var words;

    var okBut;

    /*
    将剩余士兵尽量全部放置到地面上
    每行一个逐个放置直到没有
    */
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        
        if(scene.kind == CHALLENGE_TRAIN)
        {
            temp = bg.addsprite("mapMenuCancel.png").anchor(0, 0).pos(624, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onCancel);
            okBut = bg.addsprite("mapMenuOk.png").anchor(0, 0).pos(546, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onOk);
        }
        else
        {
            temp = bg.addsprite("random.png").anchor(0, 0).pos(701, 35).size(60, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onRandom);
            temp = bg.addsprite("mapMenuCancel.png").anchor(0, 0).pos(624, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onCancel);
            okBut = bg.addsprite("mapMenuOk.png").anchor(0, 0).pos(546, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onOk);
        }

        rightArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(760, 440).size(56, 56).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onMove, -1);
        leftArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(40, 440).scale(-100, 100).size(56, 56).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onMove, 1);
    }


    function MapBanner(sc)
    {
        scene = sc;
        initView();
        initData();
        


        shadowWord = bg.addsprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);//.visible(0);
        shadowWord.addaction(itintto(0, 0, 0, 0));
        words = null;

        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1).anchor(0, 0);
        flowNode = cl.addnode().pos(0, 0);
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
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
            //data.remove(removed[i]);
            data[removed[i]][1] = 1;
        }
        updateTab();
    }
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

        //insertArr(data, sid, cmp);
        for(var i = 0; i < len(data); i++)
        {
            if(data[i][0] == sid)
            {
                data[i][1] = 0;
                break;
            }
        }
        setCurChooseSol(null);
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
        var ret = scene.map.checkMySoldier();
        if(ret)
        {
            okBut.texture("mapMenuOk.png");
        }
        else
        {
            okBut.texture("mapMenuOk.png", GRAY);
        }

        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        var temp;

        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel;
            if(data[i][1] == 0)
                panel = flowNode.addsprite("mapUnSel.png").pos(i*OFFX+PANEL_WIDTH/2, 0).anchor(50, 0);
            else
                panel = flowNode.addsprite("mapUnSel.png", GRAY).pos(i*OFFX+PANEL_WIDTH/2, 0).anchor(50, 0);
                

            var sdata = global.user.getSoldierData(data[i][0]);
            //0 30 60 90
            var id = sdata.get("id");
            var solPic;

            if(data[i][1] == 0)
            {
                solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png").pos(36, 34).anchor(50, 50);
            }
            else
            {
                solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png", GRAY).pos(36, 34).anchor(50, 50);
            }
            //使用我方特征色
            /*
            var feaFil = FEA_BLUE;
            var fea = solPic.addsprite("soldierfm"+str(sdata["id"])+".plist/ss"+str(sdata["id"])+"fm0.png", feaFil);
            */

            var sca = getSca(solPic, [71, 70]);
            solPic.scale(-sca, sca);

            temp = panel.addsprite("skillLevel.png").anchor(0, 0).pos(17, 54).size(52, 13).color(100, 100, 100, 100);
            panel.addlabel(getStr("skillLevel", ["[LEV]", str(sdata.get("level") + 1)]), "fonts/heiti.ttf", 13).anchor(50, 50).pos(41, 59).color(100, 100, 100);
            panel.put(i);
        }
    }

    var touchPos = null;
    var accMove = 0;
    var lastPoints;
    var curChild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);

        lastPoints = newPos;
        accMove = 0;

        touchPos = n.node2world(0, 0);
        touchPos = bg.world2node(touchPos[0], touchPos[1]);//x 位置

        curChild = null;
        var child = checkInChild(flowNode, lastPoints);
        if(child != null)
        {
            var i = child.get(); 
            if(data[i][1] == 0)
            {
                child.texture("mapSel.png");
                curChild = child;
            }
        }

    }
    //地图给出空闲位置
    function putSoldierOnMap(sid)
    {
        var sol = scene.map.addSoldier(sid);
        if(sol == null) 
            return;
        var mPos = scene.map.getInitPos(sol);
        if(mPos[0] != -1)
        {
            sol.setPos(mPos);
            for(var i = 0; i < len(data); i++)
            {
                if(data[i][0] == sid)
                {
                    data[i][1] = 1;
                    break;
                }
            }
            scene.map.setMap(sol);
            updateTab();
        }
        else
        {
            scene.map.removeSoldier(sol); 
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var nPos = n.node2world(x, y);
        var oldPos = lastPoints;
        lastPoints = nPos;
        var difx = lastPoints[0]-oldPos[0];
        var dify = lastPoints[1]-oldPos[1];
        accMove += abs(difx)+abs(dify);

        if(controlSoldier != null)
        {
            controlSoldier.touchWorldMoved(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
        }
        else if(accMove > 20)
        {

            if(curChild != null)
            {
                var i = curChild.get();
                var sid = data[i][0];
                controlSoldier = scene.map.addSoldier(sid);
                if(controlSoldier == null)
                    return;
                setCurChooseSol(controlSoldier);

                var mPos = scene.map.bg.world2node(nPos[0], nPos[1]);
                controlSoldier.setPos(mPos);
                
                controlSoldier.touchWorldBegan(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
                data[i][1] = 1;
            }
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


        if(controlSoldier != null)
        {
            var nPos = n.node2world(x, y);
            controlSoldier.touchWorldEnded(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
        }
        //有我方士兵 没有我方士兵
        controlSoldier = null;

        updateTab();
    }

    //点击banner set
    //地图点击士兵 选择
    function setCurChooseSol(sol)
    {
        if(sol == null)
        {
        }
        else
        {
            if(words != null)
            {
                words.removefromparent();
                words = null;
            }

            shadowWord.stop();
            shadowWord.addaction(sequence(itintto(100, 100, 100, 100), delaytime(2000), fadeout(1000)));
            var w = getStr("dragSol", ["[NAME]", sol.myName]);
            words = shadowWord.addlabel(w, "fonts/heiti.ttf", 20);
            var wSize = words.prepare().size();
            var sSize = shadowWord.prepare().size();
            sSize[0] = max(wSize[0]+40, sSize[0]);
            shadowWord.size(sSize);
            words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);

        }
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
        var ret = scene.map.checkMySoldier();
        if(ret == 0)
        {
            global.director.curScene.addChild(new UpgradeBanner(getStr("noSol", null), [100, 100, 100], null));
            return;
        }
        scene.finishArrange();
    }
    function onCancel()
    {
        global.director.popScene();
    }
}
