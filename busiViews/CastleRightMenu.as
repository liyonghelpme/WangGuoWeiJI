class CastleRightMenu extends MyNode
{
    const OFFY = 75;
    const WIDTH = 75;
    const PANEL_WIDTH = 75;
    const PANEL_HEIGHT = 68;
    const ROW_NUM = 3;
    const HEIGHT = (ROW_NUM-1)*OFFY+PANEL_HEIGHT;

    var menu;
    var funcs;
    //打分按钮 和 每日任务按钮 最多显示3个按钮
    var buts = dict([
        ["rate", ["scoreIcon.png", onRate]],
        ["dayTask", ["dayTaskIcon.png", onDayTask]],
        ["invite", ["inviteIcon.png", onInvite]],
        ["feedback", ["settingIcon.png", onFeedback]],
    ]);
    function onInvite()
    {
        global.director.pushView(new InviteIntro(), 1, 0);
    }
    function onFeedback()
    {
        global.user.db.put("feedback", 1);
        global.director.pushView(new SettingDialog(), 1, 0);
        menu.updateRightMenu();
    }
    function onRate()
    {
        global.director.pushView(new ScoreDialog(), 1, 0);
    }
    function onDayTask()
    {
        global.director.pushView(new DailyTask(), 1, 0); 
    }
    function initView()
    {
        bg = node();
        init();
        var height = OFFY*(len(funcs)-1)+PANEL_HEIGHT;
        var mid = height/2;
        
        var curX = 0;
        var curY = HEIGHT/2-height/2;
        
        for(var i = 0; i < len(funcs); i++)
        {
            var model = buts[funcs[i]];
            var temp;
            trace("model", model);
            temp = bg.addsprite(model[0]).pos(curX, curY).anchor(50, 0).setevent(EVENT_TOUCH, model[1]);
            var sca = getSca(temp, [PANEL_WIDTH, PANEL_HEIGHT]);
            temp.scale(sca);
            curY += OFFY;
        }
    }

    override function enterScene()
    {
        super.enterScene();

    }
    override function exitScene()
    {

        super.exitScene();
    }
    function CastleRightMenu(m, f)
    {
        menu = m;
        funcs = f;
        initView();
    }
}
