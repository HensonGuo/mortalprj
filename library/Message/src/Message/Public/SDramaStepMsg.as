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


public class SDramaStepMsg extends IMessageBase 
{
    public var dramaCode : int;

    public var step : int;

    public var stepType : int;

    public function SDramaStepMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SDramaStepMsg = new SDramaStepMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 6000;

    override public function clone() : IMessageBase
    {
        return new SDramaStepMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(dramaCode);
        __os.writeInt(step);
        __os.writeInt(stepType);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        dramaCode = __is.readInt();
        step = __is.readInt();
        stepType = __is.readInt();
    }
}
}
