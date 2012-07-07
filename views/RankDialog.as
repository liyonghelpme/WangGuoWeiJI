/*
生成方法：通用接口 代理接口
new FloatNode()
new Hero
设置代理 setDelegate

点击某个panel 需要的功能 由 delegate 提供 这三个 delegate 不同的只是数据部分

相同的pandel 拷贝模板来进行就可以了

*/

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
    var curShow = -1;
    var labelPng = ["heroRank.png", "groupRank.png", "newRank.png"];

    var heroView;
    var groupView;
    var newView;

    var views;
    function RankDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("dialogRankTitle.png").pos(66, 7);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        var but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37).setevent(EVENT_TOUCH, switchView, 0);
        but0.addlabel(getStr("heroRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);

        but0 = bg.addsprite("roleNameBut0.png").pos(505, 24).size(96, 37).setevent(EVENT_TOUCH, switchView, 1);
        but0.addlabel(getStr("groupRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);

        but0 = bg.addsprite("roleNameBut0.png").pos(620, 24).size(96, 37).setevent(EVENT_TOUCH, switchView, 2);
        but0.addlabel(getStr("newRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);

        showLabel = bg.addsprite("groupRank.png").pos(395, 93).anchor(50, 50);


        var clPos = [66, 109];
        var clSize = [665, 346];
        heroView = new HeroRank(clPos, clSize);
        groupView = new GroupRank(clPos, clSize);
        newView = new NewRank(clPos, clSize);
        views = [heroView, groupView, newView];

        curShow = -1;
        switchView(null, null, 0, null, null, null);
    }
    function switchView(n, e, p, x, y, points)
    {
        if(curShow == p)
            return;
        showLabel.texture(labelPng[p]);
        if(curShow != -1)
            views[curShow].removeSelf();
        curShow = p;
        addChild(views[curShow]);
    }

    function closeDialog()
    {
        global.director.popView();
    }

}
