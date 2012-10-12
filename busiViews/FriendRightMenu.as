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
        ["box", ["friendBox.png", onBox]],
        ["heart", ["friendHeart.png", onHeart]],
        ["challenge", ["friendChallenge.png", onChallenge]],
    ]); 
    //横向居中对其
    function onBox()
    {
    }
    function onHeart()
    {
        menu.onSendHeart();
    }
    function onChallenge()
    {
        menu.onChallenge();
    }
    //根据外部传入的数据设定每个按钮的属性 是否灰色 可以点击 数字修饰
    function initView()
    {
        var height = OFFY*(len(funcs)-1)+PANEL_HEIGHT;
        var mid = height/2;
        //实际高度的中心 和 总高度的 中心对齐
        var curX = 0;
        var curY = HEIGHT/2-height/2;
        for(var i = 0; i < len(funcs); i++)
        {
            var model = buts[funcs[i][0]];
            var temp;
            if(funcs[i][1] == 0)
                temp = bg.addsprite(model[0]).pos(curX, curY).anchor(50, 0).setevent(EVENT_TOUCH, model[1]);
            else
                temp = bg.addsprite(model[0], GRAY).pos(curX, curY).anchor(50, 0);

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
