class Store extends MyNode
{
    var stores;
    var tabs;
    //var choose;
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

    var allGoods;
    var pics = [
     "goodTreasure.png", "goodBuild.png", "goodDecor.png",  "goodWeapon.png", "goodMagic.png",
    ];
    var titles = [
    "buyTreasure.png", "buyBuild.png", "buyDecor.png", "buyWeapon.png", "buyMagic.png",
    ];
    var silverText;
    var goldText;
    var cryText;
    function Store(s)
    {
        allGoods = StoreGoods;
        //be care of cycle reference problem
        //scene = s;

        bg = node();
        init();
        bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480);
        bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64);



        bg.addsprite("rightBack.png").anchor(0, 0).pos(254, 79).size(514, 387);
        bg.addsprite("storeLeft.png").anchor(0, 0).pos(34, 79).size(197, 386);

        var choose = sprite("instructArrow.png").anchor(0, 0).pos(22, 211).size(227, 117);
        bg.add(choose, 1);
        bg.addsprite("moneyBack.png").anchor(0, 0).pos(274, 28).size(450, 33);
        bg.addsprite("crystal.png").anchor(0, 0).pos(586, 30).size(31, 29);
        bg.addsprite("gold.png").anchor(0, 0).pos(439, 28).size(31, 30);
        bg.addsprite("silver.png").anchor(0, 0).pos(280, 27).size(32, 32);


        bg.addsprite("storeTit.png").anchor(0, 0).pos(76, 7).size(169, 63);



        goods = new Goods(this);
        addChild(goods);

        tabs = new Choice(this);
        addChild(tabs);
        //board遮挡
        bg.addsprite("leftBoard.png").anchor(0, 0).pos(29, 74).size(207, 396);

        var but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);

        initData();

        changeTab(0);
    }
    function initData()
    {
        cryText = bg.addlabel(getStr("crystal", null), "fonts/heiti.ttf", 19).anchor(0, 0).pos(621, 37).color(100, 100, 100);
        silverText = bg.addlabel(getStr("silver", null), "fonts/heiti.ttf", 19).anchor(0, 0).pos(318, 36).color(100, 100, 100);
        goldText = bg.addlabel(getStr("gold", null), "fonts/heiti.ttf", 19).anchor(0, 0).pos(474, 37).color(100, 100, 100);
        
        //silverText = bg.addlabel(str(global.user.getValue("silver")), "fonts/heiti.ttf", 18).anchor(0, 50).pos(324, 40).color(100, 100, 100);
        //goldText = bg.addlabel(str(global.user.getValue("gold")), "fonts/heiti.ttf", 18).anchor(0, 50).pos(481, 40).color(100, 100, 100);
        //cryText = bg.addlabel(str(global.user.getValue("crystal")), "fonts/heiti.ttf", 18).anchor(0, 50).pos(625, 40).color(100, 100, 100);
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
        updateValue(global.user.resource);
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
    function storeBuyGold(pid, ret, tid, receipt, param)
    {
        trace("storeBuyGold", pid, ret, tid, receipt, param);
        if(ret == 1)
        {
            var buyNum = goldGain;
            global.httpController.addRequest("finishPay", dict([["uid", global.user.uid], ["tid", tid], ["gain", json_dumps(buyNum)], ["papaya", costPapaya]]), null, null);
            global.user.doAdd(buyNum);
        }
    }
    
    var goldGain = null;
    var costPapaya = null;
    function buy(gi)
    {
        var item = allGoods[gi[0]][gi[1]]; 
//        trace("store buy", gi, item);
        var kind = item[0];
        var id = item[1];
        var cost;
        var buyable;
        var ret;

        cost = getCost(kind, id);
        //使用木瓜币 购买金币
        if(kind == GOLD)
        {
            var buyNum = getGain(kind, id);
            goldGain = buyNum;

            costPapaya = cost["papaya"];
            if(getParam("debugPay"))
                start_payment(getStr("storeBuyGold", ["[NUM]", str(buyNum["gold"])]), "", "", 1, storeBuyGold);
            else
                start_payment(getStr("storeBuyGold", ["[NUM]", str(buyNum["gold"])]), "", "", cost["papaya"], storeBuyGold);
            global.httpController.addRequest("logC/tryPay", dict([["uid", global.user.uid], ["papaya", cost["papaya"]]]), null, null);
            return;
        }


        buyable = global.user.checkCost(cost);

//        trace("buy Cost", cost, buyable);
        if(buyable.get("ok") == 0)
        {
            buyable.pop("ok");
            var it = buyable.items();
            global.director.curScene.dialogController.addBanner(new ResLackBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]) , [100, 100, 100], BUY_RES[it[0][0]], ObjKind_Page_Map[it[0][0]], this));

            return;
        }

        //0 building
        //1 equip
        if(kind == BUILD)
        {
            var data = getData(BUILD, id);
            ret = checkBuildNum(id);
            if(ret[0] == 0)
            {
                if(ret[1] == 0)//只超过等级上限
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("buildTooCon", ["[LEV]", str(getNextBuildNum(id) + 1), "[NAME]", data["name"]]), [100, 100, 100], null));
                }
                else//超过总量上限
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("buildMax", null), [100, 100, 100], null));
                return;
            }

            ret = global.msgCenter.checkCallback(BEGIN_BUILD);
            if(!ret)
            {
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("cantBuild", null), [100, 100, 100], null));
                return;
            }

            global.director.popView();
            global.msgCenter.sendMsg(BEGIN_BUILD, id);
        }
        else{
            if(kind == DRUG)
            {
                if(global.user.getDrugTotalNum() >= getParam("maxDrugNum"))
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("tooManyDrug", ["[NUM]", str(getParam("maxDrugNum"))]), [100, 100, 100], null));
                    return;
                }
                global.httpController.addRequest("goodsC/buyDrug", dict([["uid", global.user.uid], ["drugKind", id]]), null, null);
                global.user.buySomething(kind, id, null);
                global.taskModel.doAllTaskByKey("buyDrug", 1);
            }
            else if(kind == EQUIP)
            {
                var newEid = global.user.getNewEid();
                global.httpController.addRequest("goodsC/buyEquip", dict([["uid", global.user.uid], ["eid", newEid], ["equipKind", id]]), null, null);
                global.user.buySomething(kind, id, newEid);
                global.taskModel.doAllTaskByKey("buyEquip", 1);
            }
            //购买金币 需要消耗木瓜币 有所不同
            else if(kind == GOLD)
            {
            }
            else if(kind == SILVER || kind == CRYSTAL)
            {
                global.httpController.addRequest("goodsC/buyResource", dict([["uid", global.user.uid], ["kind", kind], ["oid", id]]), null, null);
                global.user.buyResource(kind, id, cost, getGain(kind, id)); 
            }
            else if(kind == TREASURE_STONE)
            {
                global.httpController.addRequest("goodsC/buyTreasureStone", dict([["uid", global.user.uid], ["tid", id]]), null, null);
                global.user.buySomething(kind, id, null);
            }
            else if(kind == MAGIC_STONE)
            {
                global.httpController.addRequest("goodsC/buyMagicStone", dict([["uid", global.user.uid], ["tid", id]]), null, null);
                global.user.buySomething(kind, id, null);
            }
            trace("addPopBanner");
            setTab(curSel);
            showMultiPopBanner(cost2Minus(cost));
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
            trace("商店 当前选择越界", i);
        }
    }
    function changeTab(i)
    {
//        trace("store changeTab", i);
        tabs.changeTab(i);        
    }
}
