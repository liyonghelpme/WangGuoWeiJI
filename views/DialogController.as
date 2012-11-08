class DialogController extends MyNode
{
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
    function update(diff)
    {
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
                    global.director.curScene.addChild(new UpgradeBanner(getStr("selectSol", null), [100, 100, 100], null));
                }
                else if(curCmd.get("cmd") == "loading")
                {
                    global.director.pushView(new VisitDialog(scene), 1, 0);
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
                    global.director.pushView(new Loading(), 1, 0);
                }
                else if(curCmd["cmd"] == "download")
                {
                    global.director.pushView(new DownloadDialog(), 1, 0);
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
