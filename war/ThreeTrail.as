class ThreeTrail extends MyNode
{
    function ThreeTrail(ft, startPos, endPos, dir)
    {
        bg = node();
        init();
        var particleId = 1320;

        var pData = getData(PARTICLES, 1320);

        var metor2 = dict([
                      ["duration", ft], //["gravity_x",200], 
                      ["speed", getParam("arrowSpeed")], ["speedVar", getParam("arrowSpeedVar")], ["angle",90], ["angle_var",360], 
                      ["particle_life",1000], ["particle_life_var",200], 
                      ["start_color_red", pData["start_color_red"]], ["start_color_green", pData["start_color_green"]], ["start_color_blue", pData["start_color_blue"]], 
                      ["start_color_alpha",255], 
                      //["start_color_var_blue",51], ["start_color_var_alpha",26], ["finish_color_alpha ",255],
                      ["start_particle_size", pData["startSize"]], ["start_particle_size_var", pData["startSizeVar"]], ["finish_particle_size",-1], 
                      ["blend_additive",1],
                      //["finish_color_alpha", 0],
                      ["emission_rate", 20],
                        ["max_particles", 100],
                      ]);

        var p42 = bg.addparticle(metor2).texture("s"+str(particleId)+"e"+str(dir)+".png").pos(startPos[0]+pData["offX"], startPos[1]+pData["offY"]);//.anchor(50, 50);
        p42.addaction(moveto(ft, endPos[0], endPos[1]+pData["offY"]));
        p42.start();

        pData = getData(PARTICLES, 1321);
        
        metor2 = dict([
                      ["duration", ft], //["gravity_x",200], 
                      ["speed", getParam("arrowSpeed")], ["speedVar", getParam("arrowSpeedVar")], ["angle",90], ["angle_var",360], 
                      ["particle_life",1000], ["particle_life_var",200], 
                      ["start_color_red", pData["start_color_red"]], ["start_color_green", pData["start_color_green"]], ["start_color_blue", pData["start_color_blue"]], 
                      ["start_color_alpha",255], 
                      //["start_color_var_blue",51], ["start_color_var_alpha",26], ["finish_color_alpha ",255],
                      ["start_particle_size", pData["startSize"]], ["start_particle_size_var", pData["startSizeVar"]], ["finish_particle_size",-1], 
                      ["blend_additive",1],
                      //["finish_color_alpha", 0],
                      ["emission_rate", 20],
                        ["max_particles", 100],
                      ]);

        p42 = bg.addparticle(metor2).texture("s"+str(particleId)+"e"+str(dir)+".png").pos(startPos[0]+pData["offX"], startPos[1]+pData["offY"]);//.anchor(50, 50);
        p42.addaction(moveto(ft, endPos[0], endPos[1]+pData["offY"]));
        p42.start();
        
        pData = getData(PARTICLES, 1322);

        metor2 = dict([
                      ["duration", ft], //["gravity_x",200], 
                      ["speed", getParam("arrowSpeed")], ["speedVar", getParam("arrowSpeedVar")], ["angle",90], ["angle_var",360], 
                      ["particle_life",1000], ["particle_life_var",200], 
                      ["start_color_red", pData["start_color_red"]], ["start_color_green", pData["start_color_green"]], ["start_color_blue", pData["start_color_blue"]], 
                      ["start_color_alpha",255], 
                      //["start_color_var_blue",51], ["start_color_var_alpha",26], ["finish_color_alpha ",255],
                      ["start_particle_size", pData["startSize"]], ["start_particle_size_var", pData["startSizeVar"]], ["finish_particle_size",-1], 
                      ["blend_additive",1],
                      //["finish_color_alpha", 0],
                      ["emission_rate", 20],
                        ["max_particles", 100],
                      ]);

        p42 = bg.addparticle(metor2).texture("s"+str(particleId)+"e"+str(dir)+".png").pos(startPos[0]+pData["offX"], startPos[1]+pData["offY"]);//.anchor(50, 50);
        p42.addaction(moveto(ft, endPos[0], endPos[1]+pData["offY"]));
        p42.start();

    }
}
