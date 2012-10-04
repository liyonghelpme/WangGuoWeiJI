class ChildMenuLayer extends MyNode
{
    var functions;
    var scene;
    var buts = dict([
    ["map", ["menu_button_map.png", onMap]],
    ["friend", ["menu_button_friend.png", onFriend]],
    ["mail", ["menu_button_mail.png", onMail]],
    ["plan", ["menu_button_plan.png", onPlan]],
    ["rank", ["menu_button_rank.png", onRank]],
    ["role", ["menu_button_role.png", onRole]],
    ["setting", ["menu_button_setting.png", onSetting]],
    ["store", ["menu_button_store.png", onStore]],

    ["photo", ["menu_button_photo.png", onPhoto]],
    ["acc", ["menu_button_acc.png", onAcc]],
    ["sell", ["menu_button_sell.png", onSell]],

    ["story", ["menu_button_story.png", onStory]],
    ["soldier", ["menu_button_soldier.png", onSoldier]],
    ["collection", ["menu_button_collection.png", onCollection]],
    ["tip", ["menu_button_tip.png", onTip]],

    ["relive", ["menu_button_relive.png", onRelive]],
    ["transfer", ["menu_button_transfer.png", onTransfer]],

    ["forge", ["menu_button_forge.png", onForge]],
    ["makeDrug", ["menu_button_makeDrug.png", onMakeDrug]],

    ["drug", ["menu_button_drug.png", onDrug]],
    //["inspire", ["menu_button_inspire.png", onInspire]],
    ["equip", ["menu_button_equip.png", onEquip]],
    ["gather", ["menu_button_gather.png", onGather]],
    ["train", ["menu_button_train.png", onTrain]],
    ["upgrade", ["menu_button_upgrade.png", onUpgrade]],

    ["allDrug", ["menu_button_allDrug.png", onAllDrug]],
    ["allEquip", ["menu_button_allEquip.png", onAllEquip]],
    ["skill", ["menu_button_skill.png", onSkill]],

    //士兵状态
    ["menu0", ["menu0.png", onBlood]],
    ["menu1", ["menu1.png", onHeart]],
    ["menu2", ["menu2.png", onTranStatus]],
    ["menu3", ["menu3.png", onInspire]],
    ["menu4", ["menu4.png", onSunFlower]],
    ["menu5", ["menu5.png", onSun]],
    ["menu6", ["menu6.png", onFlower]],
    ["menu7", ["menu7.png", onStar]],
    ["menu8", ["menu8.png", onMoon]],

    //爱心树
    ["invite", ["menu_button_invite.png", onInvite]],
    ["love", ["menu1.png", onLove]],
    ["loveRank", ["menuLoveRank.png", onLoveRank]],

    ["singleTrain", ["menu_button_train.png", onSingleTrain]],
    ["upgradeBuild", ["menu_button_upgrade_build.png", onUpgrade]],

    ["call", ["menu_button_call.png", onCall]],
    
    ]);
    function onInvite()
    {
    }
    function onCall()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new CallSoldier(scene), 1, 0);
    }
    //单人练级 传入当前人物
    function onSingleTrain()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new TrainDialog(scene.sid), 1, 0);
    }

    function onLove()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new LoveDialog(scene), 1, 0);
    }
    function onLoveRank()
    {
        global.director.curScene.closeGlobalMenu(this);
        //global.director.pushView(new HeartRankDialog());
        global.director.pushView(new RankDialog(HEART_RANK), 1, 0);
    }
    function onBlood()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();
        global.director.pushView(new DrugDialog(scene, DRUG), 1, 0);
    }
    function onHeart()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();
        //隐藏菜单栏 游戏结束显示菜单栏
        global.director.curScene.showGame(scene, SOL_GAME);//当前士兵游戏
        global.director.pushView(new GameOne(scene, HEART_STATUS), 0, 0);
    }
    function onTranStatus()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();
        global.director.pushView(new SoldierDialog(2), 1, 0);
    }
    function onInspire()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, SOL_GAME);//当前士兵游戏
        global.director.pushView(new GameOne(scene, INSPIRE_STATUS), 0, 0);
    }

    function onSunFlower()
    {
        global.director.curScene.closeGlobalMenu(this);//这个会显示菜单
        scene.clearStatus();
        //操作士兵 
        global.director.curScene.showGame(scene, MONEY_GAME);//当前士兵游戏 这个会隐藏菜单
        global.director.pushView(new GameTwo(scene, SUNFLOWER_STATUS), 0, 0);
    }
    function onSun()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, MONEY_GAME);//当前士兵游戏 这个会隐藏菜单
        global.director.pushView(new GameTwo(scene, SUN_STATUS), 0, 0);
    }
    function onFlower()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, MONEY_GAME);//当前士兵游戏 这个会隐藏菜单
        global.director.pushView(new GameTwo(scene, FLOWER_STATUS), 0, 0);
    }
    function onStar()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, MONEY_GAME);//当前士兵游戏 这个会隐藏菜单
        global.director.pushView(new GameTwo(scene, STAR_STATUS), 0, 0);
    }
    function onMoon()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.clearStatus();

        global.director.curScene.showGame(scene, MONEY_GAME);//当前士兵游戏 这个会隐藏菜单
        global.director.pushView(new GameTwo(scene, MOON_STATUS), 0, 0);
    }
    

    //soldier skill
    function onSkill()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new SkillDialog(scene), 1, 0);
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
    function onTrain()
    {
        global.director.curScene.closeGlobalMenu(this);
        //scene.doTrain();
        //没有士兵则无法练级
        global.director.pushView(new TrainDialog(null), 1, 0);
    }
    function onDrug()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new DrugDialog(scene, DRUG), 1, 0);
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
    function onGather()
    {
    }
    function onRelive()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new SoldierDialog(1), 1, 0);
    }
    function onTransfer()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new SoldierDialog(2), 1, 0);
    }
    function onStory()
    {

    }
    function onSoldier()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new SoldierDialog(0), 1, 0);
    }
    function onCollection()
    {
    }
    const OFFY = 100;
    const MIDY = 200;
    const DARK_WIDTH = 128;
    /*
    scene 可能是：
       主菜单 场景
       建筑物 菜单
       士兵菜单
    */
    function ChildMenuLayer(index, funcs, s, otherFunc){
        scene = s;
        functions = funcs;
        var height = len(functions)*OFFY;
        var h2 = len(otherFunc)*OFFY;
        var mH = max(height, h2);
        var offset = MIDY-mH/2;
        bg=sprite("dark0.png").scale(100,100).size(DARK_WIDTH, height);
        if(index == 0){
            bg.anchor(0, 0).pos(0, offset);
        }
        else{
            bg.anchor(100, 0).pos(800, offset);
        }
        init();
        
        for(var i=0;i<len(funcs);i++){
            var model = buts.get(funcs[i]);

            var button = bg.addsprite(model[0]).scale(100,100).anchor(50,50).pos(DARK_WIDTH/2, OFFY/2+OFFY*i);
            new Button(button, model[1], null);
        }
    }
    /*
    function touchMenu(callback)
    {
        //removeSelf();
        callback();
    }
    */
    function newsFeedResponse(rid, rcode)
    {
//        trace("newsFeedSuc", rid, rcode);
    }
    function uploadResponse(rid, rcode, con, param)
    {
//        trace("uploadContent", rid, rcode, con, param);
        var pid = con.get("pid");
        ppy_postnewsfeed("just post a screenshot", null, pid, newsFeedResponse);
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
        //global.director.curScene.closeGlobalMenu(this);
        scene.doAcc();
    }
    function onForge()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new MakeDrugDialog(MAKE_EQUIP), 1, 0);
    }
    function onMakeDrug()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new MakeDrugDialog(MAKE_DRUG), 1, 0);
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
        global.director.pushView(new FriendDialog(), 1, 0);
    }
    function onMail()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new MailDialog(), 1, 0);
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
    function onRole()
    {
        scene.ml.cancelAllMenu();
        scene.onRole();
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
