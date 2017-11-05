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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMountUpdate extends IMessageBase 
{
    public var updateCode : int;

    public var updateType : int;

    public var uid : String;

    [ArrayElementType("SPublicMount")]
    public var mounts : Array;

    public function SMountUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SMountUpdate = new SMountUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15095;

    override public function clone() : IMessageBase
    {
        return new SMountUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(updateCode);
        __os.writeInt(updateType);
        __os.writeString(uid);
        SeqPublicMountHelper.write(__os, mounts);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        updateCode = __is.readInt();
        updateType = __is.readInt();
        uid = __is.readString();
        mounts = SeqPublicMountHelper.read(__is);
    }
}
}

