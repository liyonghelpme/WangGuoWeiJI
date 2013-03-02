class Loading extends MyNode
{
    /*
    延迟几秒钟 拆除 这个 view
    */
    var processNum;
    var curProcess = 0;
    function initView()
    {
        bg = node().size(800, 480);
        bg.setevent(EVENT_TOUCH, doNothing);
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("loadMain.jpg", ARGB_8888).anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("wangguoLogo.png", ARGB_8888).anchor(0, 0).pos(19, 4).color(100, 100, 100, 100);
        temp = bg.addsprite("loadingCircle.png", ARGB_8888).anchor(50, 50).pos(763, 37).size(50, 57).color(100, 100, 100, 100).addaction(repeat(rotateby(2000, 360)));
        temp = bg.addsprite("loadingWord.png", ARGB_8888).anchor(0, 0).pos(607, 23).size(129, 29).color(100, 100, 100, 100);
        temp = bg.addsprite().pos(0, 480).anchor(0, 100).addaction(repeat(animate(1500, "lighting0.png",  "lighting1.png", "lighting2.png", "lighting3.png", "lighting4.png", "lighting5.png", "lighting6.png", UPDATE_SIZE, ARGB_8888)));
        processNum = altasWord("red", "0%")
        processNum.anchor(50, 50).pos(400, 394);
        bg.add(processNum);
    }
    function Loading()
    {
        initView();
    }
    var passTime = 0;
    //curProcess hopeProcess 之间的距离决定是否迁移 
    //速度----> hopeProcess - curProcess / 100ms - 10%  5s初始化结束 
    //设定hopeProcess 的时候设定速度1% = 5000ms / 100 = 50
    // <= 20%   100
    //    50

    /*
    process:
        user INITDATA 10%
        user OVER 30%
        user handleDataOver 50%
            send NEWUSER  80%
            send INIT_DATA_OVER 
        ... mail friend task
        castleScene 70%
            castlePage 85%
            menuLayer 100%
    */
    var speed = 50;
    var initDataYet = 0;
    //初始化数据 由主控制 不由 view 控制
    function update(diff)
    {
        trace("loading", curProcess, hopeProcess);
        /*
        if(initDataYet == 0)
        {
            initDataYet = 1;
            global.user.initData();
        }
        */
        passTime += diff;
        if(passTime >= speed)
        {
            var coff = passTime / speed;
            //显示进度要小于实际的进度才可以
            if(curProcess <= hopeProcess)
                curProcess += min(20, coff); //因为passTime 太长了需要修正最大的增加速度
            curProcess = min(100, curProcess);
            passTime -= speed*coff;

            if(curProcess <= 100)
            {
                var oldPos = processNum.pos();
                processNum.removefromparent();
                processNum = altasWord("red", str(curProcess)+"%");
                processNum.anchor(50, 50).pos(oldPos);
                bg.add(processNum);
            }
            if(curProcess >= 100 && hopeProcess >= 100)
            {
                //global.director.popView();
                trace("移除当前loadingview popView pushView 不易管理 最好使用 addChild removeSelf 来定向管理");
                removeSelf();
            }
        }

    }
    //设定加载速度是50
    var hopeProcess = 10;
    function receiveMsg(param)
    {
        var msg = param[0];
        var p = param[1]; 
        if(msg == INITDATA_OVER)
        {
            //global.director.popView();
        }
        else if(msg == LOAD_PROCESS)
        {
            trace("LOAD_PROCESS", hopeProcess);
            hopeProcess = p;
            if(hopeProcess > (curProcess+20))
            {
                speed = 25;
            }
            else
                speed = 50;
        }
    }
    override function enterScene()
    {
        trace("loading view enterScene");
        super.enterScene();
        //global.timer.addTimer(this);
        global.myAction.addAct(this);
        //global.msgCenter.registerCallback(INITDATA_OVER, this);
        global.msgCenter.registerCallback(LOAD_PROCESS, this);
    }
    override function exitScene()
    {
        trace("exit Loading", LOAD_PROCESS);
        global.msgCenter.removeCallback(LOAD_PROCESS, this);
        //global.msgCenter.removeCallback(INITDATA_OVER, this);
        //global.timer.removeTimer(this);
        global.myAction.removeAct(this);
        super.exitScene();
    }
}
