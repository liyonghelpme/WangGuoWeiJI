/*
FlowView
ROW_NUM
ITEM_NUM
PANEL_WIDTH
PANEL_HEIGHT

cl flowNode
getRange
updateTab

*/
class MailDialog extends MyNode
{
    var selected = -1;
    var moreView = null;
    var requestView = null;

    var views;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("messageBack.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);

        but0 = new NewButton("roleNameBut0.png", [119, 44], getStr("moreGame", null), null, 21, FONT_NORMAL, [100, 100, 100], switchView, 1);
        but0.bg.pos(532, 37);
        addChild(but0);
        but0 = new NewButton("blueButton.png", [119, 44], getStr("friendReq", null), null, 21, FONT_NORMAL, [100, 100, 100], switchView, 0);
        but0.bg.pos(662, 37);
        addChild(but0);
        temp = bg.addsprite("messageTitle.png").anchor(0, 0).pos(31, 20).size(140, 33).color(100, 100, 100, 100);
    }
    function MailDialog()
    {
        initView();
        
        moreView = new MoreView([7, 85], [786, 385]);
        requestView = new RequestView([7, 154], [786, 310]);

        views = [requestView, moreView];

        switchView(0);
        global.taskModel.doAllTaskByKey("checkMessage", 1);
    }
    function switchView(p)
    {
        if(selected != p)
        {
            if(selected != -1)
                views[selected].removeSelf();
            selected = p;
            addChild(views[selected]);
            views[selected].updateTab();
        }
    }

    function closeDialog()
    {
        global.director.popView();
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    var lock = null;
    function update(diff)
    {
        if(selected != -1)
        {
            if(views[selected].initYet == 0)
            {
                if(lock == null)
                {
                    lock = node();
                    lock.addsprite().pos(310, 228).addaction(
                    repeat(
                        animate(1000, "heartLoad0.png", "heartLoad1.png", "heartLoad2.png", "heartLoad3.png", "heartLoad4.png", "heartLoad5.png", "heartLoad6.png", "heartLoad7.png", "heartLoad8.png", "heartLoad9.png")
                    )); 
                    lock.addsprite("heartLoading.png").pos(396, 253);
                    bg.add(lock, 10);
                }
            }
            else if(lock != null)
            {
                lock.removefromparent();
                lock = null;
            }
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
