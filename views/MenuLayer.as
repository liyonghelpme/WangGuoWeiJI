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
    [0,["map","rank","plan","setting"]],
    [1,["role","store","friend","mail"]],
    ]);
    /*
    不要设定图片的size属性否则图片会被缩放
    */
    var gloryLevText;
    //var sensor = null;
    
    function MenuLayer(s) {
        scene = s;
//        trace("pushMenuLayer");
        menus = new Array(null,null);
        bg = node();
        banner = bg.addsprite("menu_back.png").scale(100,100).anchor(0,100).pos(0,480).rotate(0);
        init();



        taskbutton = banner.addsprite("task.png").scale(100,100).size(93,87).anchor(50,50).pos(61, 78).rotate(0).setevent(EVENT_TOUCH, onTask);
        taskFin = taskbutton.addsprite("taskFin.png").pos(75, 19).anchor(50, 50).visible(0);
        finNum = taskFin.addlabel("", null, 15).pos(17, 17).anchor(50, 50).color(0, 0, 0);

        expfiller = banner.addsprite("exp_filler.png").scale(100,100).anchor(0,0).pos(143,57).rotate(0).size(108, 12);
        expback = banner.addsprite("exp_star.png").scale(100,100).size(37,35).anchor(50, 50).pos(144,60).rotate(0);
        collectionbutton = banner.addsprite("collection.png").scale(100,100).size(46,34).anchor(50,50).pos(253, 100).rotate(0).setevent(EVENT_TOUCH, openGlory);

        rechargebutton = banner.addsprite("recharge.png").scale(100,100).size(84,33).anchor(50,50).pos(477,98).rotate(0).setevent(EVENT_TOUCH, openCharge);
        menubutton = banner.addsprite("menu_button.png").scale(100,100).anchor(0,100).pos(686,118);
        new Button(menubutton, onClicked, 0);

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
    */
    function initText()
    {
        silverText = banner.addlabel(str(global.user.getValue("silver")), null, 18).anchor(0, 50).pos(336, 99).color(100, 100, 100);
        goldText = banner.addlabel(str(global.user.getValue("gold")), null, 18).anchor(0, 50).pos(591, 99).color(100, 100, 100)
        gloryText = banner.addlabel(getStr("glory", null), null, 18).anchor(50, 50).pos(167, 99).color(100, 100, 100);
        gloryLevText = collectionbutton.addlabel(str("B+"), null, 20, FONT_BOLD).anchor(50, 50).pos(23, 17).color(100, 100, 100);

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
    */
    function finishBuild()
    {
        if(ins == 0)
        {
            scene.keepMenuLayer.addChild(this);
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
        global.user.addListener(this);
        global.user.addTaskListener(this);
        updateValue(global.user.resource);
        updateTaskState();
        //sensor = c_sensor(SENSOR_ACCELEROMETER, menuDisappear);
    }
    /*
    function menuDisappear(stype, ax, ay, az)
    {
        var acc = sqrt(ax*ax+ay*ay+az*az);
//        trace("accelemeter", acc);

    }
    */
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
        global.user.removeListener(this);
        global.user.removeTaskListener(this);
        super.exitScene();
    }
    /*
    用户更新数据的显示接口
    expfiller 108 11
    */
    function initDataOver()
    {
        silverText.text(str(global.user.resource.get("silver", 0)));
        goldText.text(str(global.user.resource.get("gold", 0)));
        
        var level = global.user.getValue("level");
        var exp = global.user.getValue("exp");
        //var needExp = global.user.getNeedExp(level);
        var needExp = getLevelUpNeedExp(level);
        expfiller.size(exp*108/needExp, 12);
    }
    function updateValue(res)
    {
//        trace("update Value");
        silverText.text(str(res.get("silver", 0)));
        goldText.text(str(res.get("gold", 0)));

        var level = global.user.getValue("level");
        var exp = global.user.getValue("exp");
        //var needExp = global.user.getNeedExp(level);
        var needExp = getLevelUpNeedExp(level);
//        trace("needExp", needExp, exp);
        expfiller.size(exp*108/needExp, 12);
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
    
    function onClicked(param){
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
