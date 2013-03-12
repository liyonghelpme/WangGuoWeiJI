class ChildMenuLayer extends MyNode
{
    var functions;
    var scene;
    //公有的模型 和 私有的模型
    //拼凑在一起 是 全部模型

    var buts = dict([
    //public  
    ["photo", ["menu_button_photo.png", onPhoto]],
    ["drug", ["menu_button_drug.png", onDrug]],


    ["map", ["menu_button_map.png", onMap]],
    ["friend", ["menu_button_friend.png", onFriend]],
    ["mail", ["menu_button_mail.png", onMail]],
    ["plan", ["menu_button_plan.png", onPlan]],
    ["planMine", ["menu_button_plan.png", onPlanMine]],
    ["rank", ["menu_button_rank.png", onRank]],
    //["role", ["menu_button_role.png", onRole]],
    ["setting", ["menu_button_setting.png", onSetting]],
    ["store", ["menu_button_store.png", onStore]],


    ["acc", ["menu_button_acc.png", onAcc]],
    ["accDead", ["menu_button_acc.png", onAccDead]],
    ["sell", ["menu_button_sell.png", onSell]],

    ["story", ["menu_button_story.png", onStory]],
    ["soldier", ["menu_button_soldier.png", onSoldier]],
    ["collection", ["menu_button_collection.png", onCollection]],
    ["tip", ["menu_button_tip.png", onTip]],

    ["transfer", ["menu_button_transfer.png", onTransfer]],

    ["forge", ["menu_button_forge.png", onForge]],
    ["makeDrug", ["menu_button_makeDrug.png", onMakeDrug]],


    //["inspire", ["menu_button_inspire.png", onInspire]],
    ["equip", ["menu_button_equip.png", onEquip]],
    ["gather", ["menu_button_gather.png", onGather]],
    ["upgrade", ["menu_button_upgrade.png", onUpgrade]],

    ["allDrug", ["menu_button_drug.png", onAllDrug]],
    ["allEquip", ["menu_button_allEquip.png", onAllEquip]],

    //士兵状态
    

    ["menu10", ["menu_button_game0.png", onInspire]],
    ["menu11", ["menu_button_game1.png", onMoney]],

    //爱心树
    ["invite", ["menu_button_invite.png", onInvite]],

    ["upgradeBuild", ["menu_button_upgrade_build.png", onUpgrade]],

    ["call", ["menu_button_call.png", onCall]],
    
    ]);
    function onInvite()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new InviteIntro(), 1, 0);
    }
    function onCall()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new CallSoldier(scene), 1, 0);
    }

    function onBlood()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();
    }
    //显示药店
    function onHeart()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();
        //隐藏菜单栏 游戏结束显示菜单栏
        //global.director.curScene.showGame(scene, SOL_GAME);//当前士兵游戏
        //global.director.pushView(new GameOne(scene, HEART_STATUS), 0, 0);

    }

    var playGatherNow = 0;
    function onGather()
    {
        var cost = dict([["gold", PARAMS["gatherGold"]]]);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sureToGather", ["[NUM]", str(PARAMS["gatherGold"])]), [100, 100, 100], null));

            buyable.pop("ok");
            var it = buyable.items();
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]), [100, 100, 100], null));

            return;
        }
        if(playGatherNow == 0)
        {
            playGatherNow = 1;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sureToGather", ["[NUM]", str(PARAMS["gatherGold"])]), [100, 100, 100], null));
            return;
        }
        playGatherNow = 0;
        global.user.doCost(cost);
        global.httpController.addRequest("soldierC/playGame4", dict([["uid", global.user.uid], ["cost", json_dumps(cost)]]), null, null);

        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();
        global.director.curScene.showGame(scene, GATHER_GAME);
        //global.director.pushView(new GameFour(), 0, 0);
    }
    function onMoney()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, MONEY_GAME);//当前士兵游戏
        global.director.pushView(new GameTwo(scene, PICK_GAME), 0, 0);
    }
    function onInspire()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, SOL_GAME);//当前士兵游戏
        //global.director.pushView(new GameThree(scene), 0, 0);
    }

    

    function onAllDrug()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new AllGoods(DRUG), 1, 0);
    }
    function onAllEquip()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new AllGoods(EQUIP), 1, 0);
    }

    //矿 升级
    //民居升级
    function onUpgrade()
    {
        //建筑物关闭全局菜单
        global.director.curScene.closeGlobalMenu();
        scene.funcBuild.sureToUpgrade();
    }
    //点击神像训练士兵 
    function onDrug()
    {
        global.director.curScene.closeGlobalMenu(this);
    }
    /*
    鼓舞士兵
    */
    /*
    function onInspire()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.inspireMe();   
    }
    */
    /*
    关闭城堡全局菜单
    */
    function onTip()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new TipDialog(), 1, 0);
    }
    function onEquip()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new DrugDialog(scene, EQUIP), 1, 0);
    }

    function onTransfer()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new TransferDialog(scene), 1, 0);
    }
    function onStory()
    {

    }
    function onSoldier()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new NewSoldierDialog(), 1, 0);
    }
    function onCollection()
    {
        global.director.curScene.closeGlobalMenu(this);
        //global.director.pushView(new CollectionDialog(), 1, 0);
    }
    const OFFY = 100;
    const MIDY = 200;
    const DARK_WIDTH = 128;
    /*
    scene 可能是：
       主菜单 场景
       建筑物 菜单
       士兵菜单

    右键数量是特殊代码----> 应该要分离
    */
    var mailNum = null;
    var mailBox = null;
    var callBut = null;
    var mapBut = null;
    var statusIcon = null;
    var position;
    var offset;
    function touchOnNow(n, e, p, x, y, points)
    {
        global.controller.playSound("but.mp3");
        p(); 
    }
    function ChildMenuLayer(index, funcs, s, otherFunc){
        position = index;
        scene = s;
        functions = funcs;
        var height = len(functions)*OFFY;
        //var h2 = len(otherFunc)*OFFY;
        //var mH = max(height, h2);
        var mH = height;
        offset = MIDY-mH/2;
        var fn;
        if(len(functions) == 1)
            fn = "dark0.png";
        else
            fn = "dark3.png";
        trace("currentFn", fn);
bg = sprite(fn, ARGB_8888).scale(100, 100).size(DARK_WIDTH, height);
        if(index == 0){
            bg.anchor(0, 0).pos(-DARK_WIDTH, offset);
            //bg.anchor(0, 0).pos(0, offset);
        }
        else{
            bg.anchor(100, 0).pos(800+DARK_WIDTH, offset);
            //bg.anchor(100, 0).pos(800, offset);
        }
        init();
        var temp;
        for(var i=0;i<len(funcs);i++){
            var model = buts.get(funcs[i]);

var button = bg.addsprite(model[0], ARGB_8888).scale(100, 100).anchor(50, 50).pos(DARK_WIDTH / 2, (OFFY / 2) + (OFFY * i));
            button.setevent(EVENT_TOUCH, touchOnNow, model[1]);
            if(funcs[i] == "mail")
            {
                var num = global.mailController.getMailNum();

mailBox = sprite("mailBoxNum.png", ARGB_8888).anchor(50, 50).pos(103, 32).size(33, 33).color(100, 100, 100, 100);
                button.add(mailBox);
                var w = str(num);
                if(num >= 99)
                    w = "99+";
mailNum = label(w, getFont(), 18).anchor(50, 50).pos(103, 32).color(100, 100, 100);
                button.add(mailNum, 1, 1);
                if(num == 0)
                {
                    mailBox.visible(0);
                    mailNum.visible(0);
                }
                else
                {
                    mailBox.visible(1);
                    mailNum.visible(1);
                }
            }

            if(funcs[i] == "call")
                callBut = button;
            if(funcs[i] == "map")
                mapBut = button;
            //士兵状态 按钮
            if(funcs[i] == "menu11")
            {
                statusIcon = button;
            }
        }
        if(callBut != null)
        {
            trace("showCallBut");
            global.taskModel.showHintArrow(callBut, callBut.prepare().size(), CALL_IN_CAMP, onCall);
        }
        if(mapBut != null)
            global.taskModel.showHintArrow(mapBut, mapBut.prepare().size(), MAP_ICON, onMap);
        trace("statusIcon", statusIcon);
        if(statusIcon != null)
            global.taskModel.showHintArrow(statusIcon, statusIcon.prepare().size(), STATUS_ICON);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_MAIL)
        {
            if(mailNum != null)
            {
                var num = global.mailController.getMailNum();
                var w = str(num);
                if(num >= 99)
                    num = "99+";
                mailNum.text(w);
                if(num == 0)
                {
                    mailNum.visible(0);
                    mailBox.visible(0);
                }
                else
                {
                    mailBox.visible(1);
                    mailNum.visible(1);
                }
            }
        }
    }
    var passTime = 0;
    function update(diff)
    {
        if(removed)
        {
            if(passTime >= getParam("hideTime"))
            {
                clearChildMenu();
            }
            passTime += diff;
        }
    }
    var removed = 0;
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_MAIL, this);
        if(position == 0)
            bg.addaction(expout(moveto(getParam("hideTime"), 0, offset)));
        else
            bg.addaction(expout(moveto(getParam("hideTime"), 800, offset)));
        global.timer.addTimer(this);
    }
    override function removeSelf()
    {
        exitScene();  
    }
    //手动删除 该节点
    function clearChildMenu()
    {
        trace("clearChildMenu");
        global.timer.removeTimer(this);
        global.msgCenter.removeCallback(UPDATE_MAIL, this);
        bg.removefromparent();
        super.exitScene();
    }
    //不清楚什么时候 调用 如果是在 addaction中调用callfunc就存在问题
    //exitScene 和 关闭子菜单的语义上还是有些区别的
    //比如隐藏 主菜单 的时候 需要关闭菜单
    override function exitScene()
    {   
        //clearChildMenu();
        if(removed)
            return;
        if(position == 0)
            bg.addaction(sequence(expin(moveto(getParam("hideTime"), -DARK_WIDTH-5, offset)), itintto(0, 0, 0, 0)));
        else
            bg.addaction(sequence(expin(moveto(getParam("hideTime"), 800+DARK_WIDTH+5, offset)), itintto(0, 0, 0, 0)));
        removed = 1;
        trace("childMenu exitScene");
    }

    function newsFeedResponse(rid, rcode)
    {
//        trace("newsFeedSuc", rid, rcode);
    }
    function uploadResponse(rid, rcode, con, param)
    {
//        trace("uploadContent", rid, rcode, con, param);
        var pid = con.get("pid");
        doShare(getStr("enjoyGame", ["[NAME]", global.user.papayaName]), null, pid, newsFeedResponse, null);
    }
    function photoFinish(node, bitmap, param)
    {
        var bytes = bitmap.bitmap2bytes("jpg");
        ppy_upload(dict([["photo",bytes]]), uploadResponse);
    }
    function onPhoto()
    {
        global.director.curScene.bg.bitmap(photoFinish)
    }
    /*
    建筑物只提供功能， 不应该假设 功能的来源 所以不应该操作关闭菜单
    而由菜单自己关闭自己---> 调用全局的关闭函数 来修改状态

    两个步骤：
        建筑物产生功能
        全局关闭菜单

    加速需要点击两次 才能 关闭菜单 因此由 建筑物 或者 士兵控制关闭
    */
    function onAcc()
    {
        scene.doAcc();
    }
    function onAccDead()
    {
        scene.doAccDead();
    }

    function onForge()
    {
        global.director.curScene.closeGlobalMenu(this);
        //global.director.pushView(new MakeDrugDialog(MAKE_EQUIP), 1, 0);
    }
    function onMakeDrug()
    {
        global.director.curScene.closeGlobalMenu(this);
        //global.director.pushView(new MakeDrugDialog(MAKE_DRUG), 1, 0);
    }
    /*
    关闭建筑的全局 控制view
    子菜单 自己关闭自己 
    而不是调用者清理

    因为卖出 和加速需要 弹出新的对话框 所有需要首先关闭旧的对话框
    */
    function onSell()
    {
        //global.director.curScene.closeGlobalMenu(this);
        scene.doSell();
    }

    function showMenu()
    {
        bg.addaction(fadein(1000));
    }
    function hideMenu()
    {
        bg.addaction(fadeout(1000));
    }
    function onClicked(param)
    {
//        trace("click", param) 

    }
    function onMap()
    {
        scene.ml.cancelAllMenu();
        //global.director.pushScene(new MapScene());    
        scene.onMap();
    }
    function onFriend()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new FriendDialog(FRIEND_DIA_HOME), 1, 0);
    }
    function onMail()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new MailDialog(), 1, 0);
    }
    /*
    规划水晶矿
    */
    function onPlanMine()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.curScene.doPlan(); 
    }
    function onPlan()
    {
        scene.ml.cancelAllMenu();
        scene.doPlan(); 
    }
    function onRank()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new RankDialog(CHALLENGE_RANK), 1, 0);
    }
    function onSetting()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new SettingDialog(), 1, 0);
    }
    function onStore()
    {
        scene.ml.cancelAllMenu();
        scene.onStore();
        //global.director.pushView(new Store(scene), 1, 0);
    }
}
