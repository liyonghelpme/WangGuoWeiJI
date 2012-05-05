class Store extends MyNode
{
    var stores;
    var tabs;
    var choose;
    var goods;

    var allGoods = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
    ];

    var pics = [
    "goodWeapon.png", "goodGold.png", "goodSilver.png", "goodCrystal.png","goodBuild.png", 
    ];

    var words = [
        "buyWeapon", "buyGold", "buySilver", "buyCrystal", "buyBuild",
    ];
    function Store()
    {
        bg = sprite("goodBack.png");
        init();

        goods = new Goods(this);
        addChild(goods);

        tabs = new Choice(this);
        addChild(tabs);
        choose = sprite("goodsChoice.png").pos(134, 266).anchor(50, 50);
        bg.add(choose, 1, 1);

        bg.addsprite("close.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

    }
    function closeDialog(n, e, p, x, y, points)
    {
        
    }

    function setTab(i)
    {
        if(i >= 0 && i < len(allGoods))
            goods.setTab(i);
        else
            trace("i out of bound", i);
    }
}
