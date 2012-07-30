/*
生成方法：通用接口 代理接口
new FloatNode()
new Hero
设置代理 setDelegate

点击某个panel 需要的功能 由 delegate 提供 这三个 delegate 不同的只是数据部分

相同的pandel 拷贝模板来进行就可以了

*/

//根据挑战次数 得到挑战的排名
//configure getRank updateTab data
class RankDialog extends MyNode
{
    //显示高度 和 移动高度不同
    /*
    点击clip的对象 移动 flowNode 对象
    计算上下行范围
    更新显示的内容
    */

    var showLabel;
    //var curShow = -1;
    var labelPng = [ "groupRank.png", "newRank.png"];

    //var heroView;
    //var groupView;
    //var newView;

    var showView;

    //var views;
    var switchTab;
    var upArrow;
    function RankDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("dialogRankTitle.png").pos(69, 7);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        var challengeNum = global.user.getValue("challengeNum");
//        trace("challengeNum", challengeNum);
        if(challengeNum >= 10)
        {
            switchTab = 0;
            var but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37);
            but0.addlabel(getStr("groupRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);
        }
        else
        {
            switchTab = 1;
            but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37);
            but0.addlabel(getStr("newRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);
        }

        showLabel = bg.addsprite(labelPng[switchTab]).pos(395, 96).anchor(50, 50);


        var clPos = [66, 117];
        var clSize = [665, 338];

        upArrow = sprite("upArrow.png").pos(735, 371);
        bg.add(upArrow, 1);
        showView = new RankBase(clPos, clSize, this);

        addChild(showView);
    }

    function closeDialog()
    {
        global.director.popView();
    }

}
