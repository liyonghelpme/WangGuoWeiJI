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



    /*
    商店去除 编号 126木牌建筑物 数据库也可以删除
    */
    var allGoods = [
        [[MAGIC_STONE, 0], [MAGIC_STONE, 1], [MAGIC_STONE, 2], [MAGIC_STONE, 3],  [TREASURE_STONE, 0],  [TREASURE_STONE, 1], [TREASURE_STONE, 2], [TREASURE_STONE, 3], [0, 142], [0, 144], [1, 20], [1, 21]],
        [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [FREE_GOLD, 0]],
        [[4, 0], [4, 1], [4, 2]],
        [[5, 0], [5, 1], [5, 2]],
        [[0, 0], [0, 1], [0, 10], [0, 12]],
        [[0, 100], [0, 102], [0, 104], [0, 106], [0, 108], [0, 110], [0, 112], [0, 114], [0, 116], [0, 118], [0, 120], [0, 122], [0, 124], [0, 128], [0, 130], [0, 132], [0, 134], [0, 136], [0, 138], [0, 140], [0, 142], [0, 144], [0, 146], [0, 148], [0, 150], [0, 152], [0, 154], [0, 156], [0, 158], [0, 160], [0, 162], [0, 164]],

        [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 12], [1, 13], [1, 14], [1, 15], [1, 16], [1, 17], [1, 18], [1, 19], [1, 20], [1, 21], [1, 22], [1, 23], [1, 24], [1, 25], [1, 26], [1, 27], [1, 28], [1, 29], [1, 30], [1, 31], [1, 32], [1, 33], [1, 34], [1, 35], [1, 36], [1, 37], [1, 38], [1, 39], [1, 40], [1, 41], [1, 42], [1, 43], [1, 44], [1, 45], [1, 46], [1, 47], [1, 48], [1, 49], [1, 50], [1, 51], [1, 52], [1, 53], [1, 54], [1, 55], [1, 56], [1, 57], [1, 58], [1, 59], [1, 60], [1, 61], [1, 62], [1, 63], [1, 64], [1, 65], [1, 66], [1, 67], [1, 68], [1, 69], [1, 70], [1, 71], [1, 72], [1, 73], [1, 74], [1, 75], [1, 76], [1, 77], [1, 78], [1, 79], [1, 80], [1, 81], [1, 82], [1, 83], [1, 84], [1, 85], [1, 86], [1, 87], [1, 88], [1, 89], [1, 90], [1, 91], [1, 92], [1, 93], [1, 94], [1, 95], [1, 96], [1, 97], [1, 98], [1, 99], [1, 100], [1, 101], [1, 102], [1, 103], [1, 104], [1, 105], [1, 106], [1, 107], [1, 108], [1, 109], [1, 110], [1, 111], [1, 112], [1, 113], [1, 114], [1, 115], [1, 116], [1, 117], [1, 118], [1, 119], [1, 120], [1, 121], [1, 122], [1, 123], [1, 124], [1, 125], [1, 126], [1, 127], [1, 128], [1, 129], [1, 130], [1, 131], [1, 132], [1, 133]],


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

        changeTab(NEW_GOODS);
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
        //global.user.addListener(this);
        global.msgCenter.registerCallback(UPDATE_RESOURCE, this);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_RESOURCE)
        {
            updateValue(global.user.resource);
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_RESOURCE, this);
        //global.user.removeListener(this);
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
//        trace("store buy", gi, item);
        var kind = item[0];
        var id = item[1];
        var cost;
        var buyable;

        cost = getCost(kind, id);
        buyable = global.user.checkCost(cost);

//        trace("buy Cost", cost, buyable);
        if(buyable.get("ok") == 0)
        {
            addChildZ(new ResourceBanner(buyable, 506, 231), 1);
            return;
        }

        //0 building
        //1 equip
        if(kind == BUILD)
        {
            var data = getData(BUILD, id);
            if(data.get("funcs") == FARM_BUILD)//FARM 
            {
                var ret = checkFarmNum(); 
                if(ret == 0)
                {
                    global.director.pushView(new MyWarningDialog(getStr("farmTooTitle", null), getStr("farmTooCon", ["[LEV]", str(global.user.getValue("level")+1+1)]), null), 1, 0);
                    return;
                }
            }

            global.director.popView();
            scene.beginBuild(id);
        }
        else if(kind == DRUG)
        {
            if(kind == DRUG)
                global.httpController.addRequest("goodsC/buyDrug", dict([["uid", global.user.uid], ["drugKind", id]]), null, null);

            global.user.buySomething(kind, id, cost);
            /*
            刷新当前购买页面
            */
            setTab(curSel);
            //addChildZ(new SucBanner(), 1);
            global.director.curScene.addChild(new UpgradeBanner(getStr("buySuc", null), [100, 100, 100], null));

            global.taskModel.finishTask(ONCE_TASK, "buy", 0, [DRUG, id]);
        }
        else if(kind == EQUIP)
        {
            var newEid = global.user.getNewEid();
            global.httpController.addRequest("goodsC/buyEquip", dict([["uid", global.user.uid], ["eid", newEid], ["equipKind", id]]), null, null);
            global.user.buyEquip(newEid, id, cost);
            global.taskModel.finishTask(ONCE_TASK, "buy", 0, [EQUIP, id]);

            setTab(curSel);
            //addChildZ(new SucBanner(), 1);
            global.director.curScene.addChild(new UpgradeBanner(getStr("buySuc", null), [100, 100, 100], null));
        }
        else if(kind == GOLD || kind == SILVER || kind == CRYSTAL)
        {
            global.user.buyResource(kind, id, cost, getGain(kind, id)); 
            setTab(curSel);
            //addChildZ(new SucBanner(), 1);
            global.director.curScene.addChild(new UpgradeBanner(getStr("buySuc", null), [100, 100, 100], null));
        }
        else if(kind == TREASURE_STONE)
        {
            global.httpController.addRequest("goodsC/buyTreasureStone", dict([["uid", global.user.uid], ["tid", id]]), null, null);
            global.user.buyTreasureStone(id);
            setTab(curSel);
            //addChildZ(new SucBanner(), 1);
            global.director.curScene.addChild(new UpgradeBanner(getStr("buySuc", null), [100, 100, 100], null));
        }
        else if(kind == MAGIC_STONE)
        {
            global.httpController.addRequest("goodsC/buyMagicStone", dict([["uid", global.user.uid], ["tid", id]]), null, null);
            global.user.buyMagicStone(id);
            setTab(curSel);
            //addChildZ(new SucBanner(), 1);
            global.director.curScene.addChild(new UpgradeBanner(getStr("buySuc", null), [100, 100, 100], null));
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
        {
//            trace("商店 当前选择越界", i);
        }
    }
    function changeTab(i)
    {
//        trace("store changeTab", i);
        tabs.changeTab(i);        
        //setTab(i);
    }
}
