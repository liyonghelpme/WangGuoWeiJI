
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

    const NEW_GOODS = 0;
    const GOLD_PAGE = 1;
    const SILVER_PAGE = 2;
    const CRYSTAL_PAGE = 3;
    const BUILD_PAGE = 4;
    const DECOR_PAGE = 5;
    const EQUIP_PAGE = 6;
    const DRUG_PAGE = 7;


    var allGoods = [
        [[0, 142], [0, 144], [1, 20], [1, 21]],
        [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [FREE_GOLD, 0]],
        [[4, 0], [4, 1], [4, 2]],
        [[5, 0], [5, 1], [5, 2]],
        [[0, 0], [0, 1], [0, 10], [0, 12]],
        [[0, 100], [0, 102], [0, 104], [0, 106], [0, 108], [0, 110], [0, 112], [0, 114], [0, 116], [0, 118], [0, 120], [0, 122], [0, 124], [0, 126], [0, 128], [0, 130], [0, 132], [0, 134], [0, 136], [0, 138], [0, 140], [0, 142], [0, 144], [0, 146], [0, 148], [0, 150], [0, 152], [0, 154], [0, 156], [0, 158], [0, 160], [0, 162], [0, 164]],

        [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 12], [1, 13], [1, 14], [1, 15], [1, 16], [1, 17], [1, 18], [1, 19], [1, 20], [1, 21], [1, 22], [1, 23], [1, 24], [1, 25], [1, 26], [1, 27], [1, 28], [1, 29], [1, 30], [1, 31], [1, 32], [1, 33], [1, 34], [1, 35], [1, 36], [1, 37], [1, 38], [1, 39], [1, 40], [1, 41], [1, 42], [1, 43], [1, 44], [1, 45], [1, 46], [1, 47], [1, 48], [1, 49], [1, 50], [1, 51], [1, 52], [1, 53], [1, 54], [1, 55], [1, 56], [1, 57], [1, 58], [1, 59], [1, 60], [1, 61], [1, 62]],


        [[2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 10], [2, 11], [2, 12], [2, 13], [2, 14], [2, 20], [2, 21], [2, 22], [2, 23], [2, 24], [2, 30], [2, 31], [2, 32], [2, 33], [2, 34]],

    ];

    var pics = [
    "goodNew.png", "goodGold.png", "goodSilver.png", "goodCrystal.png","goodBuild.png", "goodDecor.png",  "goodWeapon.png", "goodDrug.png",
    ];

    var titles = [
    "buyNew.png", "buyGold.png", "buySilver.png", "buyCrystal.png", "buyBuild.png", "buyDecor.png", "buyWeapon.png", "buyDrug.png",
    ];
    /*
    var words = [
        "buyNew", "buyGold", "buySilver", "buyCrystal", "buyBuild", "buyDecor", "buyWeapon", "buyDrug",
    ];
    */
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

        changeTab(0);
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
        var item = allGoods[gi[0]][gi[1]]; 
        trace("store buy", gi, item);
        var kind = item[0];
        var id = item[1];
        var cost;
        var buyable;

        cost = getCost(kind, id);
        buyable = global.user.checkCost(cost);

        trace("buy Cost", cost, buyable);
        if(buyable.get("ok") == 0)
        {
            addChildZ(new ResourceBanner(buyable, 506, 231), 1);
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
    function changeTab(i)
    {
        trace("store changeTab", i);
        tabs.changeTab(i);        
        //setTab(i);
    }
}
