// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class DictByteByteHelper
{
    public static function write( __os : SerializeStream , __v : Dictionary ) : void
    {
        if(__v == null)
        {
            __os.writeSize(0);
        }
        else
        {
            var __count:int = 0;
            for( var __j : Object in __v )
            {
                __count ++ ;
            }
            __os.writeSize(__count);
            for( var __i :Object in __v)
            {
                __os.writeByte(int( __i));
                __os.writeByte(int( __v[ __i ]));
            }
        }
    }

    public static function read( __is : SerializeStream ) : Dictionary
    {
        var __v : Dictionary = new Dictionary();
        var __sz1 : int = __is.readSize();
        for( var __i1 : int = 0; __i1 < __sz1; __i1++)
        {
            var __key:int = __is.readByte();
            var __value:int = __is.readByte();
            __v[__key] = __value;
        }
        return __v;
    }
}
}
