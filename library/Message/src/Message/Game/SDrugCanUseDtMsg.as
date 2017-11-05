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


public class SDrugCanUseDtMsg extends IMessageBase 
{
    public var canUseContinueLifeDrugDt : Date;

    public var canUseContinueManaDrugDt : Date;

    public var canUseInstantLifeDrugDt : Date;

    public var canUseInstantManaDrugDt : Date;

    public var canUseLifeBagDrugDt : Date;

    public var canUseManaBagDrugDt : Date;

    public var canUseExpDrugDt : Date;

    public var canUseContinuePetLifeDrugDt : Date;

    public var canUsePetLifeBagDrugDt : Date;

    public function SDrugCanUseDtMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SDrugCanUseDtMsg = new SDrugCanUseDtMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15073;

    override public function clone() : IMessageBase
    {
        return new SDrugCanUseDtMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeDate(canUseContinueLifeDrugDt);
        __os.writeDate(canUseContinueManaDrugDt);
        __os.writeDate(canUseInstantLifeDrugDt);
        __os.writeDate(canUseInstantManaDrugDt);
        __os.writeDate(canUseLifeBagDrugDt);
        __os.writeDate(canUseManaBagDrugDt);
        __os.writeDate(canUseExpDrugDt);
        __os.writeDate(canUseContinuePetLifeDrugDt);
        __os.writeDate(canUsePetLifeBagDrugDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        canUseContinueLifeDrugDt = __is.readDate();
        canUseContinueManaDrugDt = __is.readDate();
        canUseInstantLifeDrugDt = __is.readDate();
        canUseInstantManaDrugDt = __is.readDate();
        canUseLifeBagDrugDt = __is.readDate();
        canUseManaBagDrugDt = __is.readDate();
        canUseExpDrugDt = __is.readDate();
        canUseContinuePetLifeDrugDt = __is.readDate();
        canUsePetLifeBagDrugDt = __is.readDate();
    }
}
}
