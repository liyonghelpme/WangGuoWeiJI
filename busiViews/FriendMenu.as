class FriendMenu extends MyNode
{
    var scene;

    /*
    需要修复 商店购买物品不能依赖于场景提供功能 只有购买 建筑物才可以提供功能
    要么需要一个商店的限制版本---》没有建筑页面 只有购买 水晶 银币 金币 新物品页面
    */
    function onRecharge()
    {
        var st = new Store(global.director.curScene);
        st.changeTab(GOLD_PAGE);
        global.director.pushView(st, 1, 0);
    }

    function onFriend()
    {
        global.director.pushView(new FriendDialog(FRIEND_DIA_INFRIEND), 1, 0);
    }
    var silverText;
    var crystalText;
    var goldText;

    var rightMenu = null;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("friendInfoBottom.png").anchor(0, 0).pos(0, 418).size(800, 65).color(100, 100, 100, 100);
        but0 = new NewButton("friendFriend.png", [100, 78], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onFriend, null);
        but0.bg.pos(742, 434);
        addChild(but0);
        temp = bg.addsprite("recharge.png").anchor(0, 0).pos(441, 431).size(98, 39).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onRecharge);
        temp = bg.addsprite("friendReturn.png").anchor(0, 0).pos(7, 360).size(130, 122).color(100, 100, 100, 100).setevent(EVENT_TOUCH, returnHome);
        goldText = bg.addlabel(getStr("gold", null), "fonts/heiti.ttf", 21).anchor(0, 50).pos(592, 450).color(100, 100, 100);
        silverText = bg.addlabel(getStr("silver", null), "fonts/heiti.ttf", 21).anchor(0, 50).pos(347, 451).color(100, 100, 100);
        crystalText = bg.addlabel(getStr("crystal", null), "fonts/heiti.ttf", 21).anchor(0, 50).pos(197, 450).color(100, 100, 100);


        var friends = global.friendController.getFriends(scene.kind);
        if(scene.curNum == -1 || scene.curNum >= (len(friends)-1) )
        {
            temp = bg.addsprite("friendNextBut.png", GRAY).anchor(0, 0).pos(637, -1).size(142, 93).color(100, 100, 100, 100);
        }
        else
        {
            temp = bg.addsprite("friendNextBut.png").anchor(0, 0).pos(637, -1).size(142, 93).color(100, 100, 100, 100).setevent(EVENT_TOUCH, visitNext);
        }
        temp = bg.addsprite("friendNext.png").anchor(0, 0).pos(671, 46).size(73, 23).color(100, 100, 100, 100);

        temp = bg.addsprite("friendInfo.png").anchor(0, 0).pos(15, 13).size(440, 79).color(100, 100, 100, 100);

        
        temp = bg.addsprite(avatar_url(scene.user["id"])).anchor(0, 0).pos(28, 26).size(55, 55).color(100, 100, 100, 100);
        bg.addlabel(scene.user["name"], "fonts/heiti.ttf", 21).anchor(0, 50).pos(100, 35).color(100, 100, 100);

        bg.addlabel(getStr("friLevel", ["[NUM]", str(scene.user["level"])]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(103, 67).color(0, 0, 0);
        if(scene.kind == VISIT_RANK)
            bg.addlabel(getStr("friRank", ["[NUM]", str(scene.user["rank"])]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(251, 66).color(0, 0, 0);
        //是否gray
        updateRightMenu();
    }
    function updateRightMenu()
    {
        if(rightMenu != null)
        {
            rightMenu.removeSelf();
            rightMenu = null;
        }

        //好友是否有宝箱 只能挑战邻居
        //非邻居不能挑战
        var funcs = [];
        if(scene.kind == VISIT_NEIBOR)
        {
            var neibor = global.friendController.getNeiborData(scene.user["uid"]);
            funcs = [ ["challenge", neibor["challengeYet"]]];
        }

        if(scene.hasBox)
            funcs.insert(0, ["box", 0]);

        rightMenu = new FriendRightMenu(this, funcs);
        rightMenu.setPos([746, 129]);
        addChild(rightMenu);
    }
    function receiveMsg(par)
    {
        var msgId = par[0];
        if(msgId == UPDATE_RESOURCE)
        {
            updateDate();
        }
        else if(msgId == NEIBOR_RECORD)
            updateState();
    }
    function updateState()
    {
        updateDate();
        updateRightMenu();
    }
    function updateDate()
    {
        silverText.text(str(global.user.getValue("silver")));
        goldText.text(str(global.user.getValue("gold")));
        crystalText.text(str(global.user.getValue("crystal")));
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_RESOURCE, this);
        global.msgCenter.registerCallback(NEIBOR_RECORD, this);
        updateState();
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(NEIBOR_RECORD, this);
        global.msgCenter.removeCallback(UPDATE_RESOURCE, this);
        super.exitScene();
    }
    //好友场景的 邻居数据 是 拷贝得到的 不能通过本地修改来 修改全局的状态
    //需要访问全局接口来修改状态
    function FriendMenu(s)
    {
        scene = s;
        initView();
    }
    //这里的userdata 和 全局引用的是 一个 userData 所以 能够 更新全局数据 变更本地数据 
    //更新右侧按钮时 从全局获取数据---> 不用关心本地数据
    //保证一份数据 防止数据不一致
    function onSendHeart()
    {
        var user = scene.user;
        global.friendController.sendHeart(user["uid"]);
        global.httpController.addRequest("friendC/sendHeart", dict([["uid", global.user.uid], ["fid", user.get("uid")], ["mid", global.user.getNewMsgId()]]), null, null);

        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("freeHeart", null), [100, 100, 100], null));

        updateRightMenu();

        //global.tashModel.doDayTaskByKey("sendHeart", 1);
        global.taskModel.doAllTaskByKey("sendHeart", 1);
    }
    var challenged = 0;
    //挑战结束返回好友页面
    //已经有一个 挑战排行榜
    //挑战邻居有什么意义
    function onChallenge()
    {
        if(challenged == 0)
        {
            challenged += 1;
            var cry = getChallengeNeiborCry(scene.user["uid"]);
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sureToChallenge", ["[NUM]", str(cry)]), [100, 100, 100], null));
            return;
        }
        challenged = 0;
        var user = scene.user;
        var cs = new ChallengeScene(user.get("uid"), user.get("id"), 0, 0, CHALLENGE_NEIBOR, user);
        global.director.pushScene(cs);
        //global.director.pushView(new VisitDialog(cs), 1, 0);
        //cs.initData();
        updateRightMenu();
    }
    function returnHome()
    {
        global.director.popScene();
    }
    function visitNext()
    {
        scene.visitNext(); 
    }
    //好友宝箱点击开启之后 
    function onBox()
    {   
        global.director.pushView(new TreasureBox(BOX_FRIEND, scene), 1, 0);
    }
}
