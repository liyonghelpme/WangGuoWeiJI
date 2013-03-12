const SLOW_MOVE_TIME = 70000;
const FAST_MOVE_TIME = 50000;
const NEW_CLOUD_TIME = 9000;

class Cloud extends MyNode
{
    var map;
    function Cloud(m, k)
    {
        map = m;
        var y = rand(300);
bg = sprite(("cloud" + str(k)) + ".png", ARGB_8888).pos(-700, y);
        init();
        if(k == 2 || k == 5)
            bg.addaction(sequence(
                    moveto(FAST_MOVE_TIME+rand(3000), 3000, 0), callfunc(remove)));
        else
            bg.addaction(sequence(
                    moveto(SLOW_MOVE_TIME+rand(3000), 3000, 0), callfunc(remove)));
    }
    function remove()
    {
        removeSelf();
        map.remove(this);
    }
}

class Water extends MyNode
{
    function Water()
    {
        load_sprite_sheet("rl0_.plist");
        load_sprite_sheet("rl1_.plist");
        load_sprite_sheet("rl2_.plist");
        load_sprite_sheet("rl3_.plist");
        load_sprite_sheet("rl4_.plist");

        bg = node();
        var left = bg.addnode().pos(610, 362);
var l0 = left.addsprite("", ARGB_8888).pos(42, 21).addaction(repeat(animate(2000, ["rl0_.plist/rl0_1.png", "rl0_.plist/rl0_2.png", "rl0_.plist/rl0_3.png", "rl0_.plist/rl0_4.png", "rl0_.plist/rl0_5.png", "rl0_.plist/rl0_6.png", "rl0_.plist/rl0_7.png"])));

var l1 = left.addsprite("", ARGB_8888).pos(338, 75).addaction(repeat(animate(2000, ["rl1_.plist/rl1_1.png", "rl1_.plist/rl1_2.png", "rl1_.plist/rl1_3.png", "rl1_.plist/rl1_4.png", "rl1_.plist/rl1_5.png", "rl1_.plist/rl1_6.png", "rl1_.plist/rl1_7.png"])));

var l2 = left.addsprite("", ARGB_8888).pos(297, 315).addaction(repeat(animate(2000, ["rl2_.plist/rl2_1.png", "rl2_.plist/rl2_2.png", "rl2_.plist/rl2_3.png", "rl2_.plist/rl2_4.png", "rl2_.plist/rl2_5.png", "rl2_.plist/rl2_6.png", "rl2_.plist/rl2_7.png"])));
var l3 = left.addsprite("", ARGB_8888).pos(372, 406).addaction(repeat(animate(2000, ["rl3_.plist/rl3_1.png", "rl3_.plist/rl3_2.png", "rl3_.plist/rl3_3.png", "rl3_.plist/rl3_4.png", "rl3_.plist/rl3_5.png", "rl3_.plist/rl3_6.png", "rl3_.plist/rl3_7.png"])));
var l4 = left.addsprite("", ARGB_8888).pos(358, 628).addaction(repeat(animate(2000, ["rl4_.plist/rl4_1.png", "rl4_.plist/rl4_2.png", "rl4_.plist/rl4_3.png", "rl4_.plist/rl4_4.png", "rl4_.plist/rl4_5.png", "rl4_.plist/rl4_6.png", "rl4_.plist/rl4_7.png"])));
        load_sprite_sheet("rr0_.plist");
        load_sprite_sheet("rr1_.plist");
        load_sprite_sheet("rr2_.plist");
        load_sprite_sheet("rr3_.plist");

        var rPos = [
        [239, 224],
        [134, 339],
        [237, 484],
        [346, 685]
        ];
        var right = bg.addnode().pos(1825, 363);
var r0 = right.addsprite("", ARGB_8888).pos(rPos[0]).addaction(repeat(animate(2000, ["rr0_.plist/rr0_1.png", "rr0_.plist/rr0_2.png", "rr0_.plist/rr0_3.png", "rr0_.plist/rr0_4.png", "rr0_.plist/rr0_5.png", "rr0_.plist/rr0_6.png", "rr0_.plist/rr0_7.png"])));
var r1 = right.addsprite("", ARGB_8888).pos(rPos[1]).addaction(repeat(animate(2000, ["rr1_.plist/rr1_1.png", "rr1_.plist/rr1_2.png", "rr1_.plist/rr1_3.png", "rr1_.plist/rr1_4.png", "rr1_.plist/rr1_5.png", "rr1_.plist/rr1_6.png", "rr1_.plist/rr1_7.png"])));
var r2 = right.addsprite("", ARGB_8888).pos(rPos[2]).addaction(repeat(animate(2000, ["rr2_.plist/rr2_1.png", "rr2_.plist/rr2_2.png", "rr2_.plist/rr2_3.png", "rr2_.plist/rr2_4.png", "rr2_.plist/rr2_5.png", "rr2_.plist/rr2_6.png", "rr2_.plist/rr2_7.png"])));
var r3 = right.addsprite("", ARGB_8888).pos(rPos[3]).addaction(repeat(animate(2000, ["rr3_.plist/rr3_1.png", "rr3_.plist/rr3_2.png", "rr3_.plist/rr3_3.png", "rr3_.plist/rr3_4.png", "rr3_.plist/rr3_5.png", "rr3_.plist/rr3_6.png", "rr3_.plist/rr3_7.png"])));
    }
}
class Sky extends MyNode
{
    function Sky()
    {
        bg = node();
        init();
bg.addsprite("sky0.png", RGB_565).pos(0, 0);
bg.addsprite("sky1.png", RGB_565).pos(1000, 0);
bg.addsprite("sky2.png", RGB_565).pos(2000, 0);
        
    }
}

class CastlePage extends MyNode
{
    var farm;
    var build;
    var train;
    var touchDelegate;

    var fallGoods;
    var scene;
    var buildLayer;

    var dialogController;
    var solNum;
    var box = null;//登录发现有宝箱  产生新的宝箱 宝箱已经被开启 

    function getLoginRewardOver(rid, rcode, con, param)
    {
        trace("getLoginRewardOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            var loginDays = param;
            global.user.setValue("loginDays", loginDays);
            dialogController.addCmd(dict([["cmd", "login"], ["loginDays", loginDays]]));

            if(global.user.week == 0)//每周第一次登录
            {
                dialogController.addCmd(dict([["cmd", "update"]]));
                dialogController.addCmd(dict([["cmd", "heart"]]));
            }
        }
    }

    function initDataOver()
    {
        touchDelegate.setScaleLimit(getParam("businessMinSca"), getParam("businessMaxSca"));
        trace("beginInit castlePage");
        buildLayer.initDataOver();
        solNum.updateSolNum(str(global.user.getSolNum()));
        trace("finish buildLayer");
        /*
        检测是否今天第一次登录 以及连续登录次数
        传递奖励数据给后台
        */


        //新手阶段 没有登录奖励

        var conDays = global.user.getValue("loginDays");

        var diff = checkFirstLogin();
        var day = 0;
        if(diff == 1)
        {
            day = conDays+1;
        }
        else if(diff > 1)
        {
            day = 1;
        }



        var reward = null;
        //first login Today
        if(day >= 1)
        {
            //每天第一次登录清理推荐数据 
            global.user.db.remove("recommand");
            reward = getLoginReward(day);
            
            trace("getParam DEBUG", getParam("DEBUG"), getParam("debugLoginReward"), day);
            if(getParam("DEBUG") && getParam("debugLogin"))
            {
                //测试登录奖励
                global.httpController.addRequest("getLoginReward", dict([["uid", global.user.uid], ["reward", json_dumps(reward)]]), getLoginRewardOver, day);
            }
            else
            {
                if(global.user.getValue("newTaskStage") >= getParam("showFinish"))
                    global.httpController.addRequest("getLoginReward", dict([["uid", global.user.uid], ["reward", json_dumps(reward)]]), getLoginRewardOver, day);
            }
        
            //每周第一次登录 发送登录每天任务完成提示
        }
        trace("finishLoginReward", day);

        trace("box", global.user.hasBox);
        if(global.user.hasBox)
        {
            box = new BoxOnMap(this);
            addChild(box);
        }
        trace("finishBox onMap");

        //新手任务完成才检测是否下载图片
        if(global.user.getValue("newTaskStage") >= getParam("showFinish") && global.pictureManager.checkNeedDownload())
        {
            dialogController.addCmd(dict([["cmd", "download"]])); 
        }
        trace("finishDownload");

        if(getParam("debugNewReward"))
        {
            dialogController.addCmd(dict([["cmd", "newTaskReward"]]));
        }
    }
    
    
    function CastlePage(s, showLoading)
    {
        scene = s;
        //场景居中， 没有缩放
        bg = node().size(MapWidth, MapHeight).pos(global.director.disSize[0]/2-MapWidth/2, global.director.disSize[1]/2-MapHeight/2);
        init();
        
        var sky = new Sky();
        addChildZ(sky, -2);


var flow0 = bg.addsprite("flow0.png", ARGB_8888).pos(0, 48).setevent(EVENT_TOUCH, goFlow, 0);
var banner = flow0.addsprite("build126.png", ARGB_8888).pos(262, 44).anchor(50, 100);

banner.addlabel("50", getFont(), 22, FONT_BOLD).pos(30, 11).anchor(50, 50).color(0, 0, 0);

bg.addsprite("flow1.png", ARGB_8888).pos(1650, 25).addaction(repeat(moveby(5000, 80, 0), moveby(5000, -80, 0))).setevent(EVENT_TOUCH, visitNeibor);

bg.addsprite("flow2.png", ARGB_8888).anchor(50, 100).pos(2431, 222).setevent(EVENT_TOUCH, onCryIsland, 1).addaction(repeat(moveby(9000, 100, 0), moveby(9000, -100, 0)));

bg.addsprite("mapInIcon.png", ARGB_8888).pos(1473, 309).anchor(50, 100).addaction(repeat(moveby(500, 0, -20), moveby(500, 0, 20))).setevent(EVENT_TOUCH, onMap);


        farm = new FarmLand(this);
        addChild(farm);
        build = new BuildLand(this);
        addChild(build);
        train = new TrainLand(this);
        addChild(train);


        addChild(new Water());

        //px - (1+1)*32/2 = pYN  / 32 = 26
        //py - (1+1)*16 = pYN / 16 = 48
        //260048 特殊的固定建筑 不能移动 也不能任意的点击 由客户端确定的建筑
        //banner = bg.addsprite("build126.png").pos(864+30+30, 800).anchor(50, 100).setevent(EVENT_TOUCH, onBanner);
        solNum = new SoldierNumBanner(this); 
        addChild(solNum);

        //solNum = banner.addlabel("50", "fonts/heiti.ttf", 22, FONT_BOLD).pos(30, 11).anchor(50, 50).color(0, 0, 0);

        buildLayer = new BuildLayer(this);
        addChild(buildLayer);


        fallGoods = new FallGoods(this, buildLayer);
        addChild(fallGoods);

        
        touchDelegate = new StandardTouchHandler();
        touchDelegate.setBg(bg, null);
        touchDelegate.scaMax = getParam("businessMaxSca");
        touchDelegate.scaMin = getParam("businessMinSca");



        dialogController = new DialogController(this);
        addChild(dialogController);
        //首次登录 才 loading初始化数据
        //if(showLoading)
        //    dialogController.addCmd(dict([["cmd", "initLoading"]]));


        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

    }
    function onCryIsland()
    {
        //global.director.pushScene(new MineScene()); 
    }

    function visitNeibor()
    {
        var lastVisit = global.user.lastVisitNeibor;
        var neibors = global.friendController.getNeibors();
        var friendScene;
        if(neibors == null)
        {
            return;
        }
        else
        {
            if(len(neibors) == 0)
            {
                //global.director.pushView(new MyWarningDialog(getStr("noNeibor", null), getStr("noNeiborCon", null), null), 1, 0);
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("noNeiborCon", null), [100, 100, 100], null));
                return;
            }
            lastVisit %= len(neibors);
            //papayaId
            friendScene = new FriendScene(neibors[lastVisit].get("id"), lastVisit, VISIT_NEIBOR, neibors[lastVisit].get("crystal"), neibors[lastVisit]);
            //global.director.pushScene(friendScene);
            global.director.curScene.addChildZ(friendScene, -1);
            global.director.pushView(new VisitDialog(friendScene, FRIEND_DIA_HOME), 1, 0);
        }
    }
    function onBanner()
    {
        global.director.pushView(new SoldierMax(), 1, 0); 
    }
    function goFlow(n, e, p, x, y, points)
    {
        //global.director.pushScene(new FlowScene(p));
        //global.director.pushView(new MyWarningDialog(getStr("notOpen", null), getStr("comeSoon", null), null), 1, 0);
        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("comeSoon", null), [100, 100, 100], null));
    }
    function onMap()
    {
        global.director.pushScene(new MapScene());
    }


    var inBuilding = 0;
    var curBuild = null;
    /*
    初始建造时建筑的zord 为最大， 
    保证可以控制
    */
    function beginBuild(building)
    {
        inBuilding = 1;
        curBuild = new Building(buildLayer, building, null);
        curBuild.setBid(global.user.getNewBid());
        
        //新建筑需要寻找当前屏幕中心位置的一片空地

        curBuild.setInitPos();

        buildLayer.addBuilding(curBuild, MAX_BUILD_ZORD);
        var kind = building.get("kind");
        //所有调用moveToPoint 的地方记录 旧的位置和 比例尺
        oldScale = bg.scale();
        oldPos = bg.pos();
        moveToPoint(curBuild.getPos()[0], curBuild.getPos()[1]);
        return curBuild;
    }
    //spawn scale move
    var movToAni = null;
    function clearAnimation()
    {
        if(movToAni != null)
        {
            movToAni.stop();
            movToAni = null;
        }
    }

    /*
    先缩放再移动 保留旧的缩放比例
    屏幕中心移动到建筑物 或者士兵

    根据建筑 还是 士兵 类型 确定 缩放比例
    */
    var oldScale = null;
    var oldPos = null;
    function moveToBuild(build)
    {
        oldScale = bg.scale();
        var sm = 150;
        if(build.isBuilding == 0)//士兵 缩放 200
            sm = getParam("MoveSolScale");
        touchDelegate.scaleToMax(sm);

        oldPos = bg.pos();
        var bSize = build.bg.size();
        var bPos = build.getPos();
        bPos[1] -= bSize[1]/2;
        moveToPoint(bPos[0], bPos[1]);
    }
    //结束后不调整尺寸和 位置
    //应该先 调整scale 再 保存位置
    function moveToCertainPos(s, p)
    {
        oldScale = bg.scale();
        touchDelegate.scaleToMax(s);
        oldPos = bg.pos();
        moveToPoint(p[0], p[1]);
    }
    function moveToNormal(build)
    {
        var sm = 100;
        touchDelegate.scaleToMax(sm);
        oldScale = bg.scale();

        oldPos = bg.pos();
        var bSize = build.bg.size();
        var bPos = build.getPos();
        bPos[1] -= bSize[1]/2;
        moveToPoint(bPos[0], bPos[1]);
    }

    //如果没有进入游戏则可以恢复到原来的位置
    function closeGlobalMenu()
    {
        if(oldScale != null && !movToAni)
        {
            //touchDelegate.scaleToOld(oldScale, oldPos);
            clearAnimation();
            movToAni = sequence(spawn(scaleto(500, oldScale[0], oldScale[1]), moveto(500, oldPos[0], oldPos[1])), callfunc(finishMove));
            bg.addaction(movToAni);

            oldScale = null;
            oldPos = null;
        }
    }
    //外部不应该直接调用moveToPoint 需要保存内部状态
    //var inMove = 0;
    function moveToPoint(tarX, tarY)
    {
        //小心如果其它功能强制需要移动 例如新手任务 则 不能阻止这个操作
        //主要是为了避免地图拖出边界的问题
        //地图出边界应该在move结束自动调整一下
        //if(movToAni != null )
        //    return;

        var worldPos = bg.node2world(tarX, tarY);
        var sSize = global.director.disSize;
        var difx = sSize[0]/2-worldPos[0];
        var dify = sSize[1]/2-worldPos[1];
        var curPos = bg.pos();
        curPos[0] += difx;
        curPos[1] += dify;

        var backSize = bg.size();
        bg.pos(0, 0);
        var maxX = 0;
        var maxY = 0;
        var w2 = bg.node2world(backSize[0], backSize[1])
        var minX = sSize[0]-w2[0];
        var minY = sSize[1]-w2[1];

        curPos[0] = min(max(minX, curPos[0]), maxX);
        curPos[1] = min(max(minY, curPos[1]), maxY);
        
        var newScale = bg.scale();
        bg.scale(oldScale);
        bg.pos(oldPos);

        clearAnimation();
        trace("oldScale, newScale", oldScale, newScale);
        //缩小
        //if(oldScale > newScale)
        //movToAni = spawn(expin(scaleto(500, newScale[0], newScale[1])), expin(moveto(500, curPos[0], curPos[1])));
        //else
        //inMove = 1;
        movToAni = sequence(spawn(expout(scaleto(500, newScale[0], newScale[1])), expout(moveto(500, curPos[0], curPos[1]))), callfunc(finishMove));
        bg.addaction(movToAni);
        //bg.pos(curPos);
    }
    function finishMove()
    {
        //inMove = 0;
        movToAni = null;
        trace("clearMovToAni", movToAni);
        adjustPosAndScale();
    }
    //调整地图位置和缩放比例
    function adjustPosAndScale()
    {
    }

    function finishBuild()
    {
        trace("page finishBuild");
        inBuilding = 0; 
        curBuild.finishBuild();
        curBuild = null;
    }
    function cancelBuild()
    {
        inBuilding = 0;
        //buildLayer.removeChild(curBuild);
        //global.user.removeBuild()
        buildLayer.removeBuilding(curBuild);
        curBuild = null;
    }
    function onSwitch()
    {
        curBuild.onSwitch();
    }
    var touchBuild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        //不应该清楚菜单的显示
        if(!movToAni)
        {
            scene.clearHideTime();
            scene.closeGlobalMenu(this);
        }

        trace("movToAni", movToAni);
        //在游戏2中 需要设定士兵的 移动目标位置
        if(scene.inGame)
        {
            if(scene.gameId == MONEY_GAME)//点击金钱游戏才有必要移动士兵
            {
                var pp = n.node2world(x, y);
                pp = bg.world2node(pp[0], pp[1]);
                scene.curBuild.setTarPos(pp[0], pp[1]);
            }
        }
        else if(movToAni == null)
            touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        if(!scene.inGame && movToAni == null && !scene.checkHasMenu())
            touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(!scene.inGame && movToAni == null && !scene.checkHasMenu())
            touchDelegate.tEnded(n, e, p, x, y, points);
    }
    //从 闯关页面 返回到 经营 页面 完成 闯关任务
    override function enterScene()
    {
//        trace("castal Enter Scene");
        super.enterScene();
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(BUYSOL, this);
        global.msgCenter.registerCallback(LEVEL_UP, this);
        global.msgCenter.registerCallback(FINISH_NAME, this);
        global.msgCenter.registerCallback(UPGRADE_LOVE_TREE, this);
        global.msgCenter.registerCallback(GEN_NEW_BOX, this);
        global.msgCenter.registerCallback(OPEN_BOX, this);
        global.msgCenter.registerCallback(SHOW_NEW_TASK_REWARD, this);
        global.msgCenter.registerCallback(SHOW_NEW_STAGE, this);
        global.msgCenter.registerCallback(HAS_CHALLENGE_MSG, this);
        global.msgCenter.registerCallback(MOVE_TO_POINT, this);
        global.msgCenter.registerCallback(LEVEL_UP_NOW, this);
        solNum.updateSolNum(str(global.user.getSolNum()));

        //如果当前新手任务状态 是 NOW_IN_BUSI 则完成 阶段1的闯关任务
    }

    //购买士兵 只是增加士兵数量
    //购买士兵 添加一个新的士兵
    //士兵卖出 也更新士兵状态
    function receiveMsg(msg)
    {
        if(msg[0] == MOVE_TO_POINT)
        {
            moveToCertainPos(100, msg[1]);
        }
        else if(msg[0] == BUYSOL)
        {
            solNum.updateSolNum(str(global.user.getSolNum()));
            var sid = msg[1];
            if(sid != null)//不是卖出士兵
            {
                var sdata = global.user.getSoldierData(sid);
                var newSol = new BusiSoldier(buildLayer, getData(SOLDIER, sdata.get("id")), sdata, sid, 0);
                buildLayer.addSoldier(newSol);
                newSol.setRandomInitPos();
                newSol.setSmoke();
                moveToCertainPos(100, newSol.getPos());
            }
        }
        else if(msg[0] == LEVEL_UP)
        {
            dialogController.addCmd(dict([["cmd", "levup"], ["castlePage", this]]));
        }
        else if(msg[0] == FINISH_NAME)
        {
            moveToNormal(msg[1]); 
        }
        else if(msg[0] == UPGRADE_LOVE_TREE)
        {
            dialogController.addCmd(dict([["cmd", "loveUpgrade"], ["level", msg[1]]]));
        }
        else if(msg[0] == GEN_NEW_BOX)
        {
            if(global.user.hasBox && box == null)
            {
                box = new BoxOnMap(this);
                addChild(box);
            }
        }
        else if(msg[0] == OPEN_BOX)
        {
            if(global.user.hasBox == 0 && box != null)
            {
                box.removeSelf();
                box = null;
            }
        }
        else if(msg[0] == SHOW_NEW_TASK_REWARD)
        {
            dialogController.addCmd(dict([["cmd", "newTaskReward"]]));
        }
        else if(msg[0] == SHOW_NEW_STAGE)
        {
            //有新手任务没有完成需要显示
            dialogController.addCmd(dict([["cmd", "newTaskDialog"]]));
        }
        else if(msg[0] == HAS_CHALLENGE_MSG)
        {
            dialogController.addCmd(dict([["cmd", "hasChallengeMsg"], ["challengeMsg", msg[1]]]));
        }
        else if(msg[0] == LEVEL_UP_NOW)
            dialogController.addCmd(dict([["cmd", "levup"], ["castlePage", this]]));

    }
    function remove(c)
    {
        clouds.remove(c);
    }
    var clouds = [];
    var lastTime = 1000000;
    var storeSolTime = 0;
    function update(diff)
    {
        lastTime += diff;
        if(lastTime >= NEW_CLOUD_TIME)
        {
            lastTime = 0;
            if(len(clouds) < 8 && rand(3) == 0)
            {
                var r = rand(7);
                var c = new Cloud(this, r);
                addChildZ(c, -1);
            }
        }

        //30s store 
        storeSolTime += diff;
        if(storeSolTime >= 30000)
        {
            storeSolTime = 0;
            if(scene.Planing == 0)//当前没有进行规划 则保存士兵位置
                global.user.storeOldPos(buildLayer.mapGridController.allSoldiers);
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(LEVEL_UP_NOW, this);
        global.msgCenter.removeCallback(MOVE_TO_POINT, this);
        global.msgCenter.removeCallback(HAS_CHALLENGE_MSG, this);
        global.msgCenter.removeCallback(SHOW_NEW_STAGE, this);
        global.msgCenter.removeCallback(SHOW_NEW_TASK_REWARD, this);
        global.msgCenter.removeCallback(OPEN_BOX, this);
        global.msgCenter.removeCallback(GEN_NEW_BOX, this);
        global.msgCenter.removeCallback(UPGRADE_LOVE_TREE, this);
        global.msgCenter.removeCallback(FINISH_NAME, this);
        global.msgCenter.removeCallback(LEVEL_UP, this);
        global.msgCenter.removeCallback(BUYSOL, this);
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
