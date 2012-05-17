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
    function MenuLayer(s) {
        scene = s;
        trace("pushMenuLayer");
        menus =new Array(null,null);
        bg = node();
        banner = bg.addsprite("menu_back.png").scale(100,100).size(800,111).anchor(0,100).pos(0,480).rotate(0);
        init();

        initData();

        taskbutton = banner.addsprite("task.png").scale(100,100).size(93,87).anchor(0,0).pos(11,22).rotate(0);
        expfiller = banner.addsprite("exp_filler.png").scale(100,100).size(100,8).anchor(0,0).pos(147,51).rotate(0);
        expback = banner.addsprite("exp_star.png").scale(100,100).size(37,35).anchor(0,0).pos(138,34).rotate(0);
        collectionbutton = banner.addsprite("collection.png").scale(100,100).size(46,34).anchor(0,0).pos(230,74).rotate(0);
        //Un5 = banner.addsprite("silver.png").scale(100,100).size(29,28).anchor(50,50).pos(299,93).rotate(0);
        //Un6 = banner.addsprite("gold.png").scale(100,100).size(33,32).anchor(50,50).pos(549,93).rotate(0);
        rechargebutton = banner.addsprite("recharge.png").scale(100,100).size(84,33).anchor(50,50).pos(477,93).rotate(0);
        menubutton = banner.addsprite("menu_button.png").scale(100,100).size(112,100).anchor(0,100).pos(686,111).rotate(0);
        new Button(menubutton, onClicked, 0);

    }
    var silverText;
    var goldText;
    function initData()
    {
        silverText = banner.addlabel(str(global.user.getValue("silver")), null, 18).anchor(0, 50).pos(337, 92).color(100, 100, 100);
        goldText = banner.addlabel(str(global.user.getValue("gold")), null, 18).anchor(0, 50).pos(592, 92).color(100, 100, 100)
    }
    var building = 0;
    function beginBuild()
    {
        building = 1; 
        bg.visible(0);
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
    function finishBuild()
    {
        building = 0;
        bg.visible(1);
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
    override function enterScene()
    {
        global.user.addListener(this);
        //global.controller.addHide(this);
    }
    override function exitScene()
    {
        //global.controller.removeHide(this);
        global.user.removeListener(this);
    }
    function updateValue(res)
    {
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
        if(building)
            return;
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
        if(building)
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
    
    
    function draw_func(index, funcs){
        //unsupported param
        if(index>=2||index<0||len(funcs) <= 0 || len(funcs)>4){
            return;
        }
        if(menus[index] != null){
            removeChild(menus[index]);
        }
        menus[index] = new ChildMenuLayer(index,funcs, scene);
        addChildZ(menus[index],-1);
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
