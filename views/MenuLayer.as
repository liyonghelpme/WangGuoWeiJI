class MenuLayer extends MyNode
{
    //var taskbutton;
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
    /*
    不要设定图片的size属性否则图片会被缩放
bg.addsprite("haha.png").anchor(0, 0).pos(0, 0).size(800, 480);
bg.addsprite("menu_back.png").anchor(0, 0).pos(0, 391).size(800, 89);
bg.addsprite("主信息栏经验条.png").anchor(0, 0).pos(133, 419).size(24, 10);
bg.addsprite("menu_button.png").anchor(0, 0).pos(685, 380).size(112, 106);
bg.addlabel(getStr("1", null), "fonts/heiti.ttf", 23).anchor(0, 0).pos(333, 454).color(100, 100, 100);
bg.addlabel(getStr("2", null), "fonts/heiti.ttf", 23).anchor(0, 0).pos(588, 454).color(100, 100, 100);
bg.addsprite("recharge.png").anchor(0, 0).pos(439, 444).size(84, 35);
bg.addsprite("collection.png").anchor(0, 0).pos(229, 445).size(46, 34);
bg.addlabel(getStr("A-", null), "fonts/heiti.ttf", 25).anchor(0, 0).pos(242, 453).color(100, 100, 100);
bg.addsprite("menuFeather.png").anchor(0, 0).pos(107, 367).size(52, 59);
bg.addsprite("level0.png").anchor(0, 0).pos(120, 406).size(33, 36);
bg.addsprite("等级数字.png").anchor(50, 50).pos(136, 422).size(27, 13);
bg.addsprite("expBanner.png").anchor(0, 0).pos(123, 432).size(150, 50);
bg.addsprite("29xp to level 4.png").anchor(0, 0).pos(141, 456).size(116, 16);
bg.addlabel(getStr("29xp to level 4", null), "fonts/heiti.ttf", 17).anchor(50, 50).pos(198, 462).color(100, 100, 100);
bg.addsprite("task.png").anchor(0, 0).pos(12, 395).size(93, 82);
bg.addsprite("taskFin0.png").anchor(0, 0).pos(83, 402).size(27, 27);
bg.addlabel(getStr("99", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(96, 416).color(100, 100, 100);
    */
    var gloryLevText;
    //var sensor = null;
    var levelLabel;
    var expBanner;
    var expWord;
    function MenuLayer(s) {
        scene = s;
//        trace("pushMenuLayer");
        menus = new Array(null,null);
        bg = node();
        //banner = bg.addsprite("menu_back.png").scale(100,100).anchor(0,100).pos(0,480).rotate(0);
        init();
        banner = bg.addsprite("menu_back.png").anchor(0, 0).pos(0, 391).size(800, 89);

        bg.addsprite("task.png").anchor(0, 0).pos(12, 395).size(93, 82).setevent(EVENT_TOUCH, onTask);
        taskFin = bg.addsprite("taskFin0.png").anchor(0, 0).pos(83, 402).size(27, 27);
        finNum = bg.addlabel(getStr("99", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(96, 416).color(100, 100, 100);

        //taskbutton = banner.addsprite("task.png").scale(100,100).size(93,87).anchor(50,50).pos(61, 78).rotate(0).setevent(EVENT_TOUCH, onTask);
        //taskFin = taskbutton.addsprite("taskFin0.png").pos(75, 19).anchor(50, 50).visible(0);
        //finNum = taskFin.addlabel("", "fonts/heiti.ttf", 18, FONT_BOLD).pos(17, 17).anchor(50, 50).color(100, 100, 100);

        expfiller = bg.addsprite("exp_filler.png").anchor(0, 0).pos(133, 419);//.size(24, 10);
        //expfiller = banner.addsprite("exp_filler.png").scale(100,100).anchor(0,0).pos(143,57).rotate(0).size(108, 12);
        //expback = banner.addsprite("level0.png").scale(100,100).anchor(50, 50).pos(136, 56);
        expback = bg.addsprite("level0.png").anchor(0, 0).pos(120, 406).size(33, 36);
        //16+144 = 160+5 = 165
        //165 - 143 = 22
        
        var expSize = expback.prepare().size();
        levelLabel = expback.addnode().anchor(50, 50).pos(expSize[0]/2, expSize[1]/2);

        //expBanner = sprite("expBanner.png").pos(127, 71).visible(0);
        expBanner = sprite("expBanner.png").anchor(0, 0).pos(123, 432).size(150, 50).visible(0);
        bg.add(expBanner, MENU_EXP_LAYER);
/*
bg.addsprite("expBanner.png").anchor(0, 0).pos(0, 0).size(150, 50);
bg.addsprite("29xp to level 4.png").anchor(0, 0).pos(18, 24).size(116, 16);
bg.addlabel(getStr("29xp to level 4", null), "fonts/heiti.ttf", 17).anchor(50, 50).pos(75, 30).color(100, 100, 100);
*/
        expWord = ShadowWords(getStr("expToLev", null), "fonts/heiti.ttf", 17, FONT_NORMAL, [100, 100, 100]);
        expWord.bg.anchor(50, 50).pos(75, 28);
        expBanner.add(expWord.bg);

        //banner.add(levelLabel.bg);

        //collectionbutton = banner.addsprite("collection.png").scale(100,100).size(46,34).anchor(50,50).pos(253, 100).rotate(0).setevent(EVENT_TOUCH, openGlory);
        collectionbutton = bg.addsprite("collection.png").anchor(0, 0).pos(229, 445).size(46, 34).setevent(EVENT_TOUCH, openGlory);

        //rechargebutton = banner.addsprite("recharge.png").scale(100,100).size(84,33).anchor(50,50).pos(477,98).rotate(0).setevent(EVENT_TOUCH, openCharge);
        rechargebutton = bg.addsprite("recharge.png").anchor(0, 0).pos(439, 444).size(84, 35).setevent(EVENT_TOUCH, openCharge);

        //menubutton = banner.addsprite("menu_button.png").scale(100,100).anchor(0,100).pos(686,118);
        menubutton = bg.addsprite("menu_button.png").anchor(0, 0).pos(685, 380).size(112, 106).setevent(EVENT_TOUCH, onClicked, 0);
        //new Button(menubutton, onClicked, 0);

        initText();

    }
    function onTask()
    {
        global.director.pushView(new TaskDialog(), 1, 0);
    }
    function openGlory()
    {
        global.director.pushView(new GloryDialog(), 1, 0);
    }
    /*
    显示商店充值页面
    */
    function openCharge()
    {
        var st = new Store(scene);
        st.changeTab(st.GOLD_PAGE);
        global.director.pushView(st, 1, 0);
    }
    var silverText;
    var goldText;
    var gloryText;
    /*
    初始化文本数据之后注册 用户数据的监听器
bg.addlabel(getStr("1", null), "fonts/heiti.ttf", 23).anchor(0, 0).pos(333, 454).color(100, 100, 100);
bg.addlabel(getStr("2", null), "fonts/heiti.ttf", 23).anchor(0, 0).pos(588, 454).color(100, 100, 100);

bg.addlabel(getStr("1", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(333, 461).color(100, 100, 100);
bg.addlabel(getStr("2", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(588, 461).color(100, 100, 100);
    */
    function initText()
    {

        silverText = bg.addlabel(getStr("1", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(333, 461).color(100, 100, 100);
        goldText =  bg.addlabel(getStr("2", null), "fonts/heiti.ttf", 23).anchor(0, 50).pos(588, 461).color(100, 100, 100);
        //silverText = banner.addlabel(str(global.user.getValue("silver")), "fonts/heiti.ttf", 18).anchor(0, 50).pos(336, 99).color(100, 100, 100);
        //goldText = banner.addlabel(str(global.user.getValue("gold")), "fonts/heiti.ttf", 18).anchor(0, 50).pos(591, 99).color(100, 100, 100);
        //gloryText = banner.addlabel(getStr("glory", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(167, 99).color(100, 100, 100);
        //gloryLevText = collectionbutton.addlabel(str("B+"), "fonts/heiti.ttf", 20, FONT_BOLD).anchor(50, 50).pos(23, 17).color(100, 100, 100);
        gloryLevText = bg.addlabel("A-", "fonts/heiti.ttf", 25).anchor(50, 50).pos(253, 461).color(100, 100, 100);
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
        if(ins == 0)
        {
            scene.keepMenuLayer.addChild(this);
            bg.addaction(fadein(0));
        }
    }
    /*
    进入场景之后 需要更新显示的用户数据
    防止没有 事件导致无法更新
    */
    override function enterScene()
    {
        super.enterScene();
//        trace("menuLayer enterScene");
        //global.user.addListener(this);
        //global.user.addTaskListener(this);

        global.msgCenter.registerCallback(UPDATE_RESOURCE, this);
        global.msgCenter.registerCallback(UPDATE_TASK, this);
        global.msgCenter.registerCallback(UPDATE_EXP, this);


        updateValue(global.user.resource);
        updateExp(0);
        updateTaskState();
        //sensor = c_sensor(SENSOR_ACCELEROMETER, menuDisappear);
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
        temp.anchor(50, 50).pos(levelLabel.pos());
        levelLabel.removefromparent();
        expback.add(temp);
        levelLabel = temp;

        var lSize = levelLabel.size();
        var bSize = expback.prepare().size();
        
        //背景宽度 图片自身宽度 图片高度
        var sca = getNodeSca(levelLabel, [min(lSize[0], bSize[0]), lSize[1]]);
        //if(level >= 100)
        levelLabel.scale(sca);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_RESOURCE)
        {
            updateValue(global.user.resource);
        }
        else if(msgId == UPDATE_TASK )
            updateTaskState();
        else if(msgId == UPDATE_EXP)
            updateExp(param[1]);
    }
    function updateTaskState()
    {
        var num = global.user.getCurFinTaskNum();
        finNum.text(str(num));
        if(num == 0)
            taskFin.visible(0);
        else
            taskFin.visible(1);
    }
    override function exitScene()
    {
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
    }
    function updateValue(res)
    {
//        trace("update Value");
        silverText.text(str(res.get("silver", 0)));
        goldText.text(str(res.get("gold", 0)));


    }
    /*
    管理菜单的显示和隐藏
    打开对话框 关闭对话框 显示隐藏菜单 立即 beginBuild finishBuild 发送消息
    等待一定时间显示关闭对话框 showMenu hideMenu    时间计时
    震动显示隐藏对话框 beginBuild finishBuild   震动感应

    菜单当前的状态 显示 隐藏 状态转移过程中
    */
    var visLock = 0;
    function showMenu(t)
    {
        if(ins == 0)
        {
            finishBuild();
            bg.addaction(fadein(t));
        }
    }
    function hideMenu(t)
    {
        if(ins == 0)
            return;
        bg.addaction(sequence(fadeout(t), callfunc(beginBuild)));
    }
    
    
    /*
    需要确保两个子菜单的位置相同高度， 所以需要传递另一个菜单的高度
    */
    function draw_func(index, funcs){
        //unsupported param
        if(index>=2||index<0||len(funcs) <= 0 || len(funcs)>4){
            return;
        }
        if(menus[index] != null){
            removeChild(menus[index]);
        }
        menus[index] = new ChildMenuLayer(index,funcs, scene, MainMenuFunc.get(1-index));
        addChildZ(menus[index],-1);
    }
    
    function cancelAllMenu()
    {
        cancel_func(0);
        cancel_func(1);
    }
    function cancel_func(index){
        if(menus[index]!=null){
            removeChild(menus[index]);
            menus[index] = null;
        }
    }
    
    function onClicked(n, e, param, x, y, points){
        if(param==0){
            if(menus[0] == null){
                draw_func(0,["map","rank","plan","setting"]);
                draw_func(1,["role","store","friend","mail"]);
            }
            else{
                cancel_func(0);
                cancel_func(1);
            }
        }
    }
}
