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
                    var word = curCmd.get("word");
                    global.director.pushView(new NoTipDialog(word, curCmd.get("kind")), 1, 0);
                }
                else if(curCmd.get("cmd") == "chooseSol")
                {
                    global.director.curScene.addChild(new UpgradeBanner(getStr("selectSol", null), [100, 100, 100], null));
                }
                /*
                else if(curCmd.get("cmd") == "trainTip")
                {
                    global.director.pushView(new TrainTip(), 1, 0);
                }
                */
                else if(curCmd.get("cmd") == "loading")
                {
                    global.director.pushView(new VisitDialog(scene), 1, 0);
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
