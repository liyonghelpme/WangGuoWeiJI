class ChildMenuLayer extends MyNode
{
    var functions;
    function ChildMenuLayer(index, funcs){
        functions = funcs;
        bg=sprite("dark.png").scale(100,100).size(128,480);
        if(index == 0){
            bg.anchor(0,100).pos(0,111);
        }
        else{
            bg.anchor(100,100).pos(800,111);
        }
        init();
        
        for(var i=0;i<len(funcs);i++){
            var model = global.data.getModel(funcs[i]);
            if(model == null){
                funcs.pop(i);
                i--;
                continue;
            }
            var button = bg.addsprite(model.imageSrc).scale(100,100).anchor(50,50).pos(64,46+92*i);
            //button.addlabel(model.imageSrc,null,30).color(0,0,0,100);
            global.touchManager.addTargeted(new ButtonDelegate(button,0,1,model,i),500,1);
        }
    }
}