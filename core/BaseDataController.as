class BaseDataController
{
    var cache;
    function BaseDataController(){
        cache = dict();
        init();
    }
    
    function init(){
        var data = ["{'name':'map','value':{'imageSrc':'menu_button_map.png','func':{'funcType':'changeScene','funcParam':'map'}}}",
                    "{'name':'friend','value':{'imageSrc':'menu_button_friend.png'}}",
                    "{'name':'mail','value':{'imageSrc':'menu_button_mail.png'}}",
                    "{'name':'plan','value':{'imageSrc':'menu_button_plan.png'}}",
                    "{'name':'rank','value':{'imageSrc':'menu_button_rank.png'}}",
                    "{'name':'role','value':{'imageSrc':'menu_button_role.png'}}",
                    "{'name':'setting','value':{'imageSrc':'menu_button_setting.png'}}",
                    "{'name':'store','value':{'imageSrc':'menu_button_store.png','func':{'funcType':'openDialog','funcParam':'store'}}}"];
        var i;
        for(i=0;i<len(data);i++){
            var di = json_loads(data[i]);
            var model = new ButtonModel();
            model.imageSrc = di.get("value").get("imageSrc");
            model.func = di.get("value").get("func",null);
            cache.update(di.get("name"),model);
        }
    }
    
    function getModel(str){
        return cache.get(str,null);
    }
}