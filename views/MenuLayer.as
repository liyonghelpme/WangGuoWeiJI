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

    function MenuLayer() {
        trace("pushMenuLayer");
        menus =new Array(null,null);
        bg = sprite("menu_back.png").scale(100,100).size(800,111).anchor(0,100).pos(0,480).rotate(0);
        init();

        taskbutton = bg.addsprite("task.png").scale(100,100).size(93,87).anchor(0,0).pos(11,22).rotate(0);
        expfiller = bg.addsprite("exp_filler.png").scale(100,100).size(100,8).anchor(0,0).pos(147,51).rotate(0);
        expback = bg.addsprite("exp_star.png").scale(100,100).size(37,35).anchor(0,0).pos(138,34).rotate(0);
        collectionbutton = bg.addsprite("collection.png").scale(100,100).size(46,34).anchor(0,0).pos(230,74).rotate(0);
        Un5 = bg.addsprite("silver.png").scale(100,100).size(29,28).anchor(50,50).pos(299,93).rotate(0);
        Un6 = bg.addsprite("gold.png").scale(100,100).size(33,32).anchor(50,50).pos(549,93).rotate(0);
        rechargebutton = bg.addsprite("recharge.png").scale(100,100).size(84,33).anchor(50,50).pos(477,93).rotate(0);
        menubutton = bg.addsprite("menu_button.png").scale(100,100).size(112,100).anchor(0,100).pos(686,111).rotate(0);
        new Button(menubutton, onClicked, 0);
    }
    
    
    function draw_func(index, funcs){
        //unsupported param
        if(index>=2||index<0||len(funcs) <= 0 || len(funcs)>4){
            return;
        }
        if(menus[index] != null){
            removeChild(menus[index]);
        }
        menus[index] = new ChildMenuLayer(index,funcs);
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
