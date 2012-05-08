class Store extends MyNode
{
    var stores;
    var tabs;
    var choose;
    var goods;

    //curSel buy object
    //kind id
    //0 building
    var allGoods = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [[0, 0], [0, 1]],
        [0, 0, 0, 0],
        [0, 0, 0],
    ];

    var pics = [
    "goodNew.png", "goodGold.png", "goodSilver.png", "goodCrystal.png","goodBuild.png", "goodWeapon.png", "goodDrug.png",
    ];

    var titles = [
    "buyNew.png", "buyGold.png", "buySilver.png", "buyCrystal.png", "buyBuild.png", "buyWeapon.png", "buyDrug.png",
    ];
    var words = [
        "buyNew", "buyGold", "buySilver", "buyCrystal", "buyBuild", "buyWeapon", "buyDrug",
    ];
    var silverText;
    var goldText;
    var cryText;
    var scene;
    function Store(s)
    {
        //be care of cycle reference problem
        scene = s;
        bg = sprite("goodBack.jpg");
        init();

        goods = new Goods(this);
        addChild(goods);

        tabs = new Choice(this);
        addChild(tabs);
        choose = sprite("goodsChoice.png").pos(134, 266).anchor(50, 50);
        bg.add(choose, 1, 1);

        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        initData();

    }
    function initData()
    {
        silverText = bg.addlabel(str(global.user.getValue("silver")), null, 18).anchor(0, 50).pos(324, 40).color(100, 100, 100);
        goldText = bg.addlabel(str(global.user.getValue("gold")), null, 18).anchor(0, 50).pos(481, 40).color(100, 100, 100);
        cryText = bg.addlabel(str(global.user.getValue("crystal")), null, 18).anchor(0, 50).pos(625, 40).color(100, 100, 100);
    }
    function updateValue(res)
    {
        silverText.text(str(res.get("silver")));
        goldText.text(str(res.get("gold")));
        cryText.text(str(res.get("crystal")));
    }
    override function enterScene()
    {
        global.user.addListener(this);
    }
    override function exitScene()
    {
        global.user.removeListener(this);
    }

    function closeDialog(n, e, p, x, y, points)
    {
        global.director.popView(); 
    }
    //allGoods item tab item
    function buy(gi)
    {
        var item = allGoods[gi[0]][gi[1]]; 
        var kind = item[0];
        var id = item[1];
        if(kind == 0)
        {
            var cost = getBuildCost(id);
            var buyable = global.user.checkCost(cost);
            if(buyable.get("ok") == 0)
                return;
            global.director.popView();
            scene.build(id);
        }
    }
    var curSel = -1;
    function setTab(i)
    {
        if(i >= 0 && i < len(allGoods))
        {
            curSel = i;
            goods.setTab(i);
        }
        else
            trace("i out of bound", i);
    }
}
