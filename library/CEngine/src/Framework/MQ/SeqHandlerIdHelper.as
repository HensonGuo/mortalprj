// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Framework.MQ{

import Engine.RMI.*;

import Framework.Holder.*;
import Framework.MQ.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.Exception;
import Framework.Util.StringFun;

import flash.utils.ByteArray;



public class SeqHandlerIdHelper
{
    public static function write( __os : SerializeStream , __v : Array ) : void 
    {
        if(__v == null)
        {
            __os.writeSize(0);
        }
        else
        {
            __os.writeSize(__v.length);
            for( var __i0: int = 0; __i0 < __v.length; __i0++)
            {
                var __v1 : HandlerId = __v[__i0] as HandlerId;
                __v1.__write(__os);
            }
        }
    }
	private static var _testAry:Array = [];
    public static function read( __is : SerializeStream ) : Array
    {
		_testAry.length = 0;
        var __v : Array = _testAry;
        const __len0 : int = __is.readSize();
        __is.checkFixedSeq(__len0, 8);
        for( var __i0 : int = 0; __i0 < __len0; __i0++)
        {
            var __v1 : HandlerId = new HandlerId();
            __v1.__read(__is);
            __v[__i0] = __v1 ;
        }
        return __v;
    }
}
}