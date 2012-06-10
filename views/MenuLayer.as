class MenuLayer extends MyNode
{
    var taskbutton;
    var expfiller;
    var expback;
    var collectionbutton;
    var Un5;
    var Un6;
    var rechargebutton;
    var menubutton;
    
    var menus;
    var scene;

    var banner;
    var MainMenuFunc = dict([
    [0,["map","rank","plan","setting"]],
    [1,["role","store","friend","mail"]],
    ]);
    /*
    不要设定图片的size属性否则图片会被缩放
    */
    function MenuLayer(s) {
        scene = s;
        trace("pushMenuLayer");
        menus =new Array(null,null);
        bg = node();
        banner = bg.addsprite("menu_back.png").scale(100,100).anchor(0,100).pos(0,480).rotate(0);
        init();

        initData();

        taskbutton = banner.addsprite("task.png").scale(100,100).size(93,87).anchor(0,0).pos(11,22).rotate(0);
        expfiller = banner.addsprite("exp_filler.png").scale(100,100).anchor(0,0).pos(143,57).rotate(0);
        expback = banner.addsprite("exp_star.png").scale(100,100).size(37,35).anchor(0,0).pos(138,34).rotate(0);
        collectionbutton = banner.addsprite("collection.png").scale(100,100).size(46,34).anchor(0,0).pos(230,74).rotate(0);
        rechargebutton = banner.addsprite("recharge.png").scale(100,100).size(84,33).anchor(50,50).pos(477,93).rotate(0).setevent(EVENT_TOUCH, openCharge);
        menubutton = banner.addsprite("menu_button.png").scale(100,100).size(112,100).anchor(0,100).pos(686,111).rotate(0);
        new Button(menubutton, onClicked, 0);


    }
    /*
    显示商店充值页面
    */
    function openCharge()
    {
        var st = new Store(scene);
        st.changeTab(1);
        global.director.pushView(st);
    }
    var silverText;
    var goldText;
    var gloryText;
    /*
    初始化文本数据之后注册 用户数据的监听器
    */
    function initData()
    {
        silverText = banner.addlabel(str(global.user.getValue("silver")), null, 18).anchor(0, 50).pos(336, 99).color(100, 100, 100);
        goldText = banner.addlabel(str(global.user.getValue("gold")), null, 18).anchor(0, 50).pos(591, 99).color(100, 100, 100)
        gloryText = banner.addlabel(getStr("glory", null), null, 18).anchor(50, 50).pos(167, 99).color(100, 100, 100);

    }
    var building = 0;
    /*
    通用的隐藏菜单的接口
    */
    function beginBuild()
    {
        //building = 1; 
        //bg.visible(0);
        removeSelf();
        /*
        for(var i = 0; i < len(menus); i++)
        {
            if(menus[i] != null)
            {
                menus[i].bg.visible(0);
            }
        }
        */
    }
    /*
    通用的显示菜单的接口
    */
    function finishBuild()
    {
        scene.addChild(this);
        //building = 0;
        //bg.visible(1);
        /*
        for(var i = 0; i < len(menus); i++)
        {
            if(menus[i] != null)
            {
                menus[i].bg.visible(1);
            }
        }
        */
    }
    /*
    进入场景之后 需要更新显示的用户数据
    防止没有 事件导致无法更新
    */
    override function enterScene()
    {
        super.enterScene();
        trace("menuLayer enterScene");
        global.user.addListener(this);
        updateValue(global.user.resource);
    }
    override function exitScene()
    {
        global.user.removeListener(this);
        super.exitScene();
    }
    /*
    用户更新数据的显示接口
    */
    function updateValue(res)
    {
        trace("update Value");
        silverText.text(str(res.get("silver")));
        goldText.text(str(res.get("gold")));
    }
    var visLock = 0;
    function showMenu()
    {
        //if(visLock == 0)
        //{
        //    visLock = 1;
        //build building
        //if(building)
        //    return;
        bg.addaction(fadein(1000));
        /*
        for(var i = 0; i < len(menus); i++)
        {
            if(menus[i] != null)
            {
                menus[i].showMenu();
            }
        }
        */
        //}
    }
    function hideMenu()
    {
        //if(visLock == 0)
        //{
        //    visLock = 1;
        //if(building)
        //    return;
        if(ins == 0)
            return;
        bg.addaction(fadeout(1000));
        /*
        for(var i = 0; i < len(menus); i++)
        {
            if(menus[i] != null)
                menus[i].hideMenu();
        }
        */
        //}
    }
    
    
    /*
    需要确保两个子菜单的位置相同高度， 所以需要传递另一个菜单的高度
    */
    function draw_func(index, funcs){
        //unsupported param
        if(index>=2||index<0||len(funcs) <= 0 || len(funcs)>4){
            return;
        }
        if(menus[index] != null){
            removeChild(menus[index]);
        }
        menus[index] = new ChildMenuLayer(index,funcs, scene, MainMenuFunc.get(1-index));
        addChildZ(menus[index],-1);
    }
    
    function cancelAllMenu()
    {
        cancel_func(0);
        cancel_func(1);
    }
    function cancel_func(index){
        if(menus[index]!=null){
            removeChild(menus[index]);
            menus[index] = null;
        }
    }
    
    function onClicked(param){
        if(param==0){
            if(menus[0] == null){
                draw_func(0,["map","rank","plan","setting"]);
                draw_func(1,["role","store","friend","mail"]);
            }
            else{
                cancel_func(0);
                cancel_func(1);
            }
        }
    }
}
