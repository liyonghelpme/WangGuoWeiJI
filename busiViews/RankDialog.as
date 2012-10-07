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


    var showView;
    var kind;


    var blueArrow;
    var newRankTitle;
    function initView()
    {
        bg = node();
        init();
        bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        var but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);
        blueArrow = sprite("blueArrow.png").anchor(50, 50).pos(745, 403).size(32, 70).color(100, 100, 100, 100);
        bg.add(blueArrow, 1);
        if(kind == HEART_RANK)
            but0 = new NewButton("violetBut.png", [113, 42], getStr("rankInfo", null), null, 20, FONT_NORMAL, [100, 100, 100], onRankInfo, null);
        else 
            but0 = new NewButton("blueButton.png", [113, 42], getStr("rankInfo", null), null, 20, FONT_NORMAL, [100, 100, 100], onRankInfo, null);
        but0.bg.pos(645, 43);
        addChild(but0);
        newRankTitle = bg.addsprite("newRankTitle.png").anchor(50, 50).pos(169, 43).size(174, 61).color(100, 100, 100, 100);
    }
    function onRankInfo()
    {
        global.director.pushView(new NoTipDialog(HEART_TIP), 1, 0);
    }
    function RankDialog(k)
    {
        kind = k;
        initView();

        if(kind == CHALLENGE_RANK)
        {
            var challengeNum = global.user.getValue("challengeNum");
            if(challengeNum >= PARAMS["newRank"])
            {
                newRankTitle.texture("challengeRankTitle.png", UPDATE_SIZE);
            }
            else
            {
                newRankTitle.texture("newRankTitle.png", UPDATE_SIZE);
            }
        }
        else if(kind == HEART_RANK)
        {
            newRankTitle.texture("heartRankTitle.png", UPDATE_SIZE); 
        }
        else if(kind == FIGHT_RANK)
        {
            newRankTitle.texture("defenseRankTitle.png", UPDATE_SIZE); 
        }

        showView = new RankBase(this, kind);
        addChild(showView);

    }

    function closeDialog()
    {
        global.director.popView();
    }

}
