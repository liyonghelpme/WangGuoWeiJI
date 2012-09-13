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

    var kind;

    var fightLabel = ["", ""];//进攻榜 防守榜

    var views = [];
    function RankDialog(k)
    {
        kind = k;

        bg = sprite("dialogFriend.png");
        init();
        if(kind == CHALLENGE_RANK)
            bg.addsprite("dialogRankTitle.png").pos(69, 7);
        else if(kind == HEART_RANK)
            bg.addsprite("heartRank.png").pos(172,47).anchor(50, 50);
        else if(kind == FIGHT_RANK)
            bg.addsprite("dialogRankTitle.png").pos(69, 7);
            
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);


        var but0;
        if(kind == CHALLENGE_RANK)
        {
            var challengeNum = global.user.getValue("challengeNum");
            if(challengeNum >= 10)
            {
                switchTab = 0;
                //var but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37);
                //but0.addlabel(getStr("groupRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);
            }
            else
            {
                switchTab = 1;
                //but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37);
                //but0.addlabel(getStr("newRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);
            }

            showLabel = bg.addsprite(labelPng[switchTab]).pos(395, 96).anchor(50, 50);
        }
        else if(kind == HEART_RANK)
        {
            
        }
        else if(kind == FIGHT_RANK)
        {
            switchTab = -1;
            but0 = bg.addsprite("roleNameBut0.png").pos(388, 24).size(96, 37).setevent(EVENT_TOUCH, onView, 0);
            but0.addlabel(getStr("attackRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);
            
            but0 = bg.addsprite("roleNameBut0.png").pos(500, 24).size(96, 37).setevent(EVENT_TOUCH, onView, 1);
            but0.addlabel(getStr("defenseRank", null), null, 25).pos(48, 18).anchor(50, 50).color(100, 100, 100);
        }

        var clPos = [66, 117];
        var clSize = [665, 338];

        upArrow = sprite("upArrow.png").pos(741, 409).anchor(50, 50);
        bg.add(upArrow, 1);
        if(kind == CHALLENGE_RANK || kind == HEART_RANK)
        {
            showView = new RankBase(clPos, clSize, this, kind);
            addChild(showView);
        }
        else if(kind == FIGHT_RANK)
        {
            var v0 = new RankBase(clPos, clSize, this, ATTACK_RANK);
            var v1 = new RankBase(clPos, clSize, this, DEFENSE_RANK);
            views = [v0, v1];
            onView(null, null, 0, null, null, null);
        }
    }
    function onView(n, e, p, x, y, points)
    {
        if(switchTab != -1)
        {
            views[switchTab].removeSelf();
        }
        switchTab = p;
        addChild(views[switchTab]);
    }

    function closeDialog()
    {
        global.director.popView();
    }

}
