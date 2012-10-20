class Loading extends MyNode
{
    /*
    延迟几秒钟 拆除 这个 view
    */
    var processNum;
    var curProcess = 0;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("loadMain.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("wangguoLogo.png").anchor(0, 0).pos(19, 4).size(184, 116).color(100, 100, 100, 100);
        temp = bg.addsprite("loadingCircle.png").anchor(50, 50).pos(763, 37).size(50, 57).color(100, 100, 100, 100).addaction(repeat(rotateby(2000, 360)));
        temp = bg.addsprite("loadingWord.png").anchor(0, 0).pos(607, 23).size(129, 29).color(100, 100, 100, 100);
        temp = bg.addsprite().pos(0, 480).anchor(0, 100).addaction(repeat(animate(1500, "lighting0.png",  "lighting1.png", "lighting2.png", "lighting3.png", "lighting4.png", "lighting5.png", "lighting6.png", UPDATE_SIZE)));
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
    function update(diff)
    {
        if(initDataYet == 0)
        {
            initDataYet = 1;
            global.user.initData();
        }
        passTime += diff;
        if(passTime >= speed)
        {
            curProcess += 1;
            passTime -= speed;

            if(curProcess <= 100)
            {
                var oldPos = processNum.pos();
                processNum.removefromparent();
                processNum = altasWord("red", str(curProcess)+"%");
                processNum.anchor(50, 50).pos(oldPos);
                bg.add(processNum);
            }
            if(curProcess == 100 && hopeProcess == 100)
            {
                global.director.popView();
            }
        }

        /*
        curProcess += 1;
        if(curProcess < 100)
        {
            var oldPos = processNum.pos();
            processNum.removefromparent();
            processNum = altasWord("red", str(curProcess)+"%");
            processNum.anchor(50, 50).pos(oldPos);
            bg.add(processNum);
        }
        else
        {
        }
        */
    }
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
        super.enterScene();
        //global.timer.addTimer(this);
        global.myAction.addAct(this);
        global.msgCenter.registerCallback(INITDATA_OVER, this);
        global.msgCenter.registerCallback(LOAD_PROCESS, this);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(LOAD_PROCESS, this);
        global.msgCenter.removeCallback(INITDATA_OVER, this);
        //global.timer.removeTimer(this);
        global.myAction.removeAct(this);
        super.exitScene();
    }
}
