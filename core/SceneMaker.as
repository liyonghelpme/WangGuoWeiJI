class SceneMaker
{
    function getScene(str){
        if(str=="operation"){
            return new OperationScene();
        }
        else if(str=="map"){
            return new MapScene();
        }
        else if(str=="store"){
            return new Store();
        }
        else{
            return null;
        }
    }
}