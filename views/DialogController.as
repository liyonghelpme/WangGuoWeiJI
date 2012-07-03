class DialogController extends MyNode
{
    var cmds = [];
    function DialogController()
    {
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
                    global.director.pushView(new LoginDialog(), 1, 0);
                }   
                else if(curCmd.get("cmd") == "rate")
                {
                    global.director.pushView(new ScoreDialog(), 1, 0);
                }
                else if(curCmd.get("cmd") == "levup")
                    global.director.pushView(new LevupDialog(), 1, 0);
                /*
                else if(curCmd.get("cmd") == "victory")
                    global.director.pushView(new BreakDialog(1, 2, dict()), 1, 0);
                else if(curCmd.get("cmd") == "fail")
                    global.director.pushView(new BreakDialog(0, 0, dict()), 1, 0);
                */
            }
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
