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
    ["hammer", ["menu_button_hammer.png", onHammer]],
    ["makeDrug", ["menu_button_makeDrug.png", onMakeDrug]],
    ["acc", ["menu_button_acc.png", onAcc]],
    ["sell", ["menu_button_sell.png", onSell]],
    ]);

    function ChildMenuLayer(index, funcs, s){
        scene = s;
        functions = funcs;
        bg=sprite("dark.png").scale(100,100).size(128,480);
        if(index == 0){
            bg.anchor(0, 0).pos(0, 0);
        }
        else{
            bg.anchor(100, 0).pos(800, 0);
        }
        init();
        
        for(var i=0;i<len(funcs);i++){
            var model = buts.get(funcs[i]);

            var button = bg.addsprite(model[0]).scale(100,100).anchor(50,50).pos(64, 65+92*i);
            new Button(button, model[1], null);
        }
    }

    function onPhoto()
    {
    }
    function onAcc()
    {
        scene.doAcc();
    }
    function onHammer()
    {
    }
    function onMakeDrug()
    {
    }
    function onSell()
    {
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
        global.director.pushScene(new MapScene());    
    }
    function onFriend()
    {
    }
    function onMail()
    {
    }
    function onPlan()
    {
    }
    function onRank()
    {
    }
    function onRole()
    {
    }
    function onSetting()
    {
    }
    function onStore()
    {
        global.director.pushView(new Store(scene), 1, 0);
    }
}
