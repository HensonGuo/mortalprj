// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SGuildWarehouseRecord
{
    public var endName : String;

    public var startName : String;

    public var itemCode : int;

    public var unit : int;

    public var amount : int;

    public var oper : EGuildWarehouseOper;

    public var operDt : Date;

    public function SGuildWarehouseRecord()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeString(endName);
        __os.writeString(startName);
        __os.writeInt(itemCode);
        __os.writeInt(unit);
        __os.writeInt(amount);
        oper.__write(__os);
        __os.writeDate(operDt);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        endName = __is.readString();
        startName = __is.readString();
        itemCode = __is.readInt();
        unit = __is.readInt();
        amount = __is.readInt();
        oper = EGuildWarehouseOper.__read(__is);
        operDt = __is.readDate();
    }
}
}
