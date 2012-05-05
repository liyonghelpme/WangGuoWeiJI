class ButtonModel
{
    var imageSrc;
    var func;
    
    function onclicked(param){
        if(func == null||func.get("funcType",null)==null){
            return 0;
        }
        var functype = func.get("funcType");
        if(functype == "changeScene"){
            global.scene.changeScene(func.get("funcParam"));
        }
        else if(functype == "openDialog"){
            global.scene.openDialog(func.get("funcParam"));
        }
    }
    
}