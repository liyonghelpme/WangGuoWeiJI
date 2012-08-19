class Skill extends MyNode
{
    //var soldier;
    //var healthText;
    //var attText;
    //var defText;

    //var im;
    //var nameText;

    var cl;
    var flowNode;
    const OFFY = 72;
    const ROW_NUM = 5;
    const HEIGHT = OFFY*ROW_NUM;
    const ITEM_NUM = 1;
    var kind;

    //kind EQUIP  eid ---> global.user.equips level, owner, kind 
    //kind DRUG   kindId
    var data;
    //var filterIs = null;

    const EQUIP_KIND = 0;
    const DETAIL_EQUIP = 1;

    /*
    用户当前拥有的药品
    用户当前拥有的装备
    士兵当前拥有的装备
    */
    function cmp(a, b)
    {
        return a[1]-b[1];
    }
    function initData()
    {
        var skillId = soldier.data.get("skillId");
        data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, skillId];
    }
    //s 操作士兵对象 k 药品或者 武器 复活药水
    //0 1 2 3 stoneNum
    var nums = [];
    function setStoneNum()
    {
        for(var i = 0; i < 4; i++)
            nums[i].text(str(global.user.getGoodsNum(MAGIC_STONE, i)));
    }
    var soldier;
    var skillText;
    function Skill(sol)
    {
        soldier = sol;
        bg = sprite("dialogFriend.png");
        init();
        initData();

        bg.addsprite("allSkills.png").anchor(50, 50).pos(169, 41);

        var curSkillNum = global.user.getCurSkillNum(sol.sid);
        var maxSkillNum = getMaxSkillNum(getCareer(sol.id));
        skillText = bg.addlabel(getStr("heroSkillNum", ["[MAXNUM]", str(maxSkillNum), "[LEFTNUM]", str(maxSkillNum-curSkillNum)]), null, 20).anchor(50, 50).pos(393, 104).color(26, 2, 2);
        var stoneNum = bg.addsprite("magicNum.png").pos(280, 28);

        var s = stoneNum.addlabel("", null, 20).color(100, 100, 100).pos(45, 18).anchor(0, 50);
        nums.append(s);

        s = stoneNum.addlabel("", null, 20).color(100, 100, 100).pos(154, 18).anchor(0, 50);
        nums.append(s);

        s = stoneNum.addlabel("", null, 20).color(100, 100, 100).pos(273, 18).anchor(0, 50);
        nums.append(s);

        s = stoneNum.addlabel("", null, 20).color(100, 100, 100).pos(380, 18).anchor(0, 50);
        nums.append(s);

        setStoneNum();
        
    
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        cl = bg.addnode().pos(46, 90).size(703, 357).clipping(1);
        flowNode = cl.addnode();

        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(data);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    /*
    药品存储药品的类型ID
    装备存储装备的 eid
    */
    function updateTab()
    {
//        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        var skills = global.user.getSolSkills(soldier.sid);
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            var id = data[i];

            var obj = panel.addsprite(replaceStr(KindsPre[SKILL], ["[ID]", str(id)])).pos(36, 35).anchor(50, 50);
            var sca = getSca(obj, [64, 60]);
            obj.scale(sca, sca);

            var objData = getData(SKILL, id);
            panel.addlabel(objData.get("name")+" "+objData.get("des"), null, 18, FONT_NORMAL, 390, 55, ALIGN_LEFT).pos(135, 10).color(59, 56, 56);
            
            var level = skills.get(id, -1);
            var but0;
            var but1;
            var butWidth = 69;
            var butHeight = 36;
            
            //570 650
            if(level == -1)//没有学习该技能
            {
                but0 = panel.addsprite("roleNameBut0.png").pos(570, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onBuyIt, i);
                but0.addlabel(getStr("buyIt", null), null, 18).pos(34, 18).anchor(50, 50);
            }
            else 
            {
                panel.addsprite("skillLevel.png").pos(84, 53).anchor(50, 50);
                panel.addlabel(getStr("skillLevel", ["[LEV]", str(level)]), null, 15).pos(84, 53).anchor(50, 50).color(0, 100, 0);

                if(objData.get("kind") == MAKEUP_SKILL)//变身技能只能升级
                {
                    but0 = panel.addsprite("roleNameBut0.png").pos(570, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onUpgrade, i);
                    but0.addlabel(getStr("upgrade", null), null, 18).pos(34, 18).anchor(50, 50);
                }
                else//已经学习的技能可以放弃 和 升级
                {
                    but0 = panel.addsprite("roleNameBut0.png").pos(570, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onUpgrade, i);
                    but0.addlabel(getStr("upgrade", null), null, 18).pos(34, 18).anchor(50, 50);

                    but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onGiveup, i);
                    but1.addlabel(getStr("giveup", null), null , 18).pos(34, 18).anchor(50, 50);
                }        
            }
        }
                

    }
    //升级装备 参数位置 
    function onUpgrade(n, e, p, x, y, points)
    {
        var skillId = data[p];
        global.director.pushView(new UpgradeSkillDialog(this, soldier.sid, skillId), 1, 0);
    }
    //放弃技能
    function onGiveup(n, e, p, x, y, points)
    {
        var skillId = data[p];
        global.httpController.addRequest("soldierC/giveupSkill", dict([["uid", global.user.uid], ["soldierId", soldier.sid], ["skillId", skillId]]), null, null);

        global.user.giveupSkill(soldier.sid, skillId);
        updateTab();
    }
    var buySkillId;
    //显示购买的资源资源对话框
    function onBuyIt(n, e, p, x, y, points)
    {
        var skillId = data[p];
        buySkillId = skillId;

        var cost = getCost(SKILL, skillId);
        var sdata = getData(SKILL, skillId);
        var buyable = global.user.checkCost(cost);
        global.director.pushView(
                new ResourceWarningDialog(
                        getStr("buySkillTit", null), 
                        getStr("buySkillCon", ["[NAME]", sdata.get("name")]),
                        doBuySkill, buyable, cost, replaceStr(KindsPre[SKILL], ["[ID]", str(skillId)])
                        )
                , 1, 0);
    }
    function doBuySkill(cost)
    {
        global.httpController.addRequest("soldierC/buySkill", dict([["uid", global.user.uid], ["soldierId", soldier.sid], ["skillId", buySkillId]]), null, null);
        global.user.buySkill(soldier.sid, buySkillId);
        updateTab();
    }

    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);

        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }

    function buyIt(n, e, p, x, y, points)
    {
        global.director.popView();
        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        if(kind == DRUG)
            store.changeTab(store.DRUG_PAGE);
        else if(kind == EQUIP)
            store.changeTab(store.EQUIP_PAGE);
    }

    //升级装备 降级装备
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_SKILL)
        {
            updateTab(); 
        }
        else if(msgId == UPDATE_MAGIC_STONE)//变更宝石数量
        {
            setStoneNum(); 
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_SKILL, this);
        global.msgCenter.registerCallback(UPDATE_MAGIC_STONE, this);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_SKILL, this);
        global.msgCenter.removeCallback(UPDATE_MAGIC_STONE, this);
        super.exitScene();
    }
}
