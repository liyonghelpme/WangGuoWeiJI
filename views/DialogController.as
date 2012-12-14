class DialogController extends MyNode
{
    //banner timestamp
    var bannerStack = [];
    var cmds = [];
    var scene;
    function DialogController(sc)
    {
        scene = sc;
        bg = node();
        init();
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
    function addBanner(banner)
    {
        for(var i = 0; i < len(bannerStack); i++)
        {
            var ban = bannerStack[i][0];
            var oldPos = ban.bg.pos();
            oldPos[1] -= getParam("bannerOffY");
            ban.bg.pos(oldPos);
        }
        bannerStack.append([banner, time()]);
        global.director.curScene.addChild(banner);
    }
    //统一向上移动
    function update(diff)
    {
        var now = time();
        if(len(bannerStack) > 0)
        {
            var first = bannerStack[0];
            if((now - first[1]) > getParam("bannerFinishTime"))
                bannerStack.pop(0);
        }

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
                    var find = getUpdateObject();
                    if(find != null)
                        global.director.pushView(new UpdateDialog(find[0], find[1]), 1, 0);
                }
                else if(curCmd.get("cmd") == "heart")
                {
                    global.director.pushView(new LiveHeartDialog(), 1, 0);
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
                    global.director.pushView(new RoleName(null, curCmd["sol"]), 1, 0);
                }
                //测试爱心对话框使用
                else if(curCmd.get("cmd") == "love")
                {
                    //var tree = global.user.buildings; 
                    //global.director.pushView(new LoveDialog(), 1, 0);
                }
                else if(curCmd.get("cmd") == "loveUpgrade")
                {
                    global.director.pushView(new LoveUpgradeDialog(curCmd["level"]), 1, 0);
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
                    global.director.pushView(new NewTaskDialog2(), 1, 0);
                }
                else if(curCmd["cmd"] == "newTaskReward")
                    global.director.pushView(new NewTaskReward(), 1, 0);
                //闯关页面的随机按钮显示 箭头
                else if(curCmd["cmd"] == "randomChoose")
                {
                    var randBut = scene.banner.randomBut;
                    global.taskModel.showHintArrow(randBut, randBut.prepare().size(), RANDOM_BUT);
                }
            }
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
