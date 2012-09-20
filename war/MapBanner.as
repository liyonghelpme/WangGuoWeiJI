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
    function MapBanner(sc)
    {
        scene = sc;
        bg = node();
        init();
        initData();
        
        //117
        if(scene.kind != CHALLENGE_TRAIN)
        {
            okBut = bg.addsprite("mapMenuOk.png", GRAY).pos(440, 19).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("mapMenuCancel.png").pos(557, 19).setevent(EVENT_TOUCH, onCancel);
            //练级没有随机放置功能
            bg.addsprite("random.png").pos(674, 19).setevent(EVENT_TOUCH, onRandom);
        }
        else
        {
            okBut = bg.addsprite("mapMenuOk.png", GRAY).pos(557, 19).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("mapMenuCancel.png").pos(674, 19).setevent(EVENT_TOUCH, onCancel);
        }

        cl = bg.addnode().pos(103, 461).size(CLIP_WIDTH, CLIP_HEIGHT).clipping(1).anchor(0, 100);
        flowNode = cl.addnode().pos(0, CLIP_HEIGHT);

        leftArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(57, 411).scale(-100, 100).setevent(EVENT_TOUCH, onMove, 1);
        rightArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(754, 411).setevent(EVENT_TOUCH, onMove, -1);

        shadowWord = bg.addsprite("storeBlack.png").pos(10, 313);//.visible(0);
        shadowWord.addaction(itintto(0, 0, 0, 0));
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
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel;
            if(data[i][1] == 0)
                panel = flowNode.addsprite("mapUnSel.png").pos(i*OFFX, 0).anchor(0, 100);
            else
                panel = flowNode.addsprite("mapUnSel.png", GRAY).pos(i*OFFX, 0).anchor(0, 100);
                
            if(data[i][1] == 0)
            {
                panel.setevent(EVENT_TOUCH, touchBegan, i);
                panel.setevent(EVENT_MOVE, touchMoved, i);
                panel.setevent(EVENT_UNTOUCH, touchEnded, i);
            }

            var sdata = global.user.getSoldierData(data[i][0]);
//            trace("soldierData", sdata, data[i], i);
            //0 30 60 90
            var id = sdata.get("id");
            var solPic;
            if(data[i][1] == 0)
            {
                //同动画使用 spritesheet图片
                //使用士兵头像
                if(id == 0 || id == 30 || id == 60 || id == 90)
                    solPic = panel.addsprite("solAva"+str(sdata.get("id"))+".png").pos(45, 45).anchor(50, 50);
                else
                    solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png").pos(45, 45).anchor(50, 50);
            }
            else
            {
                if(id == 0 || id == 30 || id == 60 || id == 90)
                    solPic = panel.addsprite("solAva"+str(sdata.get("id"))+".png", GRAY).pos(45, 45).anchor(50, 50);
                else
                    solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png", GRAY).pos(45, 45).anchor(50, 50);
            }

            var sca = getSca(solPic, [80, 80]);
            solPic.scale(-sca, sca);

            //panel.addlabel(sdata.get("name"), null, 18).pos(61, 40).color(0, 0, 0);
            panel.put(i);
            
            panel.addsprite("skillLevel.png").pos(57, 79).anchor(50, 50);
panel.addlabel(getStr("skillLevel", ["[LEV]", str(sdata.get("level") + 1)]), "fonts/heiti.ttf", 15).pos(57, 79).anchor(50, 50).color(100, 100, 100);
        }
    }

    var touchPos = null;
    var accMove = 0;
    var lastPoints;
    //data[p] sid isInMap data[p][1] == 0
    function touchBegan(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        //var sid = data[p][0];

        lastPoints = newPos;
        accMove = 0;

        //touchPos = bg.world2node(newPos[0], newPos[1]); 

        touchPos = n.node2world(0, 0);
        touchPos = bg.world2node(touchPos[0], touchPos[1]);//x 位置

        bg.world2node()

        n.texture("mapSel.png");

        /*
        //不能添加士兵 需要accMove
        controlSoldier = scene.map.addSoldier(sid);
        if(controlSoldier == null)
            return;



        setCurChooseSol(controlSoldier);

        var mPos = scene.map.bg.world2node(newPos[0], newPos[1]);
        controlSoldier.setPos(mPos);
        
        controlSoldier.touchWorldBegan(controlSoldier.bg, e, null, newPos[0], newPos[1], points);
        data[p][1] = 1;

        */

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
            var sid = data[p][0];
            controlSoldier = scene.map.addSoldier(sid);
            if(controlSoldier == null)
                return;

            setCurChooseSol(controlSoldier);

            var mPos = scene.map.bg.world2node(nPos[0], nPos[1]);
            controlSoldier.setPos(mPos);
            
            controlSoldier.touchWorldBegan(controlSoldier.bg, e, null, nPos[0], nPos[1], points);
            data[p][1] = 1;
            //n.texture("mapSel.png");
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
            //shadowWord.visible(0);
        }
        else
        {
            if(words != null)
            {
                words.removefromparent();
                words = null;
            }

            //shadowWord.visible(1);
            shadowWord.stop();
            shadowWord.addaction(sequence(itintto(100, 100, 100, 100), delaytime(2000), fadeout(1000)));
            var w = getStr("dragSol", ["[NAME]", sol.myName]);
words = shadowWord.addlabel(w, "fonts/heiti.ttf", 20);
            var wSize = words.prepare().size();
            var sSize = shadowWord.prepare().size();
            sSize[0] = max(wSize[0]+40, sSize[0]);
            shadowWord.size(sSize);
            words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);
            //shadowWord.visible(1);

            var oldPos = shadowWord.pos();
            //左右屏幕限制
            //按钮和士兵中心对齐
            if(touchPos != null)
            {
                //var x = min(max(touchPos[0]-sSize[0]/2, 0), global.director.disSize[0]-sSize[0]);
                var x = min(max(touchPos[0], 0), global.director.disSize[0]-sSize[0]);
                shadowWord.pos(x, oldPos[1]);
            }
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
