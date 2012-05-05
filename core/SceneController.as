class SceneController
{
    var stack;
    var curSceneName;
    var sceneMaker;
    function SceneController(){
        sceneMaker=null;
        stack=[];
        curSceneName=null;
    }
    
    function init(sm){
        sceneMaker = sm;
    }
    
    function changeScene(toStr){
        if(sceneMaker == null)
            return;
        if(curSceneName != toStr){
            if(curSceneName==null){
                global.director.pushPage(sceneMaker.getScene(toStr),1);
                stack.append(toStr);
            }
            else{
                global.director.changePage(sceneMaker.getScene(toStr),1);
                stack[0] = toStr;
            }
            curSceneName=toStr;
        }
    }
    
    function openDialog(toStr){
        if(sceneMaker == null)
            return;
        if(curSceneName != toStr){
            global.director.pushPage(sceneMaker.getScene(toStr),2);
            stack.append(toStr);
            curSceneName=toStr;
        }
    }
    
    function closeDialog(fromStr){
        if(curSceneName == fromStr){
            global.director.popView();
            stack.pop();
            curSceneName = stack[len(stack)-1];
        }
    }
}