// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//math.NumberUtil

package frEngine.math{
    public class NumberUtil {


        public static function rnd0_1():Number{
            return (Math.random());
        }

        public static function rndMinus1_1():Number{
            return ((Math.random() - Math.random()));
        }

        public static function rndMinMax(_arg1:Number, _arg2:Number):Number{
            return ((_arg1 + (Math.random() * (_arg2 - _arg1))));
        }

        public static function rndMinMaxInt(_arg1:int, _arg2:int):int{
            return (Math.round(rndMinMax(_arg1, _arg2)));
        }

        public static function sin0_1(_arg1:Number):Number{
            return ((0.5 + (Math.sin(_arg1) * 0.5)));
        }

        public static function toLeftHandle(_arg1:Number):Number{
            return (-(_arg1));
        }

        public static function mylerp(_arg1:Number, _arg2:Number, _arg3:Number):Number{
            return ((_arg1 + (_arg3 * (_arg2 - _arg1))));
        }


    }
}//package math

