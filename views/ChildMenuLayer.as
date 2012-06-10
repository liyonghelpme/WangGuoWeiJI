class ChildMenuLayer extends MyNode
{
    var functions;
    var scene;
    var buts = dict([
    ["map", ["menu_button_map.png", onMap]],
    ["friend", ["menu_button_friend.png", onFriend]],
    ["mail", ["menu_button_mail.png", onMail]],
    ["plan", ["menu_button_plan.png", onPlan]],
    ["rank", ["menu_button_rank.png", onRank]],
    ["role", ["menu_button_role.png", onRole]],
    ["setting", ["menu_button_setting.png", onSetting]],
    ["store", ["menu_button_store.png", onStore]],

    ["photo", ["menu_button_photo.png", onPhoto]],
    ["acc", ["menu_button_acc.png", onAcc]],
    ["sell", ["menu_button_sell.png", onSell]],

    ["story", ["menu_button_story.png", onStory]],
    ["soldier", ["menu_button_soldier.png", onSoldier]],
    ["collection", ["menu_button_collection.png", onCollection]],
    ["tip", ["menu_button_tip.png", onTip]],

    ["relive", ["menu_button_relive.png", onRelive]],
    ["transfer", ["menu_button_transfer.png", onTransfer]],

    ["forge", ["menu_button_forge.png", onForge]],
    ["makeDrug", ["menu_button_makeDrug.png", onMakeDrug]],

    ["drug", ["menu_button_drug.png", onDrug]],
    ["inspire", ["menu_button_inspire.png", onInspire]],
    ["equip", ["menu_button_equip.png", onEquip]],
    ["gather", ["menu_button_gather.png", onGather]],
    ["train", ["menu_button_train.png", onTrain]],

    ]);
    function onTrain()
    {
    }
    function onDrug()
    {
    }
    /*
    鼓舞士兵
    */
    function onInspire()
    {
        scene.inspireMe();   
        global.director.curScene.closeGlobalMenu(this);
    }
    function onTip()
    {
    }
    function onEquip()
    {
    }
    function onGather()
    {
    }
    function onRelive()
    {
    }
    function onTransfer()
    {
    }
    function onStory()
    {
    }
    function onSoldier()
    {
    }
    function onCollection()
    {
    }
    const OFFY = 100;
    const MIDY = 200;
    const DARK_WIDTH = 128;
    function ChildMenuLayer(index, funcs, s, otherFunc){
        scene = s;
        functions = funcs;
        var height = len(functions)*OFFY;
        var h2 = len(otherFunc)*OFFY;
        var mH = max(height, h2);
        var offset = MIDY-mH/2;
        bg=sprite("dark.png").scale(100,100).size(DARK_WIDTH, height);
        if(index == 0){
            bg.anchor(0, 0).pos(0, offset);
        }
        else{
            bg.anchor(100, 0).pos(800, offset);
        }
        init();
        
        for(var i=0;i<len(funcs);i++){
            var model = buts.get(funcs[i]);

            trace("funcs", funcs[i]);
            var button = bg.addsprite(model[0]).scale(100,100).anchor(50,50).pos(DARK_WIDTH/2, OFFY/2+OFFY*i);
            new Button(button, model[1], null);
        }
    }
    /*
    function touchMenu(callback)
    {
        //removeSelf();
        callback();
    }
    */
    function newsFeedResponse(rid, rcode)
    {
        trace("newsFeedSuc", rid, rcode);
    }
    function uploadResponse(rid, rcode, con, param)
    {
        trace("uploadContent", rid, rcode, con, param);
        var pid = con.get("pid");
        ppy_postnewsfeed("just post a screenshot", null, pid, newsFeedResponse);
    }
    function photoFinish(node, bitmap, param)
    {
        var bytes = bitmap.bitmap2bytes("jpg");
        ppy_upload(dict([["photo",bytes]]), uploadResponse);
    }
    function onPhoto()
    {
        global.director.curScene.bg.bitmap(photoFinish)
    }
    /*
    建筑物只提供功能， 不应该假设 功能的来源 所以不应该操作关闭菜单
    而由菜单自己关闭自己---> 调用全局的关闭函数 来修改状态

    两个步骤：
        建筑物产生功能
        全局关闭菜单
    */
    function onAcc()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.doAcc();
    }
    function onForge()
    {
    }
    function onMakeDrug()
    {
    }
    /*
    关闭建筑的全局 控制view
    子菜单 自己关闭自己 
    而不是调用者清理

    因为卖出 和加速需要 弹出新的对话框 所有需要首先关闭旧的对话框
    */
    function onSell()
    {
        global.director.curScene.closeGlobalMenu(this);
        scene.doSell();
    }

    function showMenu()
    {
        bg.addaction(fadein(1000));
    }
    function hideMenu()
    {
        bg.addaction(fadeout(1000));
    }
    function onClicked(param)
    {
        trace("click", param) 

    }
    function onMap()
    {
        scene.ml.cancelAllMenu();
        //global.director.pushScene(new MapScene());    
        scene.onMap();
    }
    function onFriend()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new FriendDialog());
    }
    function onMail()
    {
        scene.ml.cancelAllMenu();
    }
    function onPlan()
    {
        scene.ml.cancelAllMenu();
        scene.doPlan(); 
    }
    function onRank()
    {
        scene.ml.cancelAllMenu();
        global.director.pushView(new GloryDialog());
    }
    function onRole()
    {
        scene.ml.cancelAllMenu();
        scene.onRole();
    }
    function onSetting()
    {
        scene.ml.cancelAllMenu();
    }
    function onStore()
    {
        scene.ml.cancelAllMenu();
        scene.onStore();
        //global.director.pushView(new Store(scene), 1, 0);
    }
}
