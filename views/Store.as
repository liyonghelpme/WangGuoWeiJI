class SucBanner extends MyNode
{
    function SucBanner()
    {
        bg = sprite("storeBlack.png").pos(506, 231).anchor(50, 50);
        bg.addlabel(getStr("buySuc", null), null, 25).pos(154, 25).anchor(50, 50).color(100, 100, 100);
        bg.addaction(sequence(delaytime(1000), callfunc(removeSelf)));
    }
}
class Store extends MyNode
{
    var stores;
    var tabs;
    var choose;
    var goods;

    //curSel buy object
    //类型 id
    //0   building
    //1 equipment
    //2 drug
    //3 gold
    //4 silver
    //5 crystal
    //6 plant

    var allGoods = [
        [[0, 142], [0, 144], [1, 20], [1, 21]],
        [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5]],
        [[4, 0], [4, 1], [4, 2]],
        [[5, 0], [5, 1], [5, 2]],
        [[0, 0], [0, 1], [0, 10], [0, 12], [0, 200], [0, 202], [0, 204], [0, 206]],
        [[0, 100], [0, 102], [0, 104], [0, 106], [0, 108], [0, 110], [0, 112], [0, 114], [0, 116], [0, 118], [0, 120], [0, 122], [0, 124], [0, 126], [0, 128], [0, 130], [0, 132], [0, 134], [0, 136], [0, 138], [0, 140], [0, 142], [0, 144]],
        [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 12], [1, 13], [1, 14], [1, 15], [1, 16], [1, 17], [1, 18], [1, 19], [1, 20], [1, 21]],
        [[2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 10], [2, 11], [2, 12], [2, 13], [2, 14], [2, 20], [2, 21], [2, 22], [2, 23], [2, 24], [2, 30], [2, 31], [2, 32], [2, 33], [2, 34]],

    ];

    var pics = [
    "goodNew.png", "goodGold.png", "goodSilver.png", "goodCrystal.png","goodBuild.png", "goodDecor.png",  "goodWeapon.png", "goodDrug.png",
    ];

    var titles = [
    "buyNew.png", "buyGold.png", "buySilver.png", "buyCrystal.png", "buyBuild.png", "buyDecor.png", "buyWeapon.png", "buyDrug.png",
    ];
    var words = [
        "buyNew", "buyGold", "buySilver", "buyCrystal", "buyBuild", "buyDecor", "buyWeapon", "buyDrug",
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
        super.enterScene();
        global.user.addListener(this);
    }
    override function exitScene()
    {
        global.user.removeListener(this);
        super.exitScene();
    }

    function closeDialog(n, e, p, x, y, points)
    {
        global.director.popView(); 
    }
    //allGoods item tab item
    function buy(gi)
    {
        trace("store buy", gi);
        var item = allGoods[gi[0]][gi[1]]; 
        var kind = item[0];
        var id = item[1];
        var cost;
        var buyable;

        cost = getCost(kind, id);
        buyable = global.user.checkCost(cost);

        trace("buy Cost", cost, buyable);
        if(buyable.get("ok") == 0)
        {
            return;
        }
        //0 building
        //1 equip
        if(kind == BUILD)
        {
            global.director.popView();
            scene.build(id);
        }
        else if(kind == EQUIP || kind == DRUG)
        {
            global.user.buySomething(kind, id, cost);
            //global.user.buyEquip(id, cost);
            /*
            刷新当前购买页面
            */
            setTab(curSel);
            addChildZ(new SucBanner(), 1);
        }
        /*
        else if(kind == DRUG)
        {
            global.user.buyDrug(id, cost);
            setTab(curSel);
            addChildZ(new SucBanner(), 1);
        }
        */
        else if(kind == GOLD || kind == SILVER || kind == CRYSTAL)
        {
            global.user.buyResource(kind, id, cost, getGain(kind, id)); 
            setTab(curSel);
            addChildZ(new SucBanner(), 1);
        }
    }
    /*
    在当前没有选择该页面的时候， 改变页面
    */
    var curSel = -1;
    function setTab(i)
    {
        if(i >= 0 && i < len(allGoods))
        {
            if(curSel != i)
            {
                curSel = i;
                goods.setTab(i);
            }
        }
        else
            trace("商店 当前选择越界", i);
    }
}
