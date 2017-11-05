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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMapSharp
{
    public var sharpId : int;

    [ArrayElementType("SPoint")]
    public var points : Array;

    public var type : EMapPointType;

    public function SMapSharp()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(sharpId);
        SeqPointHelper.write(__os, points);
        type.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        sharpId = __is.readInt();
        points = SeqPointHelper.read(__is);
        type = EMapPointType.__read(__is);
    }
}
}

