//skill FlowBanner
//选择技能
//控制技能释放的位置
//如果英雄死亡 则 停止释放
//清空技能列表
class SkillFlowBanner extends MyNode
{
    const WIDTH = 103;
    const HEIGHT = 90;
    const COL_NUM = 5;
    const ITEM_NUM = 1;
    const PANEL_WIDTH = 90;
    const PANEL_HEIGHT = 90;
    const TOTAL_WIDTH = WIDTH*COL_NUM;

    var pausePage;
    var soldier = null;
    //id level coldTime ready
    var skillList = [];
    var cl;
    var flowNode;

    var shadowWord;
    var words;
    //显示 生命值上限 攻击力 防御力 药水
    //药水 数量 
    //drug：data

    //id num coldTime ready
    var drugData;
    //排序药品 
    function cmp(a, b)
    {
        return a[0]-b[0];
        //getData(DRUG, a[0]).get("id") - getData(DRUG, b[0]).get("id");
    }
    //超过skillList 的长度
    //skillList = soldierItems
    //drugData = hereColdTime
    //ShowData
    function initDrug()
    {
        drugData = [];
        var temp = global.user.drugs.items();
        for(var i = 0; i < len(temp); i++)
        {
            var dd = getData(DRUG, temp[i][0]);
            if(temp[i][1] > 0)
            {
                if(dd.get("healthBoundary") > 0 || dd.get("percentHealthBoundary") > 0
                    || dd.get("attack") > 0 || dd.get("percentAttack") > 0
                    || dd.get("defense") > 0 || dd.get("percentDefense") > 0
                )
                {
                    drugData.append([temp[i][0], 0, 0, 1]);//drugId
                }
                //训练场景显示补血药品
                if(pausePage.scene.kind == CHALLENGE_TRAIN)
                {
                    if(dd.get("health") > 0 || dd.get("percentHealth") > 0)
                        drugData.append([temp[i][0], 0, 0, 1]);//drugId
                }
            }
        }
        bubbleSort(drugData, cmp);
    }
    /*
    选择士兵 显示 士兵的属性值 左上角
    */
    var attributeList = null;
    function SkillFlowBanner(s)
    {
        pausePage = s;
        bg = node();
        init();
        cl = bg.addnode().size(TOTAL_WIDTH, 82).pos(9, 384).clipping(1);
        flowNode = cl.addnode();
        initDrug();

        //setSoldier(null);
        updateSkillPanel(null);

        shadowWord = bg.addsprite("storeBlack.png").pos(10, 323).visible(0);
        words = null;
        
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var accMove;
    var lastPoints;
    //kind level coldTime ready
   
    //准备好则不显示shadow
    //没有准备好则显示shadow
    //冷却时间不同 全局 由 SkillFlow 控制
    function update(diff)
    {
        if(soldier != null && soldier.state == MAP_SOL_DEAD)//如果士兵死亡
        {
            setSoldier(null);
        }

        if(attributeList != null)
        {
            attributeList.removefromparent();
            attributeList = null;
        }
        if(soldier != null)
        {
            attributeList = stringLines(getStr("solAtt", ["[HEAL]", str(soldier.health), 
                                        "[NAME]", soldier.data.get("name"), 
                                        "[BOUNDARY]", str(soldier.healthBoundary),
                                        "[PATTACK]", str(soldier.physicAttack),
                                        "[PDEFENSE]", str(soldier.physicDefense),
                                        "[MAGATT]", str(soldier.magicAttack),
                                        "[MAGDEF]", str(soldier.magicDefense),
                                        "[RANGE]", str(soldier.attRange),
                                        "[SPEED]", str(soldier.attSpeed),
                                        "[EXP]", str(soldier.exp),
                                        "[NEEDEXP]", str(getLevelUpExp(soldier.id, soldier.level)),
                                        "[LEV]", str(soldier.level),
                                        ]), 
                                        18, 20, [0, 0, 0]);
            attributeList.pos(50, 140);
            bg.add(attributeList);
        }

        var panel;
        var pSize;
        var i;
        var pData;
        var ready;
        var shadow;
        var coldTime;
        var sSize;
        var rate;
        var kind;
        for(i = 0; i < len(drugData); i++)
        {
            ready = drugData[i][3];
            if(!ready)
            {
                drugData[i][2] += diff; 
                if(drugData[i][2] >= DRUG_COLD_TIME)
                {
                    drugData[i][2] = 0;
                    drugData[i][3] = 1;
                }
            }
        }
        //遍历所有 面板
        //更新阴影状态
        for(var j = 0; j < len(allPanels); j++)
        {
            panel = allPanels[j];
            pSize = panel.prepare().size();
            pData = panel.get();

            //技能 药品
            kind = pData[0];
            //对应编号
            i = pData[1];
            
            if(kind == SKILL)
                ready = skillList[i][3];
            else 
                ready = drugData[i][3];

            shadow = panel.get(1);
            //ready 删除
            if(ready)
            {
                if(shadow != null)
                {
                    shadow.removefromparent();
                }
                continue;
            }
            else
            {
                if(shadow == null)
                {
                    shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                    panel.add(shadow, 1, 1);//tag = 1
                }
                sSize = panel.prepare().size();//应该是panel的Size
                //技能未冷却
                if(pData[0] == SKILL)
                {
                    var skillId = skillList[i][0];
                    var skTime = skillList[i][2];
                    //拯救技能 升级减少冷却时间
                    //单体攻击 群体攻击 直线攻击
                    //冷却时间是由 士兵timer决定的
                    coldTime = getSkillColdTime(soldier.sid, skillId);
                    rate = max((coldTime-skTime), 0)*100/coldTime;//leftTime
                    //trace("rate", rate, coldTime, skillList[i]);
                }
                //药品未冷却
                else if(pData[0] == DRUG)
                {
                    var passTime = drugData[i][2];
                    rate = max((DRUG_COLD_TIME-passTime), 0)*100/DRUG_COLD_TIME;//leftTime
                }
                shadow.size(sSize[0], sSize[1]*rate/100);
            }
        }

    }
    //停止药品更新状态
    override function enterScene()
    {
        super.enterScene();
        pausePage.scene.sceneSlowTimer.addTimer(this);
        //global.timer.addTimer(this);
        //global.msgCenter.registerCallback(UPDATE_SKILL_STATE, this);
    }
    //使用技能tar！=null 施法成功
    //取消技能
    //士兵管理数据 这里 管理view 如果数据没有ready 则显示 shadow
    function finishSkill(tar)
    {
        if(tar != null)
        {
            var kind = selSkill.get()[0]
            var selNum = selSkill.get()[1];
            if(kind == SKILL)
            {
                skillList[selNum][3] = 0;//ready = 0 施法士兵 修改自身状态
                skillList[selNum][2] = 0;//coldTime now
            }
            else if(kind == DRUG)
            {
                drugData[selNum][3] = 0;//ready = 0 施法士兵 修改自身状态
                drugData[selNum][2] = 0;//coldTime now
                global.httpController.addRequest("soldierC/useDrugInRound", dict([["uid", global.user.uid], ["tid", drugData[selNum][0]]]), null, null);
                global.user.changeGoodsNum(DRUG, drugData[selNum][0], -1);
                var num = global.user.getGoodsNum(DRUG, drugData[selNum][0]);
                if(num <= 0)
                    drugData.pop(selNum);
            }
            updateSkillPanel(soldier);
        }
        trace("finishSkill", words);
        clearSelSkill();
    }
    function clearSelSkill()
    {
        shadowWord.visible(0);
        if(words != null)
        {
            words.removefromparent();
            words = null;
        }
        if(selSkill != null)
        {
            selSkill.texture("mapUnSel.png");
            selSkill = null;
        }
    }

    override function exitScene()
    {
        pausePage.scene.sceneSlowTimer.removeTimer(this);
        //global.timer.removeTimer(this);
        super.exitScene();
    }
    var curSel;
    function touchBegan(n, e, p, x, y, points)
    {
        //if(selSkill == null)//没有进入技能释放状态
        //如果进入技能释放状态 如果当前点击到其它技能则切换技能
        {
            curSel = null;
            accMove = 0;
            lastPoints = n.node2world(x, y);

            var child = checkInChild(flowNode, lastPoints);
            if(child != null)
            {
                var kind = child.get()[0];
                var selNum = child.get()[1];
                var ready;
                if(kind == SKILL)
                    ready = skillList[selNum][3];
                else if(kind == DRUG)
                    ready = drugData[selNum][3];
                if(ready)//技能 药品已经准备完善
                {
                    if(selSkill == child)//新选择如果和当前选择技能一致则取消技能
                    {
                        pausePage.scene.cancelSkill();
                        clearSelSkill();
                    }
                    else//新选择不同于当前技能
                    {
                        if(selSkill != null)//选择其它技能放弃当前技能                         
                            clearSelSkill();
                        child.texture("mapSel.png");
                        curSel = child;
                    }
                }
                else
                {
                    //var coldTime = getSkillColdTime(soldier.sid, skillList[selNum][0]);
                    //trace("skillNotReady", skillList[selNum], coldTime);
                }
            }
        }
    }

    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        
        var curPos = flowNode.pos();
        curPos[0] += difx;
        flowNode.pos(curPos);

        accMove += abs(difx);
    }

    var selSkill = null;
    //点击背景地图 选择技能
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);

        if(curSel != null && accMove >= 10)
        //移动步子太大 取消选择
        {
            curSel.texture("mapUnSel.png");
        }
        if(accMove < 10 && curSel != null)
        //移动步子小确认选择
        {
            selSkill = curSel;
            var kind = curSel.get()[0];
            var selectNum = curSel.get()[1];
            //当前没有选择技能 则选择技能
            var w = "";
            if(kind == SKILL)
            {
                var sdata = getData(SKILL, skillList[selectNum][0]); 
                var skillKind = sdata.get("kind");
                
                if(skillKind == MAKEUP_SKILL && soldier.makeUpState)//士兵已经处于变身状态 不能再次变身 清理按钮状态
                {
                    clearSelSkill();
                    return;
                }

                if(skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL)
                {
                    w = getStr("selTarget", null);
                }
                else if(skillKind == MULTI_ATTACK_SKILL)
                {
                    w = getStr("selMulti", null);
                }
                else if(skillKind == LINE_SKILL)
                {
                    w = getStr("selRow", null);
                }
                else if(skillKind == HEAL_SKILL || skillKind == MULTI_HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == MAKEUP_SKILL )
                    w = getStr("selOurSol", null);

            }
            else if(kind == DRUG)
            {
                w = getStr("selOurSol", null);
            }
            words = shadowWord.addlabel(w, null, 25);
            var wSize = words.prepare().size();
            var sSize = shadowWord.prepare().size();
            sSize[0] = max(wSize[0], sSize[0]);
            shadowWord.size(sSize);
            words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);
            shadowWord.visible(1);
            
            if(kind == SKILL)
                pausePage.scene.selectSkill(soldier, skillList[selectNum][0]);
            else if(kind == DRUG)
                pausePage.scene.selectDrug(soldier, drugData[selectNum][0]);
        }
        
        var curPos = flowNode.pos();
        var cols = (len(allPanels)+ITEM_NUM-1)/ITEM_NUM;
        curPos[0] = min(0, max(-cols*WIDTH+TOTAL_WIDTH, curPos[0]));
        flowNode.pos(curPos);
    }

    //内部更新所有面板状态函数
    function updateSkillPanel(sol)
    {
        allPanels = [];

        soldier = sol;
        if(soldier == null)
            skillList = [];
        else
            skillList = sol.skillList;//global.user.getSolSkills(soldier.sid).items();//skillId level lastColdTime



        flowNode.removefromparent();
        flowNode = cl.addnode(); 
        //点击技能
        var panel;
        var ready;
        var pSize;
        var shadow;
        var i;
        var id;
        var sca;
        for(i = 0; i < len(skillList); i++)
        {
            panel = flowNode.addsprite("mapUnSel.png").pos(i*WIDTH, 0);
            allPanels.append(panel);//对应相应技能位置 面板
            id = skillList[i][0];
            
            var skillPic = panel.addsprite(replaceStr(KindsPre[SKILL], ["[ID]", str(skillList[i][0])])).anchor(50, 50).pos(PANEL_WIDTH/2, PANEL_HEIGHT/2);
            sca = getSca(skillPic, [PANEL_WIDTH, PANEL_HEIGHT]);
            skillPic.scale(sca);

            panel.addsprite("skillLevel.png").pos(53, 66).anchor(50, 50);
            panel.addlabel(getStr("skillLevel", ["[LEV]", str(skillList[i][1])]), null, 15).pos(53, 66).anchor(50, 50).color(100, 100, 100);

            ready = skillList[i][3];

            if(!ready)
            {
                pSize = panel.prepare().size();
                shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                panel.add(shadow, 1, 1);//tag = 1
            }

            panel.put([SKILL, i]);
        }
        //点击药品
        for(i = 0; i < len(drugData); i++)
        {
            panel = flowNode.addsprite("mapUnSel.png").pos((i+len(skillList))*WIDTH, 0);

            allPanels.append(panel);//对应相应技能位置 面板
            var drugPic = panel.addsprite(replaceStr(KindsPre[DRUG], ["[ID]", str(drugData[i][0])])).anchor(50, 50).pos(PANEL_WIDTH/2, PANEL_HEIGHT/2);
            sca = getSca(drugPic, [PANEL_WIDTH, PANEL_HEIGHT]);
            drugPic.scale(sca);
            
            panel.addsprite("skillLevel.png").pos(53, 66).anchor(50, 50);
            panel.addlabel(str(global.user.getGoodsNum(DRUG, drugData[i][0])), null, 15).pos(53, 66).anchor(50, 50).color(100, 100, 100);

            ready = drugData[i][3];
            if(!ready)//技能ID 与众不同
            {
                pSize = panel.prepare().size();
                shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                panel.add(shadow, 1, 1);//tag = 1
            }
            panel.put([DRUG, i]);
        }
    }
    //所有的技能菜单
    //外部调用 设定 当前士兵函数
    var allPanels = [];
    function setSoldier(sol)
    {
        trace("setSoldier");
        if(soldier == sol)
            return;
        if(soldier != null)
        {
            soldier.clearSkillState();
        }
        if(sol != null)
        {
            sol.setSkillState();
        }
        updateSkillPanel(sol); 
        
    }

}
