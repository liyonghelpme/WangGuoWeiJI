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
    
    //所有
    //sid not dead 
    function initData()
    {
        data = [];
        var sols = global.user.soldiers.items();
        var p = 0;
        for(var i = 0; i < len(sols); i++)
        {
            var sdata = sols[i][1];
            if(sdata.get("inTransfer", 0) == 0 && !sdata["inDead"])//soldierId 不再转职中
            {
                data.append([sols[i][0], 0, p]);//是否已经放置
                p++;
            }
        }
    }
    var leftArr;
    var rightArr;
    var shadowWord;
    var words;

    var okBut;
    var randomBut;
    var cancelBut;

    var isStartChallenge = 0;
    function startChallenge()
    {
        bg.add(randomBut);
        bg.add(cancelBut);
        bg.add(okBut);
        
        isStartChallenge = 1;

    }
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
        //隐藏右上角的按钮 直到开始挑战时显示
        if(scene.kind == CHALLENGE_FRI)
        {
            randomBut = sprite("random.png").anchor(0, 0).pos(701, 35).size(60, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onRandom);
            cancelBut = sprite("mapMenuCancel.png").anchor(0, 0).pos(624, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onCancel);
            okBut = sprite("mapMenuOk.png").anchor(0, 0).pos(546, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onOk);
        }
        else
        {
            temp = bg.addsprite("random.png").anchor(0, 0).pos(701, 35).size(60, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onRandom);
            randomBut = temp;
            temp = bg.addsprite("mapMenuCancel.png").anchor(0, 0).pos(624, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onCancel);
            okBut = bg.addsprite("mapMenuOk.png").anchor(0, 0).pos(546, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onOk);
        }

        rightArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(760, 440).size(56, 56).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onMove, -1);
        leftArr = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(40, 440).scale(-100, 100).size(56, 56).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onMove, 1);
    }
    function receiveMsg(param)
    {   
        var msgId = param[0];
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    function update(diff)
    {
        if(isStartChallenge)
        {
            isStartChallenge = 0;
            global.taskModel.showHintArrow(okBut, okBut.prepare().size(), CHALLENGE_OK_BUT, onOk);
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
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

    function getShowData()
    {
        var showData = [];
        for(var i = 0; i < len(data); i++){
            if(data[i][1] == 0)
                showData.append(data[i]);
        }
        return showData;
    }
    //数据显示在 data的最后面就可以了
    function getRange()
    {
        var oldPos = flowNode.pos(); 
        var lowCol = -oldPos[0]/OFFX;
        var upCol = (-oldPos[0]+WIDTH+OFFX-1)/OFFX;

        var showData = getShowData();
        var total = len(showData);

        trace("getRange", data);
        var r0 = max(0, lowCol-1);
        var r1 = min(upCol+1, total);
        return [r0, r1];
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
    
        var showData = getShowData();
        //使用showData 作为数据
        for(var i = rg[0]; i < rg[1]; i++)
        {

            var panel;
            if(showData[i][1] == 0)
                panel = flowNode.addsprite("mapUnSel.png").pos(i*OFFX+PANEL_WIDTH/2, 0).anchor(50, 0);
            else
                panel = flowNode.addsprite("mapUnSel.png", GRAY).pos(i*OFFX+PANEL_WIDTH/2, 0).anchor(50, 0);
                

            var sdata = global.user.getSoldierData(showData[i][0]);
            //0 30 60 90
            var id = sdata.get("id");
            var solPic;

            if(showData[i][1] == 0)
            {
                solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png", ARGB_8888).pos(36, 34).anchor(50, 50);
            }
            else
            {
                solPic = panel.addsprite("soldier"+str(sdata.get("id"))+".png", GRAY, ARGB_8888).pos(36, 34).anchor(50, 50);
            }
            //使用我方特征色
            /*
            var feaFil = FEA_BLUE;
            var fea = solPic.addsprite("soldierfm"+str(sdata["id"])+".plist/ss"+str(sdata["id"])+"fm0.png", feaFil);
            */

            var sca = getSca(solPic, [71, 70]);
            solPic.scale(-sca, sca);

            panel.put(showData[i][2]);//在data 中的编号 showData的长度总是变化的
        }
    }

    var touchPos = null;
    var accMove = 0;
    var lastPoints;
    var curChild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        //在开始挑战之前只能查看己方士兵
        if(!scene.checkStartChallenge())
        {
            return;
        }

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
        if(!scene.checkStartChallenge())
        {
            return;
        }

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
                //data.pop(i);//弹出这个士兵 取消之后重新放置士兵
                //标记1的士兵不显示
            }
        }
    }
    //点击士兵结束
    //如果放置士兵成功 则 删除旧士兵
    //如果放置失败 则 士兵 clearSoldier 自身 重新放置数据
    function touchEnded(n, e, p, x, y, points)
    {
        if(!scene.checkStartChallenge())
            return;

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
        onMove(null, null, 0, null, null, null);
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
words = shadowWord.addlabel(w, getFont(), 20);
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
        var showData = getShowData();
        var total = len(showData);
        var minPos = -total*OFFX+WIDTH;
        if(oldPos[0] > minPos || p > 0 )//超出最小 则只能向右移动
            oldPos[0] += p*ITEM_NUM*OFFX;
        oldPos[0] = min(0, oldPos[0]); 

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
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("noSol", null), [100, 100, 100], null));
            return;
        }
        scene.finishArrange();
    }
    function onCancel()
    {
        //调试挑战怪兽
        if(getParam("debugChallenge")) {
            var solKey = soldierData.keys();
            bubbleSort(solKey, cmpInt);
            var curSoldier = global.user.currentSoldierId;
            var zoneSize = getParam("zoneSize");
            var countNum = 0;
            var startId = curSoldier;
            for(var i = 0; i < len(solKey) && countNum < zoneSize; i++)
            {
                if(solKey[i] >= startId)
                {
                    countNum++;
                }
            }
            var newId = 10000;
            if(i < len(solKey))
                newId = solKey[i];

            global.user.currentSoldierId = newId;
            global.httpController.addRequest("updateCurrentSoldierId", dict([["sid", global.user.currentSoldierId]]), null, null);
            global.director.popScene();
            global.director.pushScene(
                new ChallengeScene(null, null, null, null, CHALLENGE_OTHER, dict())
            );
        } else
            global.director.popScene();
    }
}
