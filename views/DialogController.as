class DialogController extends MyNode
{
    //banner timestamp
    var bannerStack = [];
    var cmds = [];
    var scene;
    var lock = 0;
    function DialogController(sc)
    {
        scene = sc;
        bg = node();
        init();
    }
    //设定是否锁住对话框
    function setLock(l)
    {
        lock = l;
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    function addCmd(c)
    {
        cmds.append(c);
    }
    //[banner time]
    function addBanner(banner)
    {
        while(len(bannerStack) > getParam("maxBannerNum"))
        {
            var t = bannerStack.pop(0);
            t[0].removeNow();
        }
        var maxOff = len(bannerStack);
        var dis = global.director.disSize;
        var initX = dis[0]/2;
        var initY = dis[1]/2;
        trace("addBanner", len(bannerStack), maxOff, getParam("bannerMoveTime"), getParam("bannerOffY"), initX, initY);
        for(var i = 0; i < len(bannerStack); i++)
        {
            var ban = bannerStack[i][0];
            //ban.bg.stop();
            ban.setMoveAni(initX, initY-getParam("bannerOffY")*maxOff);
            /*
            var oldPos = ban.bg.pos();
            oldPos[1] -= getParam("bannerOffY");
            ban.bg.pos(oldPos);
            */
            maxOff--;
        }
        bannerStack.append([banner, time()]);
        global.director.curScene.addChildZ(banner, MAX_BUILD_ZORD);
        trace("finishAddBanner");
    }
    var passTime = 0;
    //统一向上移动
    function update(diff)
    {
        //加锁对话框控制器
        if(lock)
            return;
        var now = time();
        if(len(bannerStack) > 0)
        {
            var first = bannerStack[0];
            if((now - first[1]) > getParam("bannerFinishTime"))
                bannerStack.pop(0);
        }

        //可以等待timer update 之后再执行命令
        if(len(global.director.stack) == 0) 
        {
            if(len(cmds) > 0)
            {
                var curCmd = cmds.pop(0);
                if(curCmd.get("cmd") == "login")
                {
                    global.director.pushView(new LoginDialog(curCmd), 1, 0);
                }   
                else if(curCmd.get("cmd") == "rate")
                {
                    global.director.pushView(new ScoreDialog(), 1, 0);
                }
                else if(curCmd.get("cmd") == "levup")
                    global.director.pushView(new LevupDialog(curCmd), 1, 0);
                else if(curCmd.get("cmd") == "update")
                {
                    //var find = getUpdateObject();
                    //if(find != null)
                    //    global.director.pushView(new UpdateDialog(find[0], find[1]), 1, 0);
                }
                else if(curCmd.get("cmd") == "heart")
                {
                }
                else if(curCmd.get("cmd") == "noTip")
                {
                    //var word = curCmd.get("word");word,
                    global.director.pushView(new NoTipDialog( curCmd.get("kind")), 1, 0);
                }
                else if(curCmd.get("cmd") == "chooseSol")
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("selectSol", null), [100, 100, 100], null));
                }
                else if(curCmd.get("cmd") == "loading")
                {
                    global.director.pushView(new VisitDialog(scene, FRIEND_NO_VISIT_FRIEND), 1, 0);
                }
                else if(curCmd.get("cmd") == "waitTime")
                {
                    global.director.pushView(new Mask(curCmd["time"]), 0, 0);
                }
                else if(curCmd.get("cmd") == "roleName")
                {
                    //global.director.pushView(new RoleName(null, curCmd["sol"]), 1, 0);
                }
                //测试爱心对话框使用
                else if(curCmd.get("cmd") == "love")
                {
                }
                else if(curCmd.get("cmd") == "loveUpgrade")
                {
                }
                else if(curCmd["cmd"] == "challengeLoading")
                {
                    global.director.pushView(new LoadChallenge(curCmd["kind"], scene), 1, 0);
                }
                else if(curCmd["cmd"] == "initLoading")
                {
                    trace("pushInitLoading loading view 似乎存在问题 exitscene不正常 不明情况 只能手动push了");
                    global.director.pushView(new Loading(), 1, 0);
                }
                else if(curCmd["cmd"] == "download")
                {
                    global.director.pushView(new DownloadDialog(), 1, 0);
                }
                else if(curCmd["cmd"] == "newTaskDialog")
                {
                    //global.director.pushView(new NewTaskDialog2(), 1, 0);
                }
                else if(curCmd["cmd"] == "newTaskReward")
                    global.director.pushView(new NewTaskReward(), 1, 0);
                //闯关页面的随机按钮显示 箭头 BattleScene 中检测是否是 新手任务阶段 如果是则显示randomBut 上的Arrow 
                else if(curCmd["cmd"] == "randomChoose")
                {
                    //在新手任务阶段
                    if(global.taskModel.checkInNewTask())
                    {
                        var okBut = scene.banner.okBut;
                        global.taskModel.showHintArrow(okBut, okBut.prepare().size(), RANDOM_BUT, scene.banner.onOk);
                    }
                }
                else if(curCmd["cmd"] == "hasChallengeMsg")
                {
                    global.director.pushView(new ChallengeMsgDialog(curCmd["challengeMsg"]), 1, 0);
                }
                else if(curCmd["cmd"] == "startTask")
                    global.msgCenter.sendMsg(TASK_START_WORK_NOW, null);//启动任务模块等待时间
            }
        }
    }
    //清理新手任务状态
    function clearBanner()
    {
        /*
        trace("bannerStack", len(bannerStack));
        for(var i = 0; i < len(bannerStack); i++) {
            bannerStack[i][0].removeSelf();
        }
        bannerStack = [];
        */
    }
    override function exitScene()
    {
        trace("exit DialogBanner");
        clearBanner();
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
