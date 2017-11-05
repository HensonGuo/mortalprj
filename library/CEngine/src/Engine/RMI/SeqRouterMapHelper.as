// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Engine.RMI{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;



public class SeqRouterMapHelper
{
    public static function write( __os : SerializeStream , __v : Array ) : void 
    {
        __os.writeIntSeq(__v);
    }

    public static function read( __is : SerializeStream ) : Array
    {
        var __v : Array ;
        __v = __is.readIntSeq();
        return __v;
    }
}
}
