class SensorController
{
    var sensorVal;
    var callbacks;
    function SensorController()
    {
        sensorVal = [];
        callbacks = [];
        c_sensor(SENSOR_ACCELEROMETER, onSensor);
    }
    function onSensor(stype, ax, ay, az)
    {
        var acc = sqrt(ax*ax+ay*ay+az*az);
        //trace("accelemeter", acc);
        if(len(sensorVal) == 0)
        {
            sensorVal.append(acc);
            senBegan(acc);
        }
        else
        {
            //采样5次 如果平均值小于 10000 则结束
            if(len(sensorVal) > 5)
            {
                sensorVal.pop(0);
            }
            sensorVal.append(acc);

            var avg = sum(sensorVal)/len(sensorVal);
            //trace("sensor avg", avg);

            if(len(sensorVal) > 5 && avg < 10000)
                senEnded(acc)
            else
                senDone(acc);
        }
    }
    function addCallback(obj)
    {
        callbacks.append([obj, 0]);
    }
    function removeCallback(obj)
    {
        for(var i = 0; i < len(callbacks); i++)
        {
            if(callbacks[i][0] == obj)
            {
                callbacks[i][1] = 1;
                break;
            }
        }
    }
    function senBegan(acc)
    {
        for(var i = 0; i < len(callbacks);)
        {
            if(callbacks[i][1] == 1)
                callbacks.pop(i)
            else
            {
                callbacks[i][0].senBegan(acc);
                i++;
            }
        }
    }
    function senDone(acc)
    {
        for(var i = 0; i < len(callbacks);)
        {
            if(callbacks[i][1] == 1)
                callbacks.pop(i)
            else
            {
                callbacks[i][0].senDone(acc);
                i++;
            }
        }
    }
    function senEnded(acc)
    {
        for(var i = 0; i < len(callbacks);)
        {
            if(callbacks[i][1] == 1)
                callbacks.pop(i)
            else
            {
                callbacks[i][0].senEnded(acc);
                i++;
            }
        }
    }
}
