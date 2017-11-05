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

import Message.Game.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SPetUpdate extends IMessageBase 
{
    public var updateCode : int;

    public var updateType : int;

    public var uid : String;

    [ArrayElementType("SPet")]
    public var petsBaseInfo : Array;

    public function SPetUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPetUpdate = new SPetUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15093;

    override public function clone() : IMessageBase
    {
        return new SPetUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(updateCode);
        __os.writeInt(updateType);
        __os.writeString(uid);
        SeqPetHelper.write(__os, petsBaseInfo);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        updateCode = __is.readInt();
        updateType = __is.readInt();
        uid = __is.readString();
        petsBaseInfo = SeqPetHelper.read(__is);
    }
}
}

