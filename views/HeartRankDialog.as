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
class HeartRankDialog extends MyNode
{
    //显示高度 和 移动高度不同
    /*
    点击clip的对象 移动 flowNode 对象
    计算上下行范围
    更新显示的内容
    */

    //var showLabel;
    //var curShow = -1;
    //var labelPng = [ "groupRank.png", "newRank.png"];

    //var heroView;
    //var groupView;
    //var newView;

    var showView;

    //var views;
    //var switchTab;
    var upArrow;
    function HeartRankDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("heartRank.png").pos(172,47).anchor(50, 50);
        bg.addsprite("closeBut.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        var clPos = [66, 117];
        var clSize = [665, 338];

        upArrow = sprite("upArrow.png").pos(720, 371).anchor(0, 50);
        bg.add(upArrow, 1);
        showView = new HeartRankBase(clPos, clSize, this);

        addChild(showView);
    }

    function closeDialog()
    {
        global.director.popView();
    }

}
