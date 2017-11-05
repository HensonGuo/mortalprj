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


public class SOperationOnlineMsg extends IMessageBase 
{
    public var cmdType : int;

    public var operObj : int;

    public var operValue : int;

    public var operValueEx : int;

    public var operValueEx2 : int;

    public var recordId : Number;

    public var operStr : String;

    public function SOperationOnlineMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SOperationOnlineMsg = new SOperationOnlineMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15052;

    override public function clone() : IMessageBase
    {
        return new SOperationOnlineMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(cmdType);
        __os.writeInt(operObj);
        __os.writeInt(operValue);
        __os.writeInt(operValueEx);
        __os.writeInt(operValueEx2);
        __os.writeLong(recordId);
        __os.writeString(operStr);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        cmdType = __is.readInt();
        operObj = __is.readInt();
        operValue = __is.readInt();
        operValueEx = __is.readInt();
        operValueEx2 = __is.readInt();
        recordId = __is.readLong();
        operStr = __is.readString();
    }
}
}
