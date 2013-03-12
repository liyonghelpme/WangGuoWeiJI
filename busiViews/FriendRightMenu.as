//好友页面右侧的菜单
class FriendRightMenu extends MyNode
{
    var menu;
    var funcs;
    const OFFY = 75;
    const WIDTH = 67;
    const PANEL_WIDTH = 67;
    const PANEL_HEIGHT = 60;
    const ROW_NUM = 3;
    const HEIGHT = (ROW_NUM-1)*OFFY+PANEL_HEIGHT;
    
    const buts = dict([
        ["box", ["friendBox.png", onBox, onBoxYet]],
        //["heart", ["friendHeart.png", onHeart, onHeartYet]],
        //["challenge", ["friendChallenge.png", onChallenge, onChallengeYet]],
    ]); 
    function onBoxYet()
    {
    }
    function onHeartYet()
    {
        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("dayOne", null), [100, 100, 100], null));
    }
    function onChallengeYet()
    {
        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("oneChallenge", null), [100, 100, 100], null));
    }
    //横向居中对其
    function onBox()
    {
        menu.onBox();
    }
    function onHeart()
    {
        menu.onSendHeart();
    }
    function onChallenge()
    {
        //menu.onChallenge();
    }
    /*
    直接setevent 加model[1] 不能奏效
    需要设置 Button 来中转 参数
    */
    //根据外部传入的数据设定每个按钮的属性 是否灰色 可以点击 数字修饰
    function initView()
    {
        bg = node();
        init();
        var height = OFFY*(len(funcs)-1)+PANEL_HEIGHT;
        var mid = height/2;
        //实际高度的中心 和 总高度的 中心对齐
        var curX = 0;
        var curY = HEIGHT/2-height/2;
        for(var i = 0; i < len(funcs); i++)
        {
            var model = buts[funcs[i][0]];
            if(model == null)
                continue;
            var temp;
            trace("model", model);
            if(funcs[i][1] == 0)
            {
temp = bg.addsprite(model[0], ARGB_8888).pos(curX, curY).anchor(50, 0).setevent(EVENT_TOUCH, model[1]);
            }
            else
temp = bg.addsprite(model[0], GRAY, ARGB_8888).pos(curX, curY).anchor(50, 0).setevent(EVENT_TOUCH, model[2]);

            var sca = getSca(temp, [PANEL_WIDTH, PANEL_HEIGHT]);
            temp.scale(sca);
            curY += OFFY;
        }
    }
    function FriendRightMenu(m, f)
    {
        menu = m;
        funcs = f;
        initView();
    }
}
