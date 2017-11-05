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


public class SMapArea
{
    public var areaId : int;

    public var mapId : int;

    public var point : SPoint;

    public var name : String;

    [ArrayElementType("int")]
    public var plans : Array;

    public function SMapArea()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(areaId);
        __os.writeInt(mapId);
        point.__write(__os);
        __os.writeString(name);
        SeqIntHelper.write(__os, plans);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        areaId = __is.readInt();
        mapId = __is.readInt();
        point = new SPoint();
        point.__read(__is);
        name = __is.readString();
        plans = SeqIntHelper.read(__is);
    }
}
}
