class MenuLayer extends MyNode
{
    var taskbutton;
    var taskFin;
    var finNum;
    var expfiller;
    var expback;
    var collectionbutton;
    var Un5;
    var Un6;
    var rechargebutton;
    var menubutton;
    
    var menus;
    var scene;

    var banner;
    var MainMenuFunc = dict([
    [0, ["map","rank","plan","setting"]],
    [1, ["role", "store","friend","mail"]],
    ]);
    var gloryLevText;
    //var sensor = null;
    var levelLabel;
    var expBanner;
    var expWord;
    //var scoreIcon;
    var rightMenu;
    function rateIt()
    {
        global.director.pushView(new ScoreDialog(), 1, 0);
    }
    var downloadIcon = null;
    function MenuLayer(s) {
        var temp
        scene = s;
//        trace("pushMenuLayer");
        menus = new Array(null,null);
        bg = node();
        init();
        
        banner = bg.addsprite("menu_back.png").anchor(0, 0).pos(0, 391).size(800, 89);

        temp = bg.addsprite("menuFeather.png").anchor(0, 0).pos(107, 367).size(52, 59).color(100, 100, 100, 100);
        taskbutton = bg.addsprite("task.png").anchor(0, 0).pos(12, 395).size(93, 82).setevent(EVENT_TOUCH, onTask);
        taskFin = bg.addsprite("taskFin0.png").anchor(0, 0).pos(83, 402).size(27, 27);
        finNum = bg.addlabel(getStr("99+", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(96, 416).color(100, 100, 100);

        expfiller = bg.addsprite("exp_filler.png").anchor(0, 0).pos(133, 419);//.size(24, 10);
        expback = bg.addsprite("level0.png").anchor(0, 0).pos(120, 406).size(33, 36);
        
        var expSize = expback.prepare().size();
        levelLabel = expback.addnode().anchor(50, 50).pos(expSize[0]/2, expSize[1]/2);

        expBanner = sprite("expBanner.png").anchor(0, 0).pos(123, 432).size(150, 50).visible(0);
        bg.add(expBanner, MENU_EXP_LAYER);

        expWord = ShadowWords(getStr("expToLev", null), "fonts/heiti.ttf", 17, FONT_NORMAL, [100, 100, 100]);
        expWord.bg.anchor(50, 50).pos(75, 28);
        expBanner.add(expWord.bg);

        collectionbutton = bg.addsprite("challengeIcon.png").anchor(0, 0).pos(229, 445).size(46, 34).setevent(EVENT_TOUCH, onRank);
        //global.taskModel.showHintArrow(collectionbutton, collectionbutton.prepare().size(), CHALLENGE_BUT, onRank);

        rechargebutton = bg.addsprite("recharge.png").anchor(0, 0).pos(439, 444).size(84, 35).setevent(EVENT_TOUCH, openCharge);

        menubutton = bg.addsprite("menu_button.png").anchor(0, 0).pos(685, 380).size(112, 106).setevent(EVENT_TOUCH, onClicked, 0);

        rightMenu = new CastleRightMenu(this, []);

        initText();


    }
    function removeDownloadIcon()
    {
        trace("removeDownloadIcon");
        if(downloadIcon != null)
        {
            downloadIcon.removeSelf();
            downloadIcon = null;
        }
    }
    function onTask()
    {
        global.controller.playSound("but.mp3");
        global.director.pushView(new TaskDialog(), 1, 0);
    }
    var sureToChallenge = 0;
    function finishCallback()
    {
        sureToChallenge = 0;
    }
    function onRank()
    {
        sureToChallenge = gotoRandChallenge(sureToChallenge, finishCallback);
        if(sureToChallenge == 0)
        {
            var cs = new ChallengeScene(null, null, null, null, CHALLENGE_OTHER, null);
            global.director.pushScene(cs);
        }
    }
    /*
    显示商店充值页面
    */
    function openCharge()
    {
        var st = new Store(scene);
        st.changeTab(TREASURE_PAGE);
        global.director.pushView(st, 1, 0);
    }
    var silverText;
    var goldText;
    var gloryText;
    function initText()
    {
        silverText = bg.addlabel(getStr("1", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(333, 461).color(100, 100, 100);
        goldText =  bg.addlabel(getStr("2", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(588, 461).color(100, 100, 100);
        var w = str(global.user.rankOrder);
        if(global.user.rankOrder > 999)
            w = "999+";
        gloryLevText = bg.addlabel(w, "fonts/heiti.ttf", 23).anchor(50, 50).pos(169, 461).color(100, 100, 100);
    }
    //var building = 0;
    /*
    通用的隐藏菜单的接口
    */
    function beginBuild()
    {
        if(ins == 1)
            removeSelf();
    }
    /*
    通用的显示菜单的接口
    菜单栏可能通过fadeout 方式消失因此需要fadein方式重新显示出来
    */
    function finishBuild()
    {
        trace("finish MenuLayer");
        removeSelf();
        scene.keepMenuLayer.addChild(this);
        bg.addaction(fadein(0));
    }
    /*
    进入场景之后 需要更新显示的用户数据
    防止没有 事件导致无法更新
    */
    override function enterScene()
    {
        super.enterScene();

        global.msgCenter.registerCallback(UPDATE_RESOURCE, this);
        global.msgCenter.registerCallback(UPDATE_TASK, this);
        global.msgCenter.registerCallback(UPDATE_EXP, this);
        global.msgCenter.registerCallback(RATE_GAME, this);
        global.msgCenter.registerCallback(MENU_ICON, this);
        global.msgCenter.registerCallback(INIT_NEW_TASK_FIN, this);
        global.msgCenter.registerCallback(CHECK_TASK_ICON, this);
        global.msgCenter.registerCallback(CHALLENGE_BUT, this);
        global.msgCenter.registerCallback(OPEN_TASK_DIALOG, this);

        updateValue(global.user.resource);
        updateExp(0);
        updateTaskState();
        updateRightMenu();

        global.taskModel.showHintArrow(menubutton, menubutton.prepare().size(), MENU_ICON, onClicked);
        //global.taskModel.showHintArrow(taskbutton, taskbutton.prepare().size(), TASK_ICON);
    }

    function updateExp(add)
    {
        var level = global.user.getValue("level");
        var exp = global.user.getValue("exp");
        var needExp = getLevelUpNeedExp(level);

        
        //var lastExpSize = expfiller.prepare().size()[0];
        var nowSize = exp*EXP_LEN/needExp+BASE_LEN;


        if(add > 0)
        {
            expfiller.stop();
            expfiller.addaction(sizeto(500, nowSize, 12));
        }
        else
            expfiller.size(nowSize, 12);

        //if(nowSize > lastExpSize)
        //{

        //}
        //else 
        //    expfiller.size(nowSize, 12);
        //}

        var leftExp = needExp-exp;
        if(add > 0)
        {
            expWord.setWords(getStr("expToLev", ["[EXP]", str(leftExp), "[LEV]", str(level+2)]));
            expBanner.stop();
            expBanner.visible(1);
            expBanner.addaction(sequence(itintto(100, 100, 100, 100), delaytime(2000), fadeout(1000)));
        }

        var temp = altasWord("white", str(level+1));
        //temp.scale(25*100/temp.size()[1]);
        temp.anchor(50, 50).pos(levelLabel.pos());
        levelLabel.removefromparent();
        expback.add(temp);
        levelLabel = temp;

        var lSize = levelLabel.size();
        var bSize = expback.prepare().size();
        
        //背景宽度 图片自身宽度 图片高度
        var sca = getNodeSca(levelLabel, [min(lSize[0], bSize[0]), min(lSize[1], 21)]);
        //if(level >= 100)
        levelLabel.scale(sca);
    }
    /*
    点击右侧按钮 更新

    */
    function updateRightMenu()
    {
        if(rightMenu != null)
        {
            rightMenu.removeSelf();
            rightMenu = null;
        }

        trace("remove DownloadIcon", downloadIcon);
        if(downloadIcon != null)
        {

            downloadIcon.removeSelf();
            downloadIcon = null;
        }

        //显示子菜单 隐藏 打分图标
        if(showChildMenu == 1)
            return;

        //完成新手任务 没有显示下载图标 且没有下载完成
        if(global.user.getValue("newTaskStage") >= getParam("showFinish") && downloadIcon == null && global.pictureManager.checkNeedDownload())
        {
            trace("update Right Menu add DownloadIcon");
            downloadIcon = new DownloadIcon(this);
            addChild(downloadIcon);
        }

        var rated = global.user.db.get("rated");
        var funcs = [];


        //是否显示 3个图标
        var ret = global.taskModel.checkShowThreeIcon()
        if(ret)
        {
            if(global.user.getValue("level") < getParam("inviteShowLevel"))
            {
                funcs.append("invite");
            }

            if(rated != 1)
            {
                funcs.append("rate");
            }

            //没有反馈过 则 显示反馈图标
            if(global.user.db.get("feedback") != 1)
            {
                funcs.append("feedback");
            }
        }
        //新手任务完成
        else if(global.taskModel.checkNewTaskFinish())
        {
            if(rated != 1)
            {
                funcs.append("rate");
            }
            if(global.taskModel.initYet)
            {
            }
        }
        //新手任务礼包没有结束 显示

        if(len(funcs) > 0)
        {
            rightMenu = new CastleRightMenu(this, funcs);
            rightMenu.setPos([753, 129]);
            addChild(rightMenu);
            //初次显现
            rightMenu.bg.addaction(sequence(itintto(0, 0, 0, 0), delaytime(100), fadein(300)));
        }
        if(downloadIcon != null)
            downloadIcon.bg.addaction(sequence(itintto(0, 0, 0, 0), delaytime(100), fadein(300)));
    }
    /*
    两种可能 第一次进入 新手剧情 新手任务
    在经营页面同步完新手数据
    */
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_RESOURCE)
        {
            updateValue(global.user.resource);
        }
        else if(msgId == UPDATE_TASK )//更新任务时更新右侧菜单
        {
            updateTaskState();
            updateRightMenu();
        }
        else if(msgId == UPDATE_EXP)
            updateExp(param[1]);
        else if(msgId == RATE_GAME)
            updateRightMenu();
        else if(msgId == MENU_ICON)
            global.taskModel.showHintArrow(menubutton, menubutton.prepare().size(), MENU_ICON, onClicked);
        else if(msgId == INIT_NEW_TASK_FIN)
            updateRightMenu(); 
        else if(msgId == CHALLENGE_BUT)
            global.taskModel.showHintArrow(collectionbutton, collectionbutton.prepare().size(), CHALLENGE_BUT, onRank);
        else if(msgId == OPEN_TASK_DIALOG)
            global.taskModel.showHintArrow(taskbutton, taskbutton.prepare().size(), OPEN_TASK_DIALOG, onTask);
    }
    function updateTaskState()
    {
        //var num = global.user.getCurFinTaskNum();
        var num = global.taskModel.getFinishNum();
        var w = str(num);
        if(num >= 99)
            w = "99+";
        finNum.text(w);
        if(num == 0)
        {
            taskFin.visible(0);
            finNum.visible(0);
        }
        else
        {
            taskFin.visible(1);
            finNum.visible(1);
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(OPEN_TASK_DIALOG, this);
        global.msgCenter.removeCallback(CHALLENGE_BUT, this);
        global.msgCenter.removeCallback(CHECK_TASK_ICON, this);
        global.msgCenter.removeCallback(INIT_NEW_TASK_FIN, this);
        global.msgCenter.removeCallback(MENU_ICON, this);
        global.msgCenter.removeCallback(RATE_GAME, this);
        global.msgCenter.removeCallback(UPDATE_EXP, this);
        global.msgCenter.removeCallback(UPDATE_RESOURCE, this);
        global.msgCenter.removeCallback(UPDATE_TASK, this);
        //global.user.removeListener(this);

        //global.user.removeTaskListener(this);
        super.exitScene();
    }
    /*
    用户更新数据的显示接口
    expfiller 108 11
    */
    const EXP_LEN = 108-22;
    const BASE_LEN = 22;
    function initDataOver()
    {
        updateValue(global.user.resource);
        updateExp(0);
        trace("show Download Icon", global.user.getValue("newTaskStage"));
        /*
        if(global.user.getValue("newTaskStage") >= getParam("showFinish"))
        {
            trace("initDataOver add Download");
            downloadIcon = new DownloadIcon(this);
            addChild(downloadIcon);
        }
        */
    }
    function updateValue(res)
    {
        silverText.text(str(res.get("silver", 0)));
        goldText.text(str(res.get("gold", 0)));
    }
    /*
    管理菜单的显示和隐藏
    打开对话框 关闭对话框 显示隐藏菜单 立即 beginBuild finishBuild 发送消息
    等待一定时间显示关闭对话框 showMenu hideMenu    时间计时
    震动显示隐藏对话框 beginBuild finishBuild   震动感应

    菜单当前的状态 显示 隐藏 状态转移过程中
    
    奇怪了 隐藏之后 一直不能出现这是为什么
    重入场景之后 会重新 
    */
    var visLock = 0;
    function showMenu()
    {
        if(infadeOut == 1)
        {
            finishBuild();
            infadeOut = 0;
            bg.stop();
            bg.addaction(sequence(delaytime(100), fadein(500)));
        }
    }
    /*
    隐藏子菜单
    接着关闭自身
    因为自菜单的 exitScene 需要调用 addaction但是 callfunc中不能调用 addaction
    调用 beginBuild函数失败了 只是fadeout了
    如何查看fadeout的状态？
    */
    var infadeOut = 0;
    function hideMenu(t)
    {
        if(infadeOut == 1)
            return;
        cancelAllMenu();
        infadeOut = 1;
        bg.stop();
        bg.addaction(sequence(fadeout(t), callfunc(beginBuild)));
    }
    
    
    /*
    需要确保两个子菜单的位置相同高度， 所以需要传递另一个菜单的高度
    统一显示showGlobalMenu 如何？
    drawAllMenu
    cancelAllMenu
    但是不能popView 来关闭 需要 cancelAllMenu
    */
    function draw_func(index, funcs){
        updateRightMenu();
        if(menus[index] != null){
            removeChild(menus[index]);
        }
        menus[index] = new ChildMenuLayer(index,funcs, scene, MainMenuFunc.get(1-index));
        addChildZ(menus[index],-1);
    }
    
    function drawAllMenu()
    {
        showChildMenu = 1;
        draw_func(0,["map","rank","plan","setting"]);
        draw_func(1,["soldier","store","friend","mail"]);
    }
    var showChildMenu = 0;
    function cancelAllMenu()
    {
        //如果显示子菜单则隐藏
        if(showChildMenu)
        {
            showChildMenu = 0;
            updateRightMenu();
            cancel_func(0);
            cancel_func(1);
        }
    }
    function cancel_func(index){
        if(menus[index]!=null){
            //removeChild(menus[index]);
            menus[index].removeSelf();
            //menus[index].clearChildMenu();
            menus[index] = null;
        }
    }
    
    function onClicked(n, e, param, x, y, points){
        global.controller.playSound("but.mp3");
        if(showChildMenu == 0){
            drawAllMenu();
        }
        else{
            cancelAllMenu();
        }
    }
}
