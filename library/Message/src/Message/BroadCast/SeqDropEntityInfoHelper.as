// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.BroadCast{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class SeqDropEntityInfoHelper
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
                var __v1 : SDropEntityInfo = __v[__i0] as SDropEntityInfo;
                __v1.__write(__os);
            }
        }
    }

    public static function read( __is : SerializeStream ) : Array
    {
        var __v : Array ;
        const __len0 : int = __is.readSize();
        __is.startSeq(__len0, 41);
        __v = new Array;
        for( var __i0 : int = 0; __i0 < __len0; __i0++)
        {
            var __v1 : SDropEntityInfo = new SDropEntityInfo();
            __v1.__read(__is);
            __v[__i0] = __v1 ;
            __is.checkSeq();
            __is.endElement();
        }
        __is.endSeq(__len0);
        return __v;
    }
}
}
